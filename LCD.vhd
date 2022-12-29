library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.common.all;

entity LCD is
	port(
		to_LCD: out  std_logic_vector(7 downto 0);
		RS : out std_logic;
		RW : out std_logic;
		clk : in std_logic;
		E : out std_logic;
		reset : in std_logic;
		ready_sig : out std_logic;
		controller_data_ready : in std_logic;
		from_controller: in std_logic_vector(9 downto 0)
	);
end LCD;

architecture LCD_arch of LCD is
		type LCD_init_state_type is (start ,power_on, func_set, display_control, display_clear, entry_mode_set, init_complete, ready, sending);
		signal cur_state : LCD_init_state_type := start;
begin
	process(reset, clk)	-- startup sequence
	VARIABLE clk_count : INTEGER := 0; --event counter for timing
	begin
		if(reset = '1') then
			cur_state <= power_on;
			clk_count := 0;
			ready_sig <= '0';
		elsif(clk'event and clk = '1') then
			case cur_state IS
				when start =>
					cur_state <= start;
				when power_on =>
					if(clk_count >= 40000 * clk_freq) then	-- wait 40 ms
						cur_state <= func_set;
						to_LCD<= "00000000";
						clk_count := 0;
						E <= '0';
					else
						clk_count := clk_count + 1;
					end if;
				when func_set =>
					if(clk_count < 10 * clk_freq) then
						clk_count := clk_count + 1;
						RS <= '0';
						RW <= '0';
						E <= '1';
						to_LCD<= "00111100";
					elsif(clk_count < 37 * clk_freq) then
						E <= '0';
						to_LCD<= "00000000";
						clk_count := clk_count + 1;
					else	--  > 37 us
						cur_state <= display_control;
						clk_count := 0;
					end if;
				when display_control =>
					if(clk_count < 10 * clk_freq) then
						RS <= '0';
						RW <= '0';
						E <= '1';
						to_LCD<= "00001110";
						clk_count := clk_count + 1;
					elsif(clk_count < 37 * clk_freq) then
						E <= '0';
						to_LCD<= "00000000";
						clk_count := clk_count + 1;
					else	--  > 37 us
						cur_state <= display_clear;
						clk_count := 0;
					end if;
				when display_clear =>
					if(clk_count < 10 * clk_freq) then
						RS <= '0';
						RW <= '0';
						E <= '1';
						to_LCD<= "00000001";
						clk_count := clk_count + 1;
					elsif(clk_count < 1520 * clk_freq) then
						E <= '0';
						to_LCD<= "00000000";
						clk_count := clk_count + 1;
					else	-- > 1.52 ms
						cur_state <= entry_mode_set;
						clk_count := 0;
					end if;
				when entry_mode_set =>
					if(clk_count < 10 * clk_freq) then
						RS <= '0';
						RW <= '0';
						E <= '1';
						to_LCD<= "00000110";
						clk_count := clk_count + 1;
					elsif(clk_count < 37 * clk_freq) then
						E <= '0';
						to_LCD<= "00000000";
						clk_count := clk_count + 1;
					else	-- > 37 us
						cur_state <= init_complete;
						clk_count := 0;
					end if;
				when init_complete =>
					cur_state <= ready;
					ready_sig <= '1';
				when ready =>
					if (controller_data_ready = '1') then
						to_LCD <= from_controller(7 downto 0);
						RS <= from_controller(9);
						RW <= from_controller(8);
						clk_count := 0;
						cur_state <= sending;
						ready_sig <= '0';
					elsif(controller_data_ready = '0') then -- wait to receive data
						ready_sig <= '1';
						clk_count := 0;
						to_LCD<= "00000000";
					end if;
				when sending =>
					IF(clk_count < (50 * clk_freq)) THEN       --do not exit for 50us
						IF(clk_count < clk_freq) THEN              --negative enable
						  E <= '0';
						ELSIF(clk_count < (14 * clk_freq)) THEN    --positive enable half-cycle
						  E <= '1';
						ELSIF(clk_count < (27 * clk_freq)) THEN    --negative enable half-cycle
						  E <= '0';
						END IF;
						clk_count := clk_count + 1;
						cur_state  <= sending;
					ELSE
						clk_count := 0;
						ready_sig <= '1';
						cur_state  <= ready;
					END IF;
			end case;
		end if;
	end process;
end LCD_arch;