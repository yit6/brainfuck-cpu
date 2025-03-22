library ieee;

use ieee.std_logic_1164.all;

entity control is port
	(
		ins : in std_logic_vector(15 downto 0);
		enable : in std_logic;
		inc_dec_src : out std_logic;
		data_src    : out std_logic_vector(1 downto 0);
		write_mem   : out std_logic;
		write_addr  : out std_logic;
		out_en      : out std_logic
	);
end entity control;

architecture buh of control is
	signal load_imm : std_logic;
begin 

	load_imm <= and(ins(15 downto 8));
	-- use memory out for + and -
	inc_dec_src <= ins(13) or ins(12);

	-- inc for + and > dec for - and < all for load imm
	data_src <= (ins(14) or ins(12)) & (ins(15) or ins(13));

	-- write memory for + - ,
	write_mem <= enable and (ins(13) or ins(12) or ins(10));

	-- change address for > and <, but not load immediate
	write_addr <= enable and (ins(15) or ins(14)) and not load_imm;

	out_en <= ins(11) and not load_imm;
end architecture buh;
