library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InmGen is
port(
	instruccion	: in std_logic_vector(31 downto 0); --Instrucción de la ROM con el inmediato por ahí (ir_out)
	inm			: out std_logic_vector(31 downto 0); --El inmediato (extraído de la instrucción)
	tipo_inst	: in std_logic_vector(2 downto 0); --En funciónn del tipo de instrucción, se decodifica de una forma u otra
	mask_b0		: in std_logic); --LSB a 0
end InmGen;

architecture behavioural of InmGen is

--type t_instruccion is std_logic_vector(2 downto 0);
--constant TYPE_I : t_instruccion:= "000";
--constant TYPE_S : t_instruccion:= "001";
--constant TYPE_B : t_instruccion:= "010";
--constant TYPE_U : t_instruccion:= "011";
--constant TYPE_J : t_instruccion:= "100";
signal salida : std_logic_vector(31 downto 0);
constant ext21_0: std_logic_vector(20 downto 0):= "000000000000000000000";
constant ext21_1: std_logic_vector(20 downto 0):= "111111111111111111111";
constant ext20_0: std_logic_vector(19 downto 0):= "00000000000000000000";
constant ext20_1: std_logic_vector(19 downto 0):= "11111111111111111111";
constant ext12_0: std_logic_vector(11 downto 0):= "000000000000";
constant ext12_1: std_logic_vector(11 downto 0):= "111111111111";

begin

process(instruccion, mask_b0,tipo_inst) 
begin

case tipo_inst is

	when "000" => --TIPO I 
		salida(10 downto 0) <= instruccion(30 downto 20);
			if instruccion(31) = '1' then
				salida(31 downto 11) <= (others => '1');
			elsif instruccion(31) = '0' then
				salida(31 downto 11) <= (others => '0');
			end if;
			
	when "001" => --TIPO S
		salida(10 downto 5) <= instruccion(30 downto 25);
		salida(4 downto 0) <= instruccion(11 downto 7);
			if instruccion(31) = '1' then
				salida(31 downto 11) <= ext21_1;
			elsif instruccion(31) = '0' then
				salida(31 downto 11) <= ext21_0;
			end if;
			
	when "010" => 
		salida(11) <= instruccion(7);
		salida(10 downto 5) <= instruccion(30 downto 25);
		salida(4 downto 1) <= instruccion(11 downto 8);
		salida(0) <= '0';
			if instruccion(31) = '1' then
				salida(31 downto 12) <= ext20_1;
			elsif instruccion(31) = '0' then
				salida(31 downto 12) <= ext20_0;
			end if;
			
	when "011" => 
		salida(31 downto 12) <= instruccion(31 downto 12);
		salida(11 downto 0) <= (others => '0');
		
	when "100" => 
		salida(19 downto 12) <= instruccion(19 downto 12);
		salida(11) <= instruccion(20);
		salida(10 downto 5) <= instruccion(30 downto 25);
		salida(4 downto 1) <= instruccion(24 downto 21);
		salida(0) <= '0';
			if instruccion(31) = '1' then
				salida(31 downto 20) <= ext12_1;
			elsif instruccion(31) = '0' then
				salida(31 downto 20) <= ext12_0;
			end if;
	
	when others => 
		salida(31 downto 0) <= (others => '0');

end case;
		
if mask_b0 = '1' then
	salida(0) <= '0';
end if;

end process;

--salida(0) <= '0' when mask_b0 = '1'; esto no iba no se por qué y lo metí en el process
inm <= salida;

end behavioural;
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		