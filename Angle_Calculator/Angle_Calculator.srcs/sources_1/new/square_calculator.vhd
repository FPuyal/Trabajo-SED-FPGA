----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2024 11:42:38
-- Design Name: 
-- Module Name: square_calculator - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED;


------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG


entity square_calculator is
  Port (
  dato: in unsigned(11 downto 0);
  salida: out std_logic_vector(7 downto 0) 
  );
end square_calculator;


architecture Behavioral of square_calculator is

COMPONENT cordic_square
  PORT (
    s_axis_cartesian_tvalid : IN STD_LOGIC;
    s_axis_cartesian_tdata : IN std_logic_vector(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT std_logic_vector(7 DOWNTO 0) 
  );
END COMPONENT;
signal dato_ajustado: std_logic_vector(15 downto 0);

begin
dato_ajustado <= "0000" & std_logic_vector(dato);
    u_cordic : cordic_square
      PORT MAP (
        s_axis_cartesian_tvalid => '1',
        s_axis_cartesian_tdata => dato_ajustado,
        m_axis_dout_tvalid => open ,
        m_axis_dout_tdata => salida
      );
end Behavioral;
