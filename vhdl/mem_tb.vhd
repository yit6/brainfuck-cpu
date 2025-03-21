library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_tb is
	generic (
		BIT_W  : integer := 8;
		ADDR_W : integer := 16
	);
end mem_tb;

architecture guh of mem_tb is
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

	signal clk      : std_logic;

	signal data_in  : std_logic_vector(BIT_W-1  downto 0);
	signal addr     : std_logic_vector(ADDR_W-1 downto 0);
	signal we       : std_logic;

	signal data_out : std_logic_vector(BIT_W-1  downto 0);

	type test_case is record
		data_in  : std_logic_vector(BIT_W-1 downto 0);
		addr     : std_logic_vector(ADDR_W-1 downto 0);
		we       : std_logic;
		data_out : std_logic_vector(BIT_W-1  downto 0);
	end record;

	type test_array is array(natural range <>) of test_case;

	constant test_cases : test_array := (
		(data_in => x"a5", addr => x"0000", we => '0', data_out => x"00"),
		(data_in => x"a5", addr => x"0000", we => '1', data_out => x"a5"),
		(data_in => x"--", addr => x"0000", we => '0', data_out => x"a5"),
		(data_in => x"--", addr => x"0001", we => '0', data_out => x"00"),
		(data_in => x"5a", addr => x"0001", we => '1', data_out => x"5a"),
		(data_in => x"ff", addr => x"ffff", we => '1', data_out => x"ff")
	);
begin
	memory : mem generic map (
		BIT_W => BIT_W,
		ADDR_W => ADDR_W
	) port map (
		clk => clk,
		data_in => data_in,
		addr => addr,
		we => we,
		data_out => data_out
	);
	process is begin
		for i in test_cases'range loop

			data_in <= test_cases(i).data_in;
			addr    <= test_cases(i).addr;
			we      <= test_cases(i).we;

			clk <= '0';

			wait for 10 ns;

			clk <= '1';

			wait for 5 ns;

			assert data_out = test_cases(i).data_out
			report "wrong output on test case "&integer'image(i)
			severity error;

			wait for 5 ns;
		end loop;

		wait;
	end process;
end architecture guh;
