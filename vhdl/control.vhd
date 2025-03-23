library ieee;

use ieee.std_logic_1164.all;

entity control is
	generic (
		BIT_W : integer;
		BRACKET_DEPTH : integer
	);
	port (
		ins : in std_logic_vector(15 downto 0);
		mode : in std_logic_vector(1 downto 0);
		bracket_count : in std_logic_vector(BRACKET_DEPTH-1 downto 0);
		mem_out : in std_logic_vector(BIT_W-1 downto 0);

		inc_dec_src : out std_logic;
		data_src    : out std_logic_vector(1 downto 0);
		write_mem   : out std_logic;
		write_addr  : out std_logic;
		out_en      : out std_logic;

		next_mode : out std_logic_vector(1 downto 0);
		addr_scan_back : out std_logic;
		next_bracket_op : out std_logic_vector(1 downto 0)
	);
end entity control;

architecture buh of control is
	signal load_imm : std_logic;
	
	signal scan_open   : std_logic;
	signal scan_close  : std_logic;
	signal normal_mode : std_logic;

	signal ins_open   : std_logic;
	signal ins_close  : std_logic;

	signal match : std_logic;
begin 

	load_imm <= and(ins(15 downto 8));
	-- use memory out for + and -
	inc_dec_src <= ins(13) or ins(12);

	-- inc for + and > dec for - and < all for load imm
	data_src <= (ins(14) or ins(12)) & (ins(15) or ins(13));

	-- write memory for + - ,
	write_mem <= normal_mode and (ins(13) or ins(12) or ins(10));

	-- change address for > and <, but not load immediate
	write_addr <= normal_mode and (ins(15) or ins(14)) and not load_imm;

	out_en <= ins(11) and not load_imm;

	scan_open  <= '1' when mode="01" else '0';
	scan_close <= '1' when mode="10" else '0';
	normal_mode <= and mode;

	ins_open  <= '1' when ins(15 downto 8)="00000010" else '0';
	ins_close <= '1' when ins(15 downto 8)="00000001" else '0';

	match <= '0' when (or bracket_count) else
		 '1' when scan_open and ins_open else
		 '1' when scan_close and ins_close else '0';

	next_mode <= "11" when match else
		     "10" when ins_open and not (or mem_out) else
		     "01" when ins_close and (or mem_out) else mode;

	addr_scan_back <= (normal_mode and ins_close and (or mem_out)) or (scan_open and not match);

	next_bracket_op <= "00" when match else
			   "10" when (scan_open and ins_close) or (scan_close and ins_open) else
			   "01" when (scan_open and ins_open) or (scan_close and ins_close) else "11";

end architecture buh;
