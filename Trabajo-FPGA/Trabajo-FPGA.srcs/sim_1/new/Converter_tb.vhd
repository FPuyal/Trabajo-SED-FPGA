library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity Converter_tb is
end Converter_tb;

architecture Behavioral of Converter_tb is
    -- Señales para la instancia del DUT (Device Under Test)
    signal FIX16_13_IN : signed(15 downto 0);
    signal GRADOS_REAL : real;

begin
    -- Instancia del DUT
    UUT: entity work.Converter
        port map (
            FIX16_13_IN => FIX16_13_IN,
            GRADOS_REAL => GRADOS_REAL
        );

    -- Proceso para generar estímulos de prueba
    stim_proc: process
    begin
        -- Caso 1: Valor positivo
        FIX16_13_IN <= to_signed(8192, 16); -- 1.0 en formato fix16_13
        wait for 100 ns;
        
        -- Caso 2: Valor fraccional positivo
        FIX16_13_IN <= to_signed(4096, 16); -- 0.5 en formato fix16_13
        wait for 100 ns;

        -- Caso 3: Valor negativo
        FIX16_13_IN <= to_signed(-8192, 16); -- -1.0 en formato fix16_13
        wait for 100 ns;

        -- Caso 4: Valor fraccional negativo
        FIX16_13_IN <= to_signed(-4096, 16); -- -0.5 en formato fix16_13
        wait for 100 ns;

        -- Caso 5: Valor máximo positivo
        FIX16_13_IN <= to_signed(32767, 16); -- Máximo valor positivo
        wait for 100 ns;

        -- Caso 6: Valor mínimo negativo
        FIX16_13_IN <= to_signed(-32768, 16); -- Mínimo valor negativo
        wait for 100 ns;

        -- Finaliza la simulación
        wait;
    end process;

end Behavioral;
