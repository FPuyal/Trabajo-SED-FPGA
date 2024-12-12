----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2024 12:03:00
-- Design Name: 
-- Module Name: AngleCalculator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

-- Entity definition
entity AngleCalculator is
Port (
    X: in STD_LOGIC_VECTOR (15 downto 0); -- Entrada X (16 bits)
    Y: in STD_LOGIC_VECTOR (15 downto 0); -- Entrada Y (16 bits)
    ANGULO: out STD_LOGIC_VECTOR (15 downto 0) -- Salida del ángulo (16 bits)
);
end AngleCalculator;

architecture Behavioral of AngleCalculator is
    -- Declarar el componente CORDIC
    COMPONENT cordic_0
      PORT (
        s_axis_cartesian_tvalid : IN STD_LOGIC; -- Señal válida de entrada
        s_axis_cartesian_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Entradas X e Y concatenadas
        m_axis_dout_tvalid : OUT STD_LOGIC; -- Señal válida de salida
        m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- Salida del ángulo
      );
    END COMPONENT;

    -- Declarar señales internas
    signal X_x : STD_LOGIC_VECTOR(31 downto 0); -- Vector de entrada concatenado (X & Y)
    signal valid_out : STD_LOGIC; -- Señal válida de salida del CORDIC

begin
    -- Concatenar las entradas X y Y
    -- X ocupa los 16 bits más significativos, Y ocupa los 16 bits menos significativos
    X_x <= Y & X;

    -- Instanciar el módulo CORDIC
    cordic_inst : cordic_0
      PORT MAP (
        s_axis_cartesian_tvalid => '1', -- Siempre válidas las entradas
        s_axis_cartesian_tdata => X_x, -- Datos de entrada (X concatenado con Y)
        m_axis_dout_tvalid => valid_out, -- Señal de salida válida
        m_axis_dout_tdata => ANGULO -- Resultado del ángulo (salida del CORDIC)
      );

end Behavioral;
