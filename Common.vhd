library IEEE;
use IEEE.STD_LOGIC_1164.all;

package Common is
	constant pcm_sample_rate : integer := 48000; -- The sample rates can be programmed, in 1Hz
																-- increments, to be any value from 4kHz to 48kHz.
	constant pcm_data_length : integer := 18;
	constant pcm_sample_size : integer := 1024; -- the sample size must be programmed to correspond to the IP xilinx fft
	type pcm_sample_array is array (0 to pcm_sample_size-1) of std_logic_vector(pcm_data_length-1 downto 0);
	constant resolution : integer := pcm_sample_rate/pcm_sample_size;
	
	constant frequency_refresh_rate : integer := 2; -- in Hz
	
	constant clk_freq	: integer := 100;    --system clock frequency in MHz
end Common;

package body Common is
end Common;
