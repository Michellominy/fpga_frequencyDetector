library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity AC97 is
	port(
		AUD_BIT_CLK : in std_logic;
		AUD_SDI : in std_logic;
		AUD_SDO : out std_logic;
		AUD_SYNC : out std_logic;
		AUD_RESET : out std_logic;
		AUD_reset_btn : in std_logic;
		clk : in  std_logic;
		PCM_data_ready : out std_logic;
		PCM_data : out pcm_sample_array;
		update_PCM_data : in std_logic
	);
end AC97;

architecture AC97_arch of AC97 is

	signal bit_count : std_logic_vector(7 downto 0);
	
	signal aud_in_data : std_logic_vector(pcm_data_length-1 downto 0);
	signal aud_data_array : pcm_sample_array;
	signal aud_data_array_full : std_logic := '0';
	
	signal rst_counter : integer range 0 to 4097;    -- counter to set ac97_reset high for ac97 init
	signal Q1, Q2 : std_logic;
	signal ready_sig : std_logic;
	
	type AUD_reset_state_type is (start, mic_vol_adjust, pcm_out_vol_adjust, rec_gain_adjust, rec_select_adjust, gen_purpose, pcm_adc_rate, reset_done);
	signal cur_state : AUD_reset_state_type;
	signal next_state : AUD_reset_state_type := start;

	signal valid_control_data :std_logic := '0';
	signal reg_RW : std_logic;
	signal reg_address : std_logic_vector(6 downto 0);
	signal reg_data : std_logic_vector(15 downto 0);
	
	-- [0, 15]  slot 0
	-- [16, 35] slot 1
	-- [36, 55] slot 2
	-- [56, 75] slot 3
	-- [76, 95] slot 4
	-- [96, 115] slot 5
	
begin
	
	process (clk, AUD_reset_btn)
	begin
		if (clk'event and clk = '1') then
			if AUD_reset_btn = '1' then
				rst_counter <= 0;
				AUD_RESET <= '0'; -- active low signal
			elsif rst_counter = 3789 then  
				AUD_RESET <= '1';
				rst_counter <= 0;
			else
				rst_counter <= rst_counter + 1;
			end if;
		end if;
	end process;
	
	process(AUD_BIT_CLK, AUD_reset_btn, bit_count) -- Activate frame (sync), Increment bit_count 
	begin

		if(AUD_reset_btn = '1') then -- RESET button control
				bit_count <= "00000000";

		elsif(AUD_BIT_CLK'event and AUD_BIT_CLK = '1') then
	
			if(bit_count = "11111111") then -- SYNC control
				AUD_SYNC <= '1';
			end if;

			if(bit_count = "00001111") then -- 16/256
				AUD_SYNC <= '0';
			end if;
			
			if(bit_count >= "00000000" and bit_count <= "00001111") then -- slot 0
				case bit_count is
					when "00000000" => AUD_SDO <= valid_control_data;      	-- Valid data in at least one slot.
					when "00000001" => AUD_SDO <= valid_control_data;			-- Valid Control Address
					when "00000010" => AUD_SDO <= valid_control_data;  		-- Valid Control data 
					when others => AUD_SDO <= '0';
				end case;
			elsif (bit_count >= "00010000") and (bit_count <= "00010111") then -- slot 1 (16 <= ... <= 23)
				case bit_count is
					when "00010000" => AUD_SDO <= reg_RW; -- Read = 1, Write = 0
					when others => AUD_SDO <= reg_address(23 - to_integer(unsigned(bit_count)));
				end case;
			elsif (bit_count >= "00100100") and (bit_count <= "00110011") then -- slot 2 36 <= ... <= 51
				AUD_SDO <= reg_data(51 - to_integer(unsigned(bit_count)));
			end if;
			
			bit_count <= std_logic_vector(unsigned(bit_count) + 1);
		end if;
	end process;
	
	process(AUD_BIT_CLK) -- Audio in
	variable aud_data_count : integer := 0;
	begin
		if(AUD_BIT_CLK'event and AUD_BIT_CLK = '0') then
			if((bit_count >= "00111000") and (bit_count <= "01001001")) then -- Slot 3 : (56 <= bit_count <= 73)
				aud_in_data(73 - to_integer(unsigned(bit_count))) <= AUD_SDI;
			
			elsif (bit_count = "01100000" and update_PCM_data = '1') then -- Begining of slot 5 (96)
				pcm_data(aud_data_count) <= std_logic_vector(signed(aud_in_data)-550);
				aud_data_count := aud_data_count + 1;
				if (aud_data_count = pcm_sample_size) then
					pcm_data_ready <= '1';
					aud_data_count := 0;
				else
					pcm_data_ready <= '0';
				end if;
			elsif (update_PCM_data = '0') then
				pcm_data_ready <= '0';
			end if;
		end if;
	end process;
	
	process (clk, AUD_reset_btn, bit_count)
	begin
		if(clk'event and clk = '1') then
			Q2 <= Q1;
			if(bit_count = "00000000") then
				Q1 <= '0';
				Q2 <= '0';
			elsif(bit_count >= "10000001") then -- slot 5
				Q1 <= '1';
			end if;
			ready_sig <= Q1 and not Q2;
		end if;
	end process;
	
	process(clk, AUD_reset_btn, ready_sig)
	begin
		if(clk'event and clk = '1') then
			if(AUD_reset_btn = '1') then
				cur_state <= start;
			elsif(ready_sig = '1') then
				cur_state <= next_state;
			end if;
		end if;
	end process;
	
	process(cur_state, next_state)
	begin
		case cur_state is
			when start =>
				next_state <= mic_vol_adjust;
			when mic_vol_adjust =>
				valid_control_data <= '1';
				reg_RW <= '0'; -- Write
				reg_address <= "0001110"; -- 0Eh
				reg_data <= "0000000000001000"; -- 00008h, 0dB gain
				next_state <= pcm_out_vol_adjust;
			when pcm_out_vol_adjust =>
				valid_control_data <= '1';
				reg_RW <= '0'; -- Write
				reg_address <= "0011000"; -- 18h
				reg_data <= "0000100000001000"; -- 0808h, 0dB gain
				next_state <= rec_select_adjust;
			when rec_select_adjust =>
				valid_control_data <= '1';
				reg_RW <= '0'; -- Write
				reg_address <= "0011010"; -- 1Ah
				reg_data <= "0000000000000000"; -- 0000h, MIC
				next_state <= rec_gain_adjust;
			when rec_gain_adjust =>
				valid_control_data <= '1';
				reg_RW <= '0'; -- Write
				reg_address <= "0011100"; -- 1Ch
				reg_data <= "0000000000000000"; -- 0000h, 0dB gain
				next_state <= gen_purpose;
			when gen_purpose =>
				valid_control_data <= '1';
				reg_RW <= '0'; -- Write
				reg_address <= "0100000"; -- 20h
				reg_data <= "1000000000000000"; -- 8000h, 3D bypassed
				next_state <= pcm_adc_rate;
			when pcm_adc_rate =>
				valid_control_data <= '1'; -- TODO: automatically configure sample rate
				reg_RW <= '0'; -- Write
				reg_address <= "0110010"; -- 32h
				reg_data <= "1011101110000000"; -- BB80h, 48khz
				next_state <= reset_done;
			when reset_done =>
				valid_control_data <= '0';
				next_state <= reset_done;
		end case;	
	end process;
	
end AC97_arch;