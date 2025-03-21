library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
	generic (PROG_W : integer := 16);
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
			clk      :  in std_logic;
			ins      :  in std_logic_vector(15 downto 0);
			char_in  :  in std_logic_vector( 7 downto 0);
			enable   :  in std_logic;
			char_out : out std_logic_vector(7 downto 0);
			out_en   : out std_logic
		);
	end component execute;

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

	signal ex_en : std_logic;
begin
	prog : program
	generic map (PROG_W => PROG_W)
	port map (
		addr => addr,
		ins => ins
	);

	ex : execute port map (
		clk => clk,
		ins => ins,
		char_in => char_in,
		enable => ex_en,
		char_out => char_out,
		out_en => out_en
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

	process(clk) is begin
		if clk'event and clk='0' then
			addr <= next_addr;
		end if;
	end process;
end architecture buh;
