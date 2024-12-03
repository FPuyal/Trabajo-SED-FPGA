----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2024 18:34:27
-- Design Name: 
-- Module Name: ADXL362Ctrl - Behavioral
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

entity ADXL362Ctrl is
    generic (
        SYSCLK_FREQUENCY_HZ : integer := 108000000;
        SCLK_FREQUENCY_HZ   : integer := 1000000;
        NUM_READS_AVG       : integer := 16;
        UPDATE_FREQUENCY_HZ : integer := 1000
    );
    port (
        SYSCLK     : in  std_logic;
        RESET      : in  std_logic;
        ACCEL_X    : out std_logic_vector(11 downto 0);
        ACCEL_Y    : out std_logic_vector(11 downto 0);
        ACCEL_Z    : out std_logic_vector(11 downto 0);
        ACCEL_TMP  : out std_logic_vector(11 downto 0);
        Data_Ready : out std_logic;
        SCLK       : out std_logic;
        MOSI       : out std_logic;
        MISO       : in  std_logic;
        SS         : out std_logic
    );
end entity ADXL362Ctrl;

architecture Behavioral of ADXL362Ctrl is
begin
-- implementar la logica de comunicación SPI
    ACCEL_X <= (others => '0');
    ACCEL_Y <= (others => '0');
    ACCEL_Z <= (others => '0');
    ACCEL_TMP <= (others => '0');
    Data_Ready <= '0';
    SCLK <= '0';
    MOSI <= '0';
    SS <= '0';
end Behavioral;
