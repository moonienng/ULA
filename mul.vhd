library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mul is
	port(
			a : IN std_logic_vector(1 downto 0); -- vetor de 2 bits, representa a1 e a0 do numero A
			b : IN std_logic_vector(1 downto 0); -- vetor de 2 bits, representa b1 e b0 do numero B
			m: OUT std_logic_vector(3 downto 0) -- vetor de 4 bits, representa o resultado da multiplicacao, que da um produto de 4 bits (m3, m2, m1 e m0)
	);
end mul;

architecture logica of mul is
	component fulladd -- uso do componente fulladd (somador completo de 1 bit)
		-- definiçao das entradas e saidas do fulladd
		port(a, b, cin : in std_logic;
		s, cout : out std_logic);
	end component;
	
	signal p00, p10, p01, p11 : std_logic; -- criaçao de 4 sinais internos para armazenamento dos produtos
	signal carry1 : std_logic; -- sinal interno que armazena o carry gerado pelo primeiro somador 
begin
	-- (obs.: a(0) e b(0): produto dos bits menos significativos e a(1) e b(1): produto dos bits mais significativos)
	-- calculo dos produtos PARCIAIS
	p00 <= a(0) AND b(0);
	p10 <= a(1) AND b(0);
	p01 <= a(0) AND b(1);
	p11 <= a(1) AND b(1);
	
	m(0) <= p00; -- bit menos significativo do RESULTADO
	
	U1: fulladd PORT MAP(a => p10, b => p01, cin => '0', s => m(1), cout => carry1); -- primeiro somador completo: soma p10 com p01, o resultado da soma vai para m(1) e o carry que sobrar para carry1
	U2: fulladd PORT MAP(a => p11, b => carry1, cin => '0', s => m(2), cout => m(3)); -- segundo somador completo: soma p11 com carry1 
end logica;