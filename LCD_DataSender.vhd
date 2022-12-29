library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.all;

entity LCD_DataSender is
	generic(
		data_digit_length : INTEGER;
		data_bit_length : INTEGER
	);
	port(
		clk : in std_logic;
		LCD_clear_btn  : in std_logic;
		data_in_ready : in std_logic;
		data_in : in std_logic_vector(data_bit_length-1 downto 0);

		-- LCD port
		to_LCD: out  std_logic_vector(7 downto 0);
		LCD_RS : out std_logic;
		LCD_RW : out std_logic;
		LCD_E : out std_logic;
		LCD_reset_btn : in std_logic
	);
end LCD_DataSender;

architecture LCD_DataSender_arch of LCD_DataSender is
	component LCD is
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
	end component;

	type t_DivMod is array (0 to 1) of std_logic_vector(data_bit_length-1 downto 0);		-- Array to hold division(0) and modulo(1) result
	
	-- https://hackaday.com/2020/06/12/binary-math-tricks-shifting-to-divide-by-ten-aint-easy/
	function div_mod_10 (num : std_logic_vector(data_bit_length-1 downto 0)) return t_DivMod is
		variable q : std_logic_vector(data_bit_length-1 downto 0);
		variable r : std_logic_vector(data_bit_length-1 downto 0);
	begin
		q := std_logic_vector(shift_right(unsigned(num), 1) + shift_right(unsigned(num), 2)); -- q = (num >> 1) + (num >> 2)
		q := std_logic_vector(unsigned(q) + shift_right(unsigned(q), 4)); -- q = q + (q >> 4)
		q := std_logic_vector(unsigned(q) + shift_right(unsigned(q), 8)); -- q = q + (q >> 8)
		q := std_logic_vector(unsigned(q) + shift_right(unsigned(q), 16)); -- q = q + (q >> 16)
		q := std_logic_vector(unsigned(q) + shift_right(unsigned(q), 32)); -- q = q + (q >> 32), here q = 0.8n
		q := std_logic_vector(shift_right(unsigned(q), 3)); -- q = q >> 3, here q = (0.8/8)n = 0.1n
		r := std_logic_vector( resize(unsigned(num) - (unsigned(q) * 10), data_bit_length)); -- r = num - q * 10
		if (to_integer(unsigned(r)) > 9) then
			 q := std_logic_vector(unsigned(q)+1);
			 r := std_logic_vector(unsigned(r) - 10);
		end if;
		return (q, r);
	end function;
	
	type t_vector is array (0 to data_digit_length-1) of std_logic_vector(3 downto 0);

	function getDigits_func (number : std_logic_vector(data_bit_length-1 downto 0)) return t_vector is
		variable digits_vector : t_vector;
		variable curr_number : std_logic_vector(data_bit_length-1 downto 0) := number;
		variable divMod : t_DivMod;
	begin
		for index in data_digit_length-1 downto 0 loop
			divMod := div_mod_10(curr_number);
			digits_vector(index) := std_logic_vector(divMod(1)(3 downto 0));
			curr_number := divMod(0);
		end loop;
		return digits_vector;
	end function getDigits_func;
	
	signal LCD_ready_sig : std_logic;
	signal controller_data_ready : std_logic := '0';
	signal digitsToLCD : t_vector;	-- Contains the digits that will be shown on the LCD
	signal controller_data_to_LCD : std_logic_vector(9 downto 0);
	
	type DataSender_state_type is (init_char_display, shift_to_value, ready, shift_back, waiting_clear, waiting_reset);
	signal cur_state : DataSender_state_type := init_char_display;
	
	type t_charArray is array (0 to 12) of std_logic_vector(7 downto 0);
	signal display_char : t_charArray := ("01000110", "01010010", "01000101", "01010001", "00111010", "00100000", "00110000", "00110000", 
														"00110000", "00110000", "00100000", "01001000", "01111010");
														-- "FREQ: 0000 Hz"
begin

	LCD_pmap: LCD port map(
		to_LCD => to_LCD,
		RS => LCD_RS,
		RW => LCD_RW,
		clk => clk,
		E => LCD_E,
		reset => LCD_reset_btn,
		ready_sig => LCD_ready_sig,
		controller_data_ready => controller_data_ready,
		from_controller => controller_data_to_LCD
	);

	process (clk, LCD_ready_sig, data_in_ready, LCD_clear_btn )
	VARIABLE num_count : INTEGER := data_digit_length+1;
	VARIABLE char_count : INTEGER := 0;
	VARIABLE clk_count : INTEGER := 0;
	begin
		
		if(clk'event and clk = '1') then

			if(controller_data_ready = '1') then
				controller_data_ready <= '0';	-- Data ready just for one clk cycle
			
			elsif(LCD_ready_sig = '1') then
			case cur_state is
				when init_char_display =>
					controller_data_to_LCD(9) <= '1';
					controller_data_to_LCD(8) <= '0'; -- write
					controller_data_to_LCD(7 downto 0) <= display_char(char_count);
					controller_data_ready <= '1';

					if(char_count < display_char'length -1) then
						char_count := char_count + 1;
					else
						char_count := 0;
						cur_state <= shift_to_value;
					end if;
				when shift_to_value =>
					if(char_count < 7) then
						controller_data_to_LCD <= "0000010000"; -- shift Left
						controller_data_ready <= '1';
						char_count := char_count + 1;
					else
						char_count := 0;
						cur_state <= ready;
					end if;
				when ready =>
					if(num_count < data_digit_length) then
						controller_data_to_LCD(7 downto 0) <= "0011" & digitsToLCD(num_count);
						num_count := num_count + 1;
						controller_data_ready <= '1';
			
					elsif(num_count = data_digit_length) then
						cur_state <= shift_back;
						num_count := num_count + 1;
						
					elsif(data_in_ready = '1') then
						controller_data_to_LCD(9) <= '1';
						controller_data_to_LCD(8) <= '0'; -- write
						digitsToLCD <= getDigits_func(data_in);
						num_count := 0;
						
					elsif(LCD_clear_btn  = '1') then
						controller_data_to_LCD <= "0000000001"; -- clear display
						controller_data_ready <= '1';
						cur_state <= waiting_clear;
						
					elsif(LCD_reset_btn  = '1') then
						cur_state <= waiting_reset;
					end if;
				when shift_back =>
					if(char_count < data_digit_length) then
						controller_data_to_LCD <= "0000010000"; -- shift Left
						controller_data_ready <= '1';
						char_count := char_count + 1;
					else
						char_count := 0;
						cur_state <= ready;
					end if;
				when waiting_clear =>
					if(clk_count >= 2000 * clk_freq) then	-- wait 2 ms
						cur_state <= init_char_display;
						clk_count := 0;
					else
						clk_count := clk_count + 1;
					end if;
				when waiting_reset =>
					if(clk_count >= 3000 * clk_freq) then	-- wait 3 ms
						cur_state <= init_char_display;
						clk_count := 0;
					else
						clk_count := clk_count + 1;
					end if;
				end case;
			end if;
		end if;
	end process;

end LCD_DataSender_arch;