library ieee;

use ieee.std_logic_1164.all;

entity control_tb is
end entity control_tb;

architecture guh of control_tb is
	component control is port (
		ins : in std_logic_vector(15 downto 0);
		inc_dec_src : out std_logic;
		data_src    : out std_logic_vector(1 downto 0);
		write_mem   : out std_logic;
		write_addr  : out std_logic;
		out_en      : out std_logic);
	end component control;

	signal ins         : std_logic_vector(15 downto 0);
	signal inc_dec_src : std_logic;
	signal data_src    : std_logic_vector(1 downto 0);
	signal write_mem   : std_logic;
	signal write_addr  : std_logic;
	signal out_en      : std_logic;
begin

	con : control port map (
		ins => ins,
		inc_dec_src => inc_dec_src,
		data_src => data_src,
		write_mem => write_mem,
		write_addr => write_addr,
		out_en => out_en
	);
	process is begin
		ins <= "00000000--------";
		wait for 10 ns;
		ins <= "00000001--------";
		wait for 10 ns;
		ins <= "00000010--------";
		wait for 10 ns;
		ins <= "00000100--------";
		wait for 10 ns;
		ins <= "00001000--------";
		wait for 10 ns;
		ins <= "00010000--------";
		wait for 10 ns;
		ins <= "00100000--------";
		wait for 10 ns;
		ins <= "01000000--------";
		wait for 10 ns;
		ins <= "10000000--------";
		wait for 10 ns;
		ins <= "11111111--------";
		wait for 10 ns;

		wait;
	end process;
end architecture guh;
