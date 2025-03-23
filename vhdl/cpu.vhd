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

	component control is port
		(
			ins : in std_logic_vector(15 downto 0);
			mode : in std_logic_vector(1 downto 0);
			inc_dec_src : out std_logic;
			data_src    : out std_logic_vector(1 downto 0);
			write_mem   : out std_logic;
			write_addr  : out std_logic;
			out_en      : out std_logic
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
begin
	prog : program
	generic map (PROG_W => PROG_W)
	port map (
		addr => addr,
		ins => ins
	);

	con : control port map (
		ins => ins,
		mode => mode,
		inc_dec_src => inc_dec_src,
		data_src    => data_src,
		write_mem   => write_mem,
		write_addr  => write_addr,
		out_en      => out_en
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

	process(clk) is 
		variable match : std_logic;
	begin
		if clk'event and clk='1' then
			if mode="01" and ins(15 downto 8)="00000010" and (or bracket_count)='0' then
				match := '1';
			elsif mode="10" and ins(15 downto 8)="00000001" and (or bracket_count)='0' then
				match := '1';
			else
				match := '0';
			end if;

			if mode="11" then
				if ins(15 downto 8)="00000010" and (or char_out)='0' then
					mode <= "10";
					addr <= next_addr;
				elsif ins(15 downto 8)="00000001" and (or char_out)='1' then
					mode <= "01";
					addr <= prev_addr;
				else
					addr <= next_addr;
				end if;
			elsif match='1' then
				bracket_count <= (others => '0');
				mode <= "11";
			else
				if mode="10" then
					addr <= next_addr;
					if ins(15 downto 8)="00000010" then
						bracket_count <= inc_bracket_count;
					elsif ins(15 downto 8)="00000001" then
						bracket_count <= dec_bracket_count;
					end if;
				elsif mode="01" then
					addr <= prev_addr;
					if ins(15 downto 8)="00000001" then
						bracket_count <= inc_bracket_count;
					elsif ins(15 downto 8)="00000010" then
						bracket_count <= dec_bracket_count;
					end if;
				end if;
			end if;
		end if;
	end process;
end architecture buh;
