LIBRARY ieee; 
USE ieee.std_logic_1164.all; -- biblioteca lógica padrão
USE ieee.numeric_std.all; --biblioteca de números

entity fulladd is
port (
			a,b,cin: in std_logic;
			s,cout: out std_logic
			);
 end fulladd;
 
 architecture logica of fulladd is
  begin
	s <= (a xor b xor cin);
	cout <= ((a and b) or (a and cin) or (b and cin));
	end logica;