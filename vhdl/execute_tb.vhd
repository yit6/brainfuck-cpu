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
			enable   :  in std_logic;
			char_out : out std_logic_vector(7 downto 0);
			out_en   : out std_logic
		);
	end component;

	type test_case is record
		ins : std_logic_vector(15 downto 0);
		char_in : std_logic_vector(7 downto 0);
		enable : std_logic;
		data_out : std_logic_vector(7 downto 0);
		output_enable : std_logic;
	end record;

	type test_array is array(natural range <>) of test_case;

	constant test_cases : test_array := (
		(ins => "11111111"&x"a5", char_in => x"--", enable => '1', data_out => x"a5", output_enable => '0'),
		(ins => "00000000"&x"--", char_in => x"--", enable => '1', data_out => x"a5", output_enable => '0'),
		(ins => "00000100"&x"--", char_in => x"5a", enable => '1', data_out => x"5a", output_enable => '0'),
		(ins => "00001000"&x"--", char_in => x"--", enable => '1', data_out => x"5a", output_enable => '1'),
		(ins => "00100000"&x"--", char_in => x"--", enable => '1', data_out => x"5b", output_enable => '0'),
		(ins => "00100000"&x"--", char_in => x"--", enable => '1', data_out => x"5c", output_enable => '0'),
		(ins => "00010000"&x"--", char_in => x"--", enable => '1', data_out => x"5b", output_enable => '0'),
		(ins => "00010000"&x"--", char_in => x"--", enable => '1', data_out => x"5a", output_enable => '0'),
		(ins => "10000000"&x"--", char_in => x"--", enable => '1', data_out => x"00", output_enable => '0'),
		(ins => "01000000"&x"--", char_in => x"--", enable => '1', data_out => x"5a", output_enable => '0'),
		(ins => "11111111"&x"ff", char_in => x"--", enable => '1', data_out => x"ff", output_enable => '0'),
		(ins => "11111111"&x"00", char_in => x"--", enable => '1', data_out => x"00", output_enable => '0'),
		(ins => "11111111"&x"00", char_in => x"--", enable => '0', data_out => x"00", output_enable => '0')
	);

	signal clk      : std_logic;
	signal ins      : std_logic_vector(15 downto 0);
	signal char_in  : std_logic_vector( 7 downto 0);
	signal enable   : std_logic;
	signal char_out : std_logic_vector(7 downto 0);
	signal out_en   : std_logic;
begin
	ex : execute port map (
		clk      => clk,
		ins      => ins,
		char_in  => char_in,
		enable   => enable,
		char_out => char_out,
		out_en   => out_en
	);

	process is begin
		for i in test_cases'range loop
			clk <= '0';
			
			ins     <= test_cases(i).ins;
			char_in <= test_cases(i).char_in;
			enable  <= test_cases(i).enable;

			wait for 10 ns;

			clk <= '1';

			wait for 5 ns;

			assert char_out=test_cases(i).data_out
			report "Wrong output on case "&integer'image(i)&
			", got: "&vec2str(char_out)&
			", expected: "&vec2str(test_cases(i).data_out)
			severity error;

			assert out_en=test_cases(i).output_enable
			report "Wrong output on case "&integer'image(i)&
			", got: "&std_logic'image(out_en)&
			", expected: "&std_logic'image(test_cases(i).output_enable)
			severity error;

			wait for 5 ns;

		end loop;

		wait;
	end process;
end architecture buh;
