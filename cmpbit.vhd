LIBRARY ieee; 
USE ieee.std_logic_1164.all; -- biblioteca lógica padrão
USE ieee.numeric_std.all; --biblioteca de números

ENTITY cmpb IS
	PORT(
			a: IN STD_LOGIC_VECTOR(3 downto 0);
			b: IN STD_LOGIC_VECTOR(3 downto 0);
			e: OUT STD_LOGIC;
			g: OUT STD_LOGIC;
			l: OUT STD_LOGIC
		 );
END cmpb;

ARCHITECTURE logica OF cmpb IS
	BEGIN
		e <= ((a(3) xnor b(3)) AND (a(2) xnor b(2)) AND (a(1) xnor b(1)) AND (a(0) xnor b(0)));
		g <= (a(3) and not b(3)) OR ((a(3) xnor b(3)) and a(2) and not b(2)) OR ((a(3) xnor b(3)) and (a(2) xnor b(2)) and a(1) and not b(1)) OR ((a(3) xnor b(3)) and (a(2) xnor b(2)) and (a(1) xnor b(1)) and a(0) and not b(0));
		l <= (g nor e);
	END logica;