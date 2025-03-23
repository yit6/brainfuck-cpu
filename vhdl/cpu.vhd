library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
	generic (PROG_W : integer := 16; BRACKET_DEPTH : integer := 8);
	port (
		clk      :  in std_logic;
		char_in  :  in std_logic_vector(7 downto 0);
		char_out : out std_logic_vector(7 downto 0);
		out_en   : out std_logic
	);
end entity cpu;

architecture buh of cpu is
	component program is
		generic(PROG_W : integer);
		port (
			addr : in std_logic_vector(PROG_W-1 downto 0);
			ins : out std_logic_vector(15 downto 0)
		);
	end component program;

	component execute is
		generic (
			BIT_W : integer := 8;
			ADDR_W : integer := 16
		);
		port (
			clk         :  in std_logic;
			ins         :  in std_logic_vector(15 downto 0);
			char_in     :  in std_logic_vector( 7 downto 0);
			inc_dec_src :  in std_logic;
			data_src    :  in std_logic_vector(1 downto 0);
			write_mem   :  in std_logic;
			write_addr  :  in std_logic;
			char_out : out std_logic_vector(7 downto 0)
		);
	end component execute;

	component control is 
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
	end component control;

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

	signal addr : std_logic_vector(PROG_W-1 downto 0) := (others => '0');
	signal ins : std_logic_vector(15 downto 0);

	signal next_addr : std_logic_vector(PROG_W-1 downto 0);
	signal prev_addr : std_logic_vector(PROG_W-1 downto 0);

	-- 11: normal
	-- 10: scan for close
	-- 01: scan for open
	signal mode : std_logic_vector(1 downto 0) := "11";

	signal bracket_count : std_logic_vector(BRACKET_DEPTH-1 downto 0) := (others => '0');
	signal inc_bracket_count : std_logic_vector(BRACKET_DEPTH-1 downto 0);
	signal dec_bracket_count : std_logic_vector(BRACKET_DEPTH-1 downto 0);

	signal inc_dec_src : std_logic;
	signal data_src    : std_logic_vector(1 downto 0);
	signal write_mem   : std_logic;
	signal write_addr  : std_logic;

	signal match : std_logic;
	signal next_mode : std_logic_vector(1 downto 0);
	signal next_bracket_count : std_logic_vector(BRACKET_DEPTH-1 downto 0);
	signal next_ins_address : std_logic_vector(PROG_W-1 downto 0);
	signal next_backet_op : std_logic_vector(1 downto 0);
	signal addr_scan_back : std_logic;
begin
	prog : program
	generic map (PROG_W => PROG_W)
	port map (
		addr => addr,
		ins => ins
	);

	con : control
	generic map (BRACKET_DEPTH => BRACKET_DEPTH, BIT_W => 8)
	port map (
		ins => ins,
		mode => mode,
		mem_out => char_out,
		bracket_count => bracket_count,
		inc_dec_src => inc_dec_src,
		data_src    => data_src,
		write_mem   => write_mem,
		write_addr  => write_addr,
		out_en      => out_en,
		next_mode   => next_mode,
		next_bracket_op => next_backet_op,
		addr_scan_back => addr_scan_back
	);

	ex : execute port map (
		clk => clk,
		ins => ins,
		char_in => char_in,
		inc_dec_src => inc_dec_src,
		data_src    => data_src,
		write_mem   => write_mem,
		write_addr  => write_addr,
		char_out => char_out
	);

	addr_inc : inc generic map (N => PROG_W)
	port map (
		a => addr,
		y => next_addr
	);

	addr_dec : dec generic map (N => PROG_W)
	port map (
		a => addr,
		y => prev_addr
	);

	bracket_inc : inc generic map (N => BRACKET_DEPTH)
	port map (
		a => bracket_count,
		y => inc_bracket_count
	);

	bracket_dec : dec generic map (N => BRACKET_DEPTH)
	port map (
		a => bracket_count,
		y => dec_bracket_count
	);

	match <= '0' when (or bracket_count)='1' else
		 '1' when mode="01" and ins(15 downto 8)="00000010" else
		 '1' when mode="10" and ins(15 downto 8)="00000001" else '0';

	next_ins_address <= prev_addr when addr_scan_back else next_addr;

	with next_backet_op select next_bracket_count <=
		(others => '0') when "00",
		inc_bracket_count when "01",
		dec_bracket_count when "10",
		bracket_count when others;

	process(clk) is begin
		if clk'event and clk='1' then
			addr <= next_ins_address;
			bracket_count <= next_bracket_count;
			mode <= next_mode;
		end if;
	end process;
end architecture buh;
