---------------------------------------------------------------------------------
-- Author:  Albert Fazakas
--          Copyright 2014 Digilent, Inc.
---------------------------------------------------------------------------------
-- 
-- Create Date:    15:00:45 03/04/2014 
-- Design Name: 
-- Module Name:    AccelerometerCtl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--       Modified version: Only reads and outputs raw accelerometer data.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AccelerometerCtl is
generic 
(
   SYSCLK_FREQUENCY_HZ : integer := 108000000;
   SCLK_FREQUENCY_HZ   : integer := 1000000;
   NUM_READS_AVG       : integer := 16;
   UPDATE_FREQUENCY_HZ : integer := 100
);
port
(
 SYSCLK     : in STD_LOGIC; -- System Clock
 RESET      : in STD_LOGIC;

 -- SPI interface signals
 SCLK       : out STD_LOGIC;
 MOSI       : out STD_LOGIC;
 MISO       : in STD_LOGIC;
 SS         : out STD_LOGIC;

 -- Raw accelerometer data outputs
 ACCEL_X_OUT    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_Y_OUT    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_Z_OUT    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_TMP_OUT  : out STD_LOGIC_VECTOR (11 downto 0)
);
end AccelerometerCtl;

architecture Behavioral of AccelerometerCtl is

component ADXL362Ctrl
generic 
(
   SYSCLK_FREQUENCY_HZ : integer := 108000000;
   SCLK_FREQUENCY_HZ   : integer := 1000000;
   NUM_READS_AVG       : integer := 16;
   UPDATE_FREQUENCY_HZ : integer := 1000
);
port
(
 SYSCLK     : in STD_LOGIC; -- System Clock
 RESET      : in STD_LOGIC;
 
 -- Raw accelerometer data signals
 ACCEL_X    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_Y    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_Z    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_TMP  : out STD_LOGIC_VECTOR (11 downto 0);
 Data_Ready : out STD_LOGIC;
 
 -- SPI Interface Signals
 SCLK       : out STD_LOGIC;
 MOSI       : out STD_LOGIC;
 MISO       : in STD_LOGIC;
 SS         : out STD_LOGIC
);
end component;

signal ACCEL_X    : STD_LOGIC_VECTOR (11 downto 0);
signal ACCEL_Y    : STD_LOGIC_VECTOR (11 downto 0);
signal ACCEL_Z    : STD_LOGIC_VECTOR (11 downto 0);
signal Data_Ready : STD_LOGIC;

-- Self-blocking reset counter constants
constant ACC_RESET_PERIOD_US : integer := 10;
constant ACC_RESET_IDLE_CLOCKS   : integer := ((ACC_RESET_PERIOD_US * 1000) / (1000000000 / SYSCLK_FREQUENCY_HZ));

signal cnt_acc_reset : integer range 0 to (ACC_RESET_IDLE_CLOCKS - 1) := 0;
signal RESET_INT : std_logic;

begin

-- Create the self-blocking reset counter
COUNT_RESET: process(SYSCLK, cnt_acc_reset, RESET)
begin
   if SYSCLK'EVENT and SYSCLK = '1' then
      if RESET = '1' then
         cnt_acc_reset <= 0;
         RESET_INT <= '1';
      elsif cnt_acc_reset = (ACC_RESET_IDLE_CLOCKS - 1) then
         cnt_acc_reset <= (ACC_RESET_IDLE_CLOCKS - 1);
         RESET_INT <= '0';
      else
         cnt_acc_reset <= cnt_acc_reset + 1;
         RESET_INT <= '1';
      end if;
   end if;
end process COUNT_RESET;

-- Instantiate ADXL362Ctrl for raw data reading
ADXL_Control: ADXL362Ctrl
generic map
(
   SYSCLK_FREQUENCY_HZ  => SYSCLK_FREQUENCY_HZ,
   SCLK_FREQUENCY_HZ    => SCLK_FREQUENCY_HZ,
   NUM_READS_AVG        => NUM_READS_AVG,
   UPDATE_FREQUENCY_HZ  => UPDATE_FREQUENCY_HZ
)
port map
(
 SYSCLK     => SYSCLK, 
 RESET      => RESET_INT, 

 -- Raw accelerometer data signals
 ACCEL_X    => ACCEL_X,
 ACCEL_Y    => ACCEL_Y, 
 ACCEL_Z    => ACCEL_Z,
 ACCEL_TMP  => ACCEL_TMP_OUT,
 Data_Ready => Data_Ready, 

 -- SPI Interface Signals
 SCLK       => SCLK, 
 MOSI       => MOSI,
 MISO       => MISO, 
 SS         => SS
);

-- Map raw accelerometer data directly to outputs
ACCEL_X_OUT <= ACCEL_X;
ACCEL_Y_OUT <= ACCEL_Y;
ACCEL_Z_OUT <= ACCEL_Z;

end Behavioral;
