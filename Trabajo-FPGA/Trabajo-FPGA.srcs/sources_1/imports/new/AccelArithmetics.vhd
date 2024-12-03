----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2024 18:40:13
-- Design Name: 
-- Module Name: AccelArithmetics - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AccelArithmetics is
generic (
        SYSCLK_FREQUENCY_HZ : integer := 108000000; -- Frecuencia del reloj del sistema
        ACC_X_Y_MAX         : std_logic_vector(9 downto 0) := "01" & X"FF"; -- Máximo para X/Y (+1g, 511)
        ACC_X_Y_MIN         : std_logic_vector(9 downto 0) := (others => '0') -- Mínimo para X/Y (-1g, 0)
    );
    port (
        SYSCLK         : in  std_logic;  -- Señal de reloj del sistema
        RESET          : in  std_logic;  -- Señal de reinicio
        
        -- Datos de entrada del acelerómetro
        ACCEL_X_IN     : in  std_logic_vector(11 downto 0); -- Aceleración en X (12 bits, complemento a dos)
        ACCEL_Y_IN     : in  std_logic_vector(11 downto 0); -- Aceleración en Y (12 bits, complemento a dos)
        ACCEL_Z_IN     : in  std_logic_vector(11 downto 0); -- Aceleración en Z (12 bits, complemento a dos)
        Data_Ready     : in  std_logic;  -- Señal que indica que los datos están listos para procesar

        -- Datos procesados de salida
        ACCEL_X_OUT    : out std_logic_vector(8 downto 0);  -- Aceleración procesada en X
        ACCEL_Y_OUT    : out std_logic_vector(8 downto 0);  -- Aceleración procesada en Y
        ACCEL_MAG_OUT  : out std_logic_vector(11 downto 0)  -- Magnitud de la aceleración
    );
end AccelArithmetics;

architecture Behavioral of AccelArithmetics is
begin
-- implementar el procesamiento de datos del acelerómetro
    ACCEL_X_OUT <= (others => '0');
    ACCEL_Y_OUT <= (others => '0');
    ACCEL_MAG_OUT <= (others => '0');
end Behavioral;
