library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is
end main_tb;

architecture tb of main_tb is

    -- sinais do testbench
    signal SW : std_logic_vector(10 downto 0);
	 signal LEDG: std_logic_vector(3 downto 0);
	 signal LEDR: std_logic_vector(5 downto 0);
    
begin

    -- instanciação do seu módulo principal
    uut : entity work.main
    port map (
        SW => SW,
		  LEDG => LEDG,
		  LEDR => LEDR
    );

    process

        variable a_int  : integer;
        variable b_int  : integer;
        variable op_int : integer;

    begin

        -- loop das operações (000 até 111)
        for op_int in 0 to 7 loop

            -- loop do A (0000 até 1111)
            for a_int in 0 to 15 loop

                -- loop do B (0000 até 1111)
                for b_int in 0 to 15 loop

                    -- SW(10 downto 7) = A
                    SW(10 downto 7) <= std_logic_vector(to_unsigned(a_int,4));

                    -- SW(6 downto 3) = B
                    SW(6 downto 3) <= std_logic_vector(to_unsigned(b_int,4));

                    -- SW(2 downto 0) = operação
                    SW(2 downto 0) <= std_logic_vector(to_unsigned(op_int,3));

                    wait for 100 ps;

                end loop;

            end loop;

        end loop;

        wait;

    end process;

end tb;