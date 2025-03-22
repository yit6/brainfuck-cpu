library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program is
	generic(PROG_W : integer);
	port (
		addr : in std_logic_vector(PROG_W-1 downto 0);
		ins : out std_logic_vector(15 downto 0)
	);
end entity program;

architecture buh of program is
	type prog_array is array(0 to (2**PROG_W)-1) of std_logic_vector(15 downto 0);
	
	signal prog : prog_array := (
		"11111111"&x"3c", -- load 0x3c
		"00000010"&x"00", -- bf: [
		"00010000"&x"00", -- bf: -
		"00000001"&x"00", -- bf: ]
		others => (others =>'0')
	);
begin
	ins <= prog(to_integer(unsigned(addr)));
end architecture buh;
