library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inc_tb is
	generic (N : integer := 16);
end inc_tb;

architecture guh of inc_tb is
	component inc is
		generic (N : integer);
		port (
			a :  in std_logic_vector(N-1 downto 0);
			y : out std_logic_vector(N-1 downto 0)
		);
	end component inc;

	component dec is
		generic (N : integer);
		port (
			a :  in std_logic_vector(N-1 downto 0);
			y : out std_logic_vector(N-1 downto 0)
		);
	end component dec;

	signal a : std_logic_vector(N-1 downto 0);
	signal inced : std_logic_vector(N-1 downto 0);
	signal deced : std_logic_vector(N-1 downto 0);
begin
	incrementor : inc generic map(N => N)
	port map (
		a => a,
		y => inced
	);

	decrementor : dec generic map(N => N)
	port map (
		a => a,
		y => deced
	);

	process is begin
		for i in 0 to (2**N)-1 loop
			a <= std_logic_vector(to_unsigned(i,N));

			wait for 10 ns;

			assert inced = std_logic_vector(to_unsigned(i+1,N))
			report "Failed to increment "&integer'image(i)
			severity error;

			assert deced = std_logic_vector(to_signed(i-1,N))
			report "Failed to decrement "&integer'image(i)
			severity error;

			wait for 10 ns;
		end loop;

		wait;
	end process;
end architecture;
