library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_split_real_number_bin is
    -- No hay puertos en el testbench
end tb_split_real_number_bin;

architecture testbench of tb_split_real_number_bin is

    -- Declaración de señales para conectar con la unidad bajo prueba (UUT)
    signal real_in  : real := 0.0;
    signal centenas : std_logic_vector(3 downto 0);
    signal decenas  : std_logic_vector(3 downto 0);
    signal unidades : std_logic_vector(3 downto 0);
    signal decimas  : std_logic_vector(3 downto 0);

    -- Instanciar la unidad bajo prueba (UUT)
    component split_real_number_bin
        Port (
            real_in  : in  real;
            centenas : out std_logic_vector(3 downto 0);
            decenas  : out std_logic_vector(3 downto 0);
            unidades : out std_logic_vector(3 downto 0);
            decimas  : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    -- Instanciación de la UUT
    uut: split_real_number_bin
        Port map (
            real_in  => real_in,
            centenas => centenas,
            decenas  => decenas,
            unidades => unidades,
            decimas  => decimas
        );

    -- Proceso de prueba
    stimulus: process
    begin
        -- Caso 1: Número pequeño
        real_in <= 123.4;
        wait for 10 ns;
        
        -- Caso 2: Número con más decimales
        real_in <= 567.8;
        wait for 10 ns;
        
        -- Caso 3: Número con decimales menores
        real_in <= 90.1;
        wait for 10 ns;
        
        -- Caso 4: Número sin decimales
        real_in <= 432.0;
        wait for 10 ns;

        -- Caso 5: Número grande
        real_in <= 987.6;
        wait for 10 ns;

        -- Finalizar simulación
        wait;
    end process;

end testbench;
