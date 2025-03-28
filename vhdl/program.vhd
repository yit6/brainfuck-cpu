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
		"11111111"&x"05", -- set loop counter
		"10000000"&x"00", -- bf: >
		"11111111"&x"01", -- set initial a
		"10000000"&x"00", -- bf: >
		"11111111"&x"01", -- set initial b
		"10000000"&x"00", -- bf: >
		"11111111"&x"00", -- clear scratch cell
		"01000000"&x"00", -- bf: <
		"01000000"&x"00", -- bf: <
		"01000000"&x"00", -- bf: <
		"00000010"&x"00", -- bf: [
		"10000000"&x"00", -- bf: >
		"00000010"&x"00", -- bf: [
		"00010000"&x"00", -- bf: -
		"10000000"&x"00", -- bf: >
		"00100000"&x"00", -- bf: +
		"10000000"&x"00", -- bf: >
		"00100000"&x"00", -- bf: +
		"01000000"&x"00", -- bf: <
		"01000000"&x"00", -- bf: <
		"00000001"&x"00", -- bf: ]
		"10000000"&x"00", -- bf: >
		"00000010"&x"00", -- bf: [
		"00010000"&x"00", -- bf: -
		"01000000"&x"00", -- bf: <
		"00100000"&x"00", -- bf: +
		"10000000"&x"00", -- bf: >
		"00000001"&x"00", -- bf: ]
		"10000000"&x"00", -- bf: >
		"00000010"&x"00", -- bf: [
		"00010000"&x"00", -- bf: -
		"01000000"&x"00", -- bf: <
		"00100000"&x"00", -- bf: +
		"10000000"&x"00", -- bf: >
		"00000001"&x"00", -- bf: ]
		"01000000"&x"00", -- bf: <
		"01000000"&x"00", -- bf: <
		"00001000"&x"00", -- bf: .
		"01000000"&x"00", -- bf: <
		"00010000"&x"00", -- bf: -
		"00000001"&x"00", -- bf: ]

		others => (others =>'0')
	);
begin
	ins <= prog(to_integer(unsigned(addr)));
end architecture buh;
