----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2024
-- Design Name: Testbench for AngleCalculator
-- Module Name: tb_AngleCalculator
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Testbench for the AngleCalculator module
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for the testbench
entity tb_AngleCalculator is
end tb_AngleCalculator;

architecture Behavioral of tb_AngleCalculator is
    -- Declarar el componente bajo prueba (UUT: Unit Under Test)
    component AngleCalculator
        Port (
            X : in STD_LOGIC_VECTOR(15 downto 0); -- Entrada X
            Y : in STD_LOGIC_VECTOR(15 downto 0); -- Entrada Y
            ANGULO : out STD_LOGIC_VECTOR(15 downto 0) -- Salida ANGULO
        );
    end component;

    -- Señales internas para conectar al UUT
    signal X : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Y : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal ANGULO : STD_LOGIC_VECTOR(15 downto 0);

begin
    -- Instanciar el UUT
    uut: AngleCalculator
        Port map (
            X => X,
            Y => Y,
            ANGULO => ANGULO
        );

    -- Proceso para generar estímulos
    stim_proc: process
    begin
        -- Caso 1: X = 0.5, Y = 0.5 (ángulo = 45° o π/4 en radianes)
        X <= "0010000000000000"; -- 0.5 en formato Fix16_14
        Y <= "0010000000000000"; -- 0.5 en formato Fix16_14
        wait for 200 ns;

        -- Caso 2: X = -0.5, Y = 0.5 (ángulo en el segundo cuadrante, cercano a 135° o 3π/4 en radianes)
        X <= "1110000000000000"; -- -0.5 en formato Fix16_14
        Y <= "0010000000000000"; -- 0.5 en formato Fix16_14
        wait for 200 ns;

        -- Caso 3: X = 0.5, Y = -0.5 (ángulo en el cuarto cuadrante, cercano a -45° o -π/4 en radianes)
        X <= "0010000000000000"; -- 0.5 en formato Fix16_14
        Y <= "1110000000000000"; -- -0.5 en formato Fix16_14
        wait for 200 ns;

        -- Caso 4: X = -0.5, Y = -0.5 (ángulo en el tercer cuadrante, cercano a -135° o -3π/4 en radianes)
        X <= "1110000000000000"; -- -0.5 en formato Fix16_14
        Y <= "1110000000000000"; -- -0.5 en formato Fix16_14
        wait for 200 ns;

        -- Caso 5: X = 1.0, Y = 0.0 (ángulo = 0° o 0 en radianes)
        X <= "0100000000000000"; -- 1.0 en formato Fix16_14
        Y <= "0000000000000000"; -- 0.0 en formato Fix16_14
        wait for 200 ns;

        -- Caso 6: X = 0.0, Y = 1.0 (ángulo = 90° o π/2 en radianes)
        X <= "0000000000000000"; -- 0.0 en formato Fix16_14
        Y <= "0100000000000000"; -- 1.0 en formato Fix16_14
        wait for 200 ns;

        -- Detener la simulación
        wait;
    end process;
end Behavioral;
