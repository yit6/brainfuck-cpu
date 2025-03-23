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
	'1', character'val(10), '2', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '4', character'val(10), 'B', 'u', 'z', 'z', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '7', character'val(10), '8', character'val(10), 'F', 'i', 'z', 'z', character'val(10), 'B', 'u', 'z', 'z', character'val(10), '1', '1', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '1', '3', character'val(10), '1', '4', character'val(10), 'F', 'i', 'z', 'z', 'B', 'u', 'z', 'z', character'val(10), '1', '6', character'val(10), '1', '7', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '1', '9', character'val(10), 'B', 'u', 'z', 'z', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '2', '2', character'val(10), '2', '3', character'val(10), 'F', 'i', 'z', 'z', character'val(10), 'B', 'u', 'z', 'z', character'val(10), '2', '6', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '2', '8', character'val(10), '2', '9', character'val(10), 'F', 'i', 'z', 'z', 'B', 'u', 'z', 'z', character'val(10), '3', '1', character'val(10), '3', '2', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '3', '4', character'val(10), 'B', 'u', 'z', 'z', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '3', '7', character'val(10), '3', '8', character'val(10), 'F', 'i', 'z', 'z', character'val(10), 'B', 'u', 'z', 'z', character'val(10), '4', '1', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '4', '3', character'val(10), '4', '4', character'val(10), 'F', 'i', 'z', 'z', 'B', 'u', 'z', 'z', character'val(10), '4', '6', character'val(10), '4', '7', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '4', '9', character'val(10), 'B', 'u', 'z', 'z', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '5', '2', character'val(10), '5', '3', character'val(10), 'F', 'i', 'z', 'z', character'val(10), 'B', 'u', 'z', 'z', character'val(10), '5', '6', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '5', '8', character'val(10), '5', '9', character'val(10), 'F', 'i', 'z', 'z', 'B', 'u', 'z', 'z', character'val(10), '6', '1', character'val(10), '6', '2', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '6', '4', character'val(10), 'B', 'u', 'z', 'z', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '6', '7', character'val(10), '6', '8', character'val(10), 'F', 'i', 'z', 'z', character'val(10), 'B', 'u', 'z', 'z', character'val(10), '7', '1', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '7', '3', character'val(10), '7', '4', character'val(10), 'F', 'i', 'z', 'z', 'B', 'u', 'z', 'z', character'val(10), '7', '6', character'val(10), '7', '7', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '7', '9', character'val(10), 'B', 'u', 'z', 'z', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '8', '2', character'val(10), '8', '3', character'val(10), 'F', 'i', 'z', 'z', character'val(10), 'B', 'u', 'z', 'z', character'val(10), '8', '6', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '8', '8', character'val(10), '8', '9', character'val(10), 'F', 'i', 'z', 'z', 'B', 'u', 'z', 'z', character'val(10), '9', '1', character'val(10), '9', '2', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '9', '4', character'val(10), 'B', 'u', 'z', 'z', character'val(10), 'F', 'i', 'z', 'z', character'val(10), '9', '7', character'val(10), '9', '8', character'val(10), 'F', 'i', 'z', 'z', character'val(10), 'B', 'u', 'z', 'z'
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
		for i in 0 to 10000000 loop
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
