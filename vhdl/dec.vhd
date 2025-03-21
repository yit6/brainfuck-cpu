library ieee;

use ieee.std_logic_1164.all;

entity dec is
	generic (N : integer);
	port (
		a :  in std_logic_vector(N-1 downto 0);
		y : out std_logic_vector(N-1 downto 0)
	);
end entity dec;

architecture buh of dec is
begin
	y(0) <= not a(0);

	gen: for i in N-1 downto 1 generate
		y(i) <= a(i) xnor (or a(i-1 downto 0));
	end generate;
end architecture buh;
