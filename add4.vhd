LIBRARY ieee; 
USE ieee.std_logic_1164.all; -- biblioteca lógica padrão
USE ieee.numeric_std.all; --biblioteca de números

ENTITY add4 IS
	PORT(
			a: IN std_logic_vector (3 downto 0);
			b: IN std_logic_vector (3 downto 0);
			cin: IN std_logic;
			s: OUT std_logic_vector (3 downto 0);
			cout: OUT std_logic
	);
END add4;

ARCHITECTURE logica OF add4 IS
COMPONENT fulladd 
		PORT(
			a,b,cin: IN std_logic;
			s, cout: OUT std_logic
		);
		END COMPONENT;
SIGNAL c: std_logic_vector(2 downto 0);
SIGNAL d: std_logic_vector(3 downto 0);
		BEGIN
		d(3) <= (b(3) xor cin);
		d(2) <= (b(2) xor cin);
		d(1) <= (b(1) xor cin);
		d(0) <= (b(0) xor cin);
		
		
						U1: fulladd PORT MAP(a(0),d(0),cin,s(0),c(2));
					   U2: fulladd PORT MAP(a(1),d(1),c(2),s(1),c(1));
					   U3: fulladd PORT MAP(a(2),d(2),c(1),s(2),c(0));
					   U4: fulladd PORT MAP(a(3),d(3),c(0),s(3),cout);
		END logica;