library ieee;

use ieee.std_logic_1164.all;

entity cpu_tb is
end entity cpu_tb;

architecture guh of cpu_tb is
	component cpu is
		generic (PROG_W : integer := 16);
		port (
			clk      :  in std_logic;
			char_in  :  in std_logic_vector(7 downto 0);
			char_out : out std_logic_vector(7 downto 0);
			out_en   : out std_logic
		);
	end component cpu;

	signal clk      : std_logic := '0';
	signal char_in  : std_logic_vector(7 downto 0) := (others => '0');
	signal char_out : std_logic_vector(7 downto 0);
	signal out_en   : std_logic;
begin

	uut : cpu port map (
		clk => clk,
		char_in => char_in,
		char_out => char_out,
		out_en => out_en
	);

	process is begin
		for i in 0 to 100 loop
			wait for 10 ns;
			clk <= not clk;
		end loop;

		wait;
	end process;
end architecture guh;
