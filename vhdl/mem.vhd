library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem is
	generic (
		BIT_W  : integer;
		ADDR_W : integer
	);
	port (
		data_in  :  in std_logic_vector(BIT_W-1  downto 0);
		addr     :  in std_logic_vector(ADDR_W-1 downto 0);
		we       :  in std_logic;
		clk      :  in std_logic;
		data_out : out std_logic_vector(BIT_W-1  downto 0)
	);
end entity mem;

architecture buh of mem is
	type mem_array is array((2**ADDR_W)-1 downto 0) of std_logic_vector(BIT_W-1 downto 0);
	signal memory : mem_array := (others => (others => '0'));
begin
	data_out <= memory(to_integer(unsigned(addr)));

	process(clk) is begin
		if clk='1' and clk'event and we='1' then
			memory(to_integer(unsigned(addr))) <= data_in;
		end if;
	end process;
end architecture buh;
