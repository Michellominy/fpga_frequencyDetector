library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.all;


entity top_module is
	generic(
		frequency_digit_length : INTEGER := 4;
		frequency_bit_length : INTEGER := 12;
		HALF_PCM_SAMPLE_SIZE : integer := pcm_sample_size/2
	);
	port(
		clk : in  std_logic;

		dumb : out std_logic;
		AUD_BIT_CLK : in std_logic;
		AUD_SDI : in std_logic;
		AUD_SDO : out std_logic;
		AUD_SYNC : out std_logic;
		AUD_RESET : out std_logic;
		AUD_reset_btn : in std_logic;

		-- LCD
		to_LCD: out  std_logic_vector(7 downto 0);
		LCD_RS : out std_logic;
		LCD_RW : out std_logic;
		LCD_E : out std_logic;
		LCD_reset_btn : in std_logic;
		LCD_clear_btn : in std_logic
	);
end top_module;

architecture Behavioral of top_module is
	component AC97 is
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
	end component;
	
	component LCD_DataSender is
	generic(
		data_digit_length : INTEGER;
		data_bit_length : INTEGER
	);
	port(
		clk : in std_logic;
		LCD_clear_btn  : in std_logic;
		data_in_ready : in std_logic;
		data_in : in std_logic_vector(data_bit_length-1 downto 0);
		to_LCD: out  std_logic_vector(7 downto 0);
		LCD_RS : out std_logic;
		LCD_RW : out std_logic;
		LCD_E : out std_logic;
		LCD_reset_btn : in std_logic
	);
	end component;
	
	component xfft_v7_1 is
	port (
		clk : in std_logic; 
		start : in std_logic; 
		fwd_inv : in std_logic; 
		fwd_inv_we : in std_logic; 
		rfd : out std_logic; 
		busy : out std_logic; 
		done : out std_logic; 
		xn_re : in std_logic_vector ( pcm_data_length-1 downto 0 ); 
		xn_im : in std_logic_vector ( pcm_data_length-1 downto 0 ); 
		xn_index : out std_logic_vector ( 9 downto 0 ); 
		xk_index : out std_logic_vector ( 9 downto 0 ); 
		xk_re : out std_logic_vector ( pcm_data_length-1 downto 0 ); 
		xk_im : out std_logic_vector ( pcm_data_length-1 downto 0 ) 
  );
	end component;
	
	
	signal pcm_data_ready : std_logic;
	signal pcm_data : pcm_sample_array;
	signal update_pcm_data : std_logic := '1';
	
	signal frequency : std_logic_vector(frequency_bit_length-1 downto 0);
	signal update_frequency : std_logic;
	signal fft_start : std_logic := '0';
	signal fft_Xn_Re : std_logic_vector ( pcm_data_length-1 downto 0 ); 
	signal fft_Xn_index : std_logic_vector ( 9 downto 0 ); 
	signal fft_Xk_index : std_logic_vector ( 9 downto 0 ); 
	signal fft_Xk_Re : std_logic_vector ( pcm_data_length-1 downto 0 ); 
	signal fft_Xk_Im : std_logic_vector ( pcm_data_length-1 downto 0 ); 
	signal fft_done : std_logic;
	signal fft_rfd : std_logic;
	signal fft_busy : std_logic;

begin
	
	AC97_audio: AC97
	port map(
		AUD_BIT_CLK => AUD_BIT_CLK,
		AUD_SDI => AUD_SDI,
		AUD_SDO => AUD_SDO,
		AUD_SYNC => AUD_SYNC,
		AUD_RESET => AUD_RESET,
		AUD_reset_btn => AUD_reset_btn,
		clk => clk,
		PCM_data_ready => pcm_data_ready,
		PCM_data => pcm_data,
		update_PCM_data => update_pcm_data
	);
	
	LCD: LCD_DataSender 
	generic map(
		data_digit_length => frequency_digit_length,
		data_bit_length => frequency_bit_length
    )
	port map(
		clk => clk,
		LCD_clear_btn  => LCD_clear_btn,
		data_in_ready => update_frequency,
		data_in => frequency,

		-- LCD port
		to_LCD => to_LCD,
		LCD_RS => LCD_RS,
		LCD_RW => LCD_RW,
		LCD_E => LCD_E,
		LCD_reset_btn => LCD_reset_btn
	);
	
	xfft: xfft_v7_1 
	port map(
		clk => clk, 
		start => fft_start,
		fwd_inv => '1', 	-- forward FFT
		fwd_inv_we => '0', -- disable
		rfd => fft_rfd, 
		busy => fft_busy, 
		done => fft_done, 
		xn_re => fft_Xn_Re, 
		xn_im => (others => '0'), 
		xn_index => fft_Xn_index, 
		xk_index => fft_Xk_index, 
		xk_re => fft_Xk_Re, 
		xk_im => fft_Xk_Im
	);
	
	process(clk)
	variable clk_count : integer := 0;
	begin
		if(clk'event and clk = '1') then
			if(clk_count =  (clk_freq * 1000000)/frequency_refresh_rate) then
				update_frequency <= '1';
				clk_count := 0;
			else
				clk_count := clk_count + 1;
				update_frequency <= '0';
			end if;
		end if;
	end process;
	
	-- Loading Frame
	fft_Xn_Re <= pcm_data(to_integer(unsigned(fft_Xn_index)));
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if (pcm_data_ready = '1') then
				fft_start <= '1';
				update_pcm_data <= '0';
			elsif(to_integer(unsigned(fft_Xn_index)) >= HALF_PCM_SAMPLE_SIZE)  then
				fft_start <= '0';
				update_pcm_data <= '1';
			end if;
			
		end if;
	end process;
	
	-- Unloading
	process(clk)
	variable max : integer := 0;
	variable max_index : std_logic_vector(frequency_bit_length-1 downto 0) := (others => '0');
	variable curr : integer;
	begin
		if(clk'event and clk = '1') then
			curr := to_integer(abs(signed(fft_Xk_Re)) + abs(signed(fft_Xk_Im)));
			if ( max < curr and to_integer(unsigned(fft_Xk_index)) < HALF_PCM_SAMPLE_SIZE) then
				max := curr;
				max_index := std_logic_vector(resize(unsigned(fft_Xk_index), frequency_bit_length)); 
			end if;
			if (unsigned(fft_Xk_index) = to_unsigned(pcm_sample_size-1, frequency_bit_length)) then
				frequency <= std_logic_vector(unsigned(max_index) * resolution);
				max := 0;
				max_index := (others => '0');
			end if;
		end if;
	end process;
	
end Behavioral;