library ieee;

use ieee.std_logic_1164.all;

entity execute_tb is
end entity execute_tb;

architecture buh of execute_tb is
	function vec2str(vec: std_logic_vector) return string is
		variable stmp : string(vec'high+1 downto 1);
		variable counter : integer := 1;
	begin
		for i in vec'reverse_range loop
			stmp(counter) := std_logic'image(vec(i))(2);
			counter := counter + 1;
    		end loop;
		return stmp;
	end vec2str;

	component execute
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
	end component;

	type test_case is record
		ins : std_logic_vector(15 downto 0);
		char_in : std_logic_vector(7 downto 0);

		inc_dec_src : std_logic;
		data_src    : std_logic_vector(1 downto 0);
		write_mem   : std_logic;
		write_addr  : std_logic;

		data_out : std_logic_vector(7 downto 0);
	end record;

	type test_array is array(natural range <>) of test_case;

	constant test_cases : test_array := (
		(ins => "11111111"&x"a5", char_in => x"--", inc_dec_src => '-', data_src => "11", write_mem => '1', write_addr => '0', data_out => x"a5"),
		(ins => "00000000"&x"--", char_in => x"--", inc_dec_src => '-', data_src => "--", write_mem => '0', write_addr => '0', data_out => x"a5"),
		(ins => "00000100"&x"--", char_in => x"5a", inc_dec_src => '-', data_src => "00", write_mem => '1', write_addr => '0', data_out => x"5a"),
		(ins => "00001000"&x"--", char_in => x"--", inc_dec_src => '-', data_src => "--", write_mem => '0', write_addr => '0', data_out => x"5a"),
		(ins => "00100000"&x"--", char_in => x"--", inc_dec_src => '1', data_src => "01", write_mem => '1', write_addr => '0', data_out => x"5b"),
		(ins => "00100000"&x"--", char_in => x"--", inc_dec_src => '1', data_src => "01", write_mem => '1', write_addr => '0', data_out => x"5c"),
		(ins => "00010000"&x"--", char_in => x"--", inc_dec_src => '1', data_src => "10", write_mem => '1', write_addr => '0', data_out => x"5b"),
		(ins => "00010000"&x"--", char_in => x"--", inc_dec_src => '1', data_src => "10", write_mem => '1', write_addr => '0', data_out => x"5a"),
		(ins => "10000000"&x"--", char_in => x"--", inc_dec_src => '0', data_src => "01", write_mem => '0', write_addr => '1', data_out => x"00"),
		(ins => "01000000"&x"--", char_in => x"--", inc_dec_src => '0', data_src => "10", write_mem => '0', write_addr => '1', data_out => x"5a"),
		(ins => "11111111"&x"ff", char_in => x"--", inc_dec_src => '-', data_src => "11", write_mem => '1', write_addr => '0', data_out => x"ff"),
		(ins => "11111111"&x"00", char_in => x"--", inc_dec_src => '-', data_src => "11", write_mem => '1', write_addr => '0', data_out => x"00")
	);

	signal clk      : std_logic;
	signal ins      : std_logic_vector(15 downto 0);
	signal char_in  : std_logic_vector( 7 downto 0);

	signal inc_dec_src : std_logic;
	signal data_src    : std_logic_vector(1 downto 0);
	signal write_mem   : std_logic;
	signal write_addr  : std_logic;

	signal char_out : std_logic_vector(7 downto 0);
begin
	ex : execute port map (
		clk      => clk,
		ins      => ins,
		char_in  => char_in,
		inc_dec_src => inc_dec_src,
		data_src    => data_src,
		write_mem   => write_mem,
		write_addr  => write_addr,
		char_out => char_out
	);

	process is begin
		for i in test_cases'range loop
			clk <= '0';
			
			ins     <= test_cases(i).ins;
			char_in <= test_cases(i).char_in;
			inc_dec_src <= test_cases(i).inc_dec_src;
			data_src    <= test_cases(i).data_src;
			write_mem   <= test_cases(i).write_mem;
			write_addr  <= test_cases(i).write_addr;

			wait for 10 ns;

			clk <= '1';

			wait for 5 ns;

			assert char_out=test_cases(i).data_out
			report "Wrong output on case "&integer'image(i)&
			", got: "&vec2str(char_out)&
			", expected: "&vec2str(test_cases(i).data_out)
			severity error;

			wait for 5 ns;

		end loop;

		wait;
	end process;
end architecture buh;
