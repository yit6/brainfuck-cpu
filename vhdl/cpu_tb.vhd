library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

	signal clk      : std_logic;
	signal char_in  : std_logic_vector(7 downto 0) := (others => '0');
	signal char_out : std_logic_vector(7 downto 0);
	signal out_en   : std_logic;

	type char_arr is array(natural range <>) of character;

	constant expected_out : char_arr := (
		'H','e','l','l','o',' ','W','o','r','l','d','!'
	);
	signal curr_char : integer := 0;
begin

	uut : cpu port map (
		clk => clk,
		char_in => char_in,
		char_out => char_out,
		out_en => out_en
	);

	process is begin
		for i in 0 to 100000 loop
			clk <= '0';
			wait for 10 ns;
			clk <= '1';
			wait for 5 ns;

			-- check if character is currently getting output
			if out_en='1' then
				report ""&character'val(to_integer(unsigned(char_out)));

				assert character'val(to_integer(unsigned(char_out)))=expected_out(curr_char)
				report "expected "&expected_out(curr_char)&" next, got: "&character'val(to_integer(unsigned(char_out)))
				severity failure;

				curr_char <= curr_char+1;

			end if;

			-- check if full output received yet
			if curr_char=expected_out'length then
				report "yippee!";
				wait;
			end if;

			wait for 5 ns;
		end loop;

		assert 0=1 report "Testbench ran too long, try increasing loop range?" severity failure;
	end process;
end architecture guh;
