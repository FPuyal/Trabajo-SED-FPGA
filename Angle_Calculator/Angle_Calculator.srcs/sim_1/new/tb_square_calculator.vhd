library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_square_calculator is
    -- No se definen puertos, ya que es un testbench.
end tb_square_calculator;

architecture behavior of tb_square_calculator is

    -- Señales para conectarse al DUT (Device Under Test)
    signal dato    : unsigned(11 downto 0) := (others => '0');
    signal salida  : std_logic_vector(7 downto 0);
    signal clk     : std_logic := '0';

    constant clk_period : time := 10 ns;

    -- Instanciación del DUT
    component square_calculator
        Port (
            dato   : in unsigned(11 downto 0);
            salida : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    -- Instancia de la entidad que se va a probar
    uut : square_calculator
        Port map (
            dato   => dato,
            salida => salida
        );

    -- Generador de reloj
    clk_process : process
    begin
        while true loop
            clk <= not clk;
            wait for clk_period / 2;
        end loop;
    end process;

    -- Proceso de estímulos
    stimulus_process : process
    begin
        -- Esperar 20 ns para iniciar la simulación
        wait for 20 ns;

        -- Prueba 1: Raíz cuadrada de 4 (Esperado: 2)
        dato <= to_unsigned(4, 12);
        wait for clk_period * 4;

        -- Prueba 2: Raíz cuadrada de 9 (Esperado: 3)
        dato <= to_unsigned(9, 12);
        wait for clk_period * 4;

        -- Prueba 3: Raíz cuadrada de 10 (Esperado: ~3)
        dato <= to_unsigned(10, 12);
        wait for clk_period * 4;

        -- Prueba 4: Raíz cuadrada de 16 (Esperado: 4)
        dato <= to_unsigned(16, 12);
        wait for clk_period * 4;

        -- Prueba 5: Raíz cuadrada de 3000 (Esperado: ~64)
        dato <= to_unsigned(4095, 12);
        wait for clk_period * 2;

        -- Finalizar simulación
        wait;
    end process;

end behavior;

