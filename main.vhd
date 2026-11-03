LIBRARY ieee; 
USE ieee.std_logic_1164.all; -- biblioteca lógica padrão
USE ieee.numeric_std.all; --biblioteca de números
ENTITY main IS -- entradas e saídas do projeto
	PORT(
			SW: IN std_logic_vector(10 downto 0);
			/*
			A -> SW(10) até SW(7) - Primeiro número
			B -> SW(6) até SW(3) - Segundo número
			code -> SW(2) até SW(0) - Código que indica que operação vai acontecer
			*/
			LEDR: OUT std_logic_vector(5 downto 0);
			/*
			LEDR5 -> Se A menor que B acende
			LEDR4 -> Se A maior que B acende
			LEDR3 -> Se A igual B acende
			LEDR2 -> Se deu overflow acende
			LEDR1 -> Zero (?)
			LEDR0 -> Cout(?) - Se a soma der número com 5 bits ele ligado ou não representa o bit que falta
			*/
			LEDG: OUT std_logic_vector(3 downto 0);
			HEX0 : OUT STD_LOGIC_VECTOR(6 downto 0); -- bit menos significativo do code
         HEX1 : OUT STD_LOGIC_VECTOR(6 downto 0); -- bit mais significativo do code
         HEX2 : OUT STD_LOGIC_VECTOR(6 downto 0); -- bit menos significativo do B
         HEX3 : OUT STD_LOGIC_VECTOR(6 downto 0); -- bit mais significativo do B
			HEX4 : OUT STD_LOGIC_VECTOR(6 downto 0); -- bit menos significativo do A
			HEX5 : OUT STD_LOGIC_VECTOR(6 downto 0); -- bit mais significativo do A
			HEX6 : OUT STD_LOGIC_VECTOR(6 downto 0); -- bit menos significativo do resultado
			HEX7 : OUT STD_LOGIC_VECTOR(6 downto 0); -- bit mais significativo do resultado
			s : OUT STD_LOGIC_VECTOR(7 downto 0);
			/*
			Soma -> s(7 downto 4) 
			Subtração -> s(3 downto 0)
			*/
			m : OUT STD_LOGIC_VECTOR(3 downto 0); -- bits da multiplicação de A e B
			o : OUT STD_LOGIC_VECTOR(3 downto 0); --bits do or entre A e B
			an: OUT STD_LOGIC_VECTOR(3 downto 0); -- bits do and entre A e B
			n: OUT STD_LOGIC_VECTOR(3 downto 0); -- bits do not B
			cmp: OUT STD_LOGIC_VECTOR(3 downto 0); -- cmp(0) se A menor que B, cmp (1) se A maior que B e cmp (2) se A igual a B, cmp(3) é só pra ficar do mesmo tamanho que os outros
			COUTS: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			);
END main;
		ARCHITECTURE estrutura OF main IS
			SIGNAL RESULT: std_logic_vector(3 downto 0);
			COMPONENT add4
			PORT(
				a: IN std_logic_vector (3 downto 0);
				b: IN std_logic_vector (3 downto 0);
				cin: IN std_logic;
				s: OUT std_logic_vector(3 downto 0);
				cout: OUT std_logic
			);
			END COMPONENT;
			COMPONENT cmpb
			PORT(
			a: IN STD_LOGIC_VECTOR(3 downto 0);
			b: IN STD_LOGIC_VECTOR(3 downto 0);
			e: OUT STD_LOGIC;
			g: OUT STD_LOGIC;
			l: OUT STD_LOGIC
			);
			END COMPONENT;
			-- uso do somador pra conseguir a soma e a subtração
			-- uso do somador pra conseguir a multiplicação
			-- comparador
			
			COMPONENT mul
				PORT(a : IN std_logic_vector(1 downto 0);
					  b : IN std_logic_vector(1 downto 0);
					  m : OUT std_logic_vector(3 downto 0)
					);
			END COMPONENT;
			
			COMPONENT HEXX
				PORT(PRINT : IN std_logic_vector(3 downto 0);
					  HEXb : OUT std_logic_vector(6 downto 0)
					);
			END COMPONENT; 
						
			SIGNAL ALUOP: STD_LOGIC_VECTOR(3 DOWNTO 0);
			SIGNAL sn2: STD_LOGIC_VECTOR(3 downto 0);
			SIGNAL sn1: STD_LOGIC_VECTOR(3 downto 0);
	BEGIN
				--MOSTRAR A
				stg1: hexx PORT MAP(SW(10 DOWNTO 7),HEX4(6 DOWNTO 0));
				HEX5(6 DOWNTO 0)<= "1111111";
				--MOSTRAR B
				stg2: hexx PORT MAP(SW(6 DOWNTO 3),HEX2(6 DOWNTO 0));
				HEX3(6 DOWNTO 0)<= "1111111";
				--MOSTRAR CODE
				ALUOP(3)<='0';
				ALUOP(2 DOWNTO 0) <= SW(2 DOWNTO 0);
				stg3: hexx PORT MAP(ALUOP(3 DOWNTO 0),HEX0(6 DOWNTO 0));
				HEX1(6 DOWNTO 0)<= "1111111";
				
				--função and
				an(3) <= (SW(10) AND SW(6));
			   an(2) <= (SW(9) AND SW(5));
			   an(1) <= (SW(8) AND SW(4));
				an(0) <= (SW(7) AND SW(3));
				
				--função or
				o(3) <= (SW(10) OR SW(6));
			   o(2) <= (SW(9) OR SW(5));
			   o(1) <= (SW(8) OR SW(4));
				o(0) <= (SW(7) OR SW(3));
				
				--FUNÇÃO NOT
				n(3) <= NOT SW(6);
			   n(2) <= NOT SW(5);
			   n(1) <= NOT SW(4);
				n(0) <= NOT SW(3);
				
				--FUNÇÃO SOMA
				U1: add4 PORT MAP(SW(10 DOWNTO 7),SW(6 DOWNTO 3),'0',s(7 DOWNTO 4),COUTS(3));
				
				-- FUNÇÃO SUBTRAÇÃO
				U2: add4 PORT MAP(SW(10 DOWNTO 7),SW(6 DOWNTO 3),'1',sn1(3 DOWNTO 0),COUTS(2));
				
				U2n2: add4 PORT MAP (NOT sn1(3 DOWNTO 0),"0001",'0',sn2(3 DOWNTO 0),COUTS(0));
				
				
				-- FUNÇÃO CMP
				stg: cmpb PORT MAP(SW(10 DOWNTO 7),SW(6 DOWNTO 3),cmp(2),cmp(1),cmp(0));
				
				-- FUNÇÃO MULTIPLICAÇÃO
				U3: mul PORT MAP(SW(8 DOWNTO 7),SW(4 DOWNTO 3),m);
				
				
				with cmp(1) select
							s(3 downto 0) <= sn2(3 downto 0) when '0',
									     sn1(3 downto 0) when others;
										  
				
												  
				hex7(5 downto 0) <= "111111";
				
				with SW(2 downto 0) select
						hex7(6) <= not cmp(0) when "101",
									  '1' when others;
		
		
		
		
		
		
		
		WITH SW(2 downto 0) SELECT
			RESULT(3 downto 0) <= "0000" when "000",
										 an(3 downto 0) when "001",
										 o(3 downto 0) when "010",
										 n(3 downto 0) when "011",
										 s(7 downto 4) when "100",
										 s(3 downto 0) when "101",
										 m(3 downto 0) when "110",
										 "0000" when "111",
										 "0000" when others;
										 
		LEDG(0) <= RESULT(0);
		LEDG(1) <= RESULT(1);
		LEDG(2) <= RESULT(2);
		LEDG(3) <= RESULT(3);
		
		--MOSTRAR RESULTADO
		stg5: hexx PORT MAP(RESULT(3 DOWNTO 0),HEX6(6 DOWNTO 0));
		
		with sw(2 downto 0) select -- maior que B
			ledr(5)<= '0' when "000",
			cmp(0) when others;
			
		with sw(2 downto 0) select -- menor que B
			ledr(4)<= '0' when "000",
			cmp(1) when others;
			
		with sw(2 downto 0) select -- igual a B
			ledr(3)<= '0' when "000",
			cmp(2) when others;
			
		with sw(2 downto 0) select -- overflow
			ledr(2)<= '0' when "000",
			((NOT SW(10) AND NOT SW(6) AND RESULT(3)) OR (SW(10) AND SW(6) AND NOT RESULT(3)) OR (NOT SW(10) AND SW(6) AND RESULT(3)) OR (SW(10) AND NOT SW(6) AND NOT RESULT(3))) when others;
			
		with sw(2 downto 0) select -- cout
			ledr(0)<= '0' when "000",
			(COUTS(3) OR COUTS(2)) when others; 
		
		
		WITH RESULT(3 downto 0) SELECT
			LEDR(1)<= '1' when "0000",
						 '0' when others;
		
	END estrutura;
