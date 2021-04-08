library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TBIG is
end TBIG;


architecture TB of TBIG is

signal instruccion: std_logic_vector(31 downto 0); --Instrucción de la ROM con el inmediato por ahí (ir_out)
signal inm			: std_logic_vector(31 downto 0); --El inmediato (extraído de la instrucción)
signal tipo_inst	: std_logic_vector(2 downto 0); --En funciónn del tipo de instrucción, se decodifica de una forma u otra
signal mask_b0		: std_logic; --LSB a 0

--componente asíncrono => no hay clk
begin

InmGen_i	: entity work.InmGen 
	port map(
		instruccion => instruccion,
		inm => inm,
		tipo_inst => tipo_inst,
		mask_b0 => mask_b0
				);
				

p_stim : process
begin

--inicializo movidas
tipo_inst <= "111";
mask_b0 <= '0';
inm <= "00000000000000000000000000000000";
		
--un único valor de instrucción, lo que cambio es el tipo 
instruccion <= "11011011011011011011011011011011";

--INSTRUCCIÓN TIPO I
wait for 7ns;

tipo_inst <= "000";
wait for 1ns;

assert inm = "1111111111111111111110110110110"
report "Error en la instrucción de tipo I"
	severity failure;


--INSTRUCCIÓN TIPO S
wait for 7ns;

tipo_inst <= "001";
wait for 1ns;

assert inm = "1111111111111111111110110101101"
report "Error en la instrucción de tipo S"
	severity failure;


--INSTRUCCIÓN TIPO B
wait for 7ns;

tipo_inst <= "010";
wait for 1ns;

assert inm = "1111111111111111111110110101100"
report "Error en la instrucción de tipo B"
	severity failure;


--INSTRUCCIÓN TIPO U
wait for 7ns;

tipo_inst <= "011";
wait for 1ns;

assert inm = "1101101101101101101000000000000"
report "Error en la instrucción de tipo U"
	severity failure;


--INSTRUCCIÓN TIPO J
wait for 7ns;

tipo_inst <= "100";
wait for 1ns;

assert inm = "11111111111101101101110110110110"
report "Error en la instrucción de tipo J"
	severity failure;


--INSTRUCCIÓN TIPO S CON mask_b0 = '1'
wait for 7ns;

tipo_inst <= "001";
mask_b0 <= '1';
wait for 1ns;

assert inm = "1111111111111111111110110101100"
report "Error en el mask_b0 de la instrucción de tipo S"
	severity failure;



--FIN DE LA SIMULACIÓN
wait for 20ns;

assert false
report "Fin de la simulación"
	severity failure;
	

end process;

end tb;