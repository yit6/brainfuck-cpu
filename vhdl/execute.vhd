library ieee;

use ieee.std_logic_1164.all;

entity execute is
	generic (
		BIT_W : integer := 8;
		ADDR_W : integer := 16
	);
	port (
		clk      :  in std_logic;
		ins      :  in std_logic_vector(15 downto 0);
		char_in  :  in std_logic_vector( 7 downto 0);

		inc_dec_src : in std_logic;
		data_src    : in std_logic_vector(1 downto 0);
		write_mem   : in std_logic;
		write_addr  : in std_logic;

		char_out : out std_logic_vector(7 downto 0)
	);
end execute;

architecture buh of execute is
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

	component mem is
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
	end component mem;

	signal address     : std_logic_vector(ADDR_W-1 downto 0) := (others => '0');
 
	signal write_back  : std_logic_vector(BIT_W-1 downto 0);

	signal inc_dec_in  : std_logic_vector(maximum(ADDR_W,BIT_W)-1 downto 0);
	signal inc_out     : std_logic_vector(maximum(ADDR_W,BIT_W)-1 downto 0);
	signal dec_out     : std_logic_vector(maximum(ADDR_W,BIT_W)-1 downto 0);

	signal result      : std_logic_vector(maximum(ADDR_W,BIT_W)-1 downto 0);
begin

	char_out <= write_back;

	with inc_dec_src select inc_dec_in <=
		(maximum(ADDR_W,BIT_W)-1 downto ADDR_W=>'0')&address when '0',
		(maximum(ADDR_W,BIT_W)-1 downto  BIT_W=>'0')&write_back when others;
	
	with data_src select result <=
		(ADDR_W-1 downto BIT_W=>'0')&char_in when "00",
		inc_out when "01",
		dec_out when "10",
		(ADDR_W-1 downto BIT_W=>'0')&ins(7 downto 0) when others;

	incrementor : inc generic map (N => maximum(ADDR_W,BIT_W))
	port map (
		a => inc_dec_in,
		y => inc_out
	);

	decrementor : dec generic map (N => maximum(ADDR_W,BIT_W))
	port map (
		a => inc_dec_in,
		y => dec_out
	);

	memory : mem generic map (BIT_W => BIT_W, ADDR_W => ADDR_W)
	port map (
		clk => clk,
		we => write_mem,
		addr => address,
		data_in => result(BIT_W-1 downto 0),
		data_out => write_back
	);

	process(clk) is begin
		if clk='1' and clk'event and write_addr='1' then
			address <= result(ADDR_W-1 downto 0);
		end if;
	end process;

end architecture buh;
