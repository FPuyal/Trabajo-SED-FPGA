library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

-- Comentarios y otras librerías

entity AccelerometerCtl is
generic 
(
   SYSCLK_FREQUENCY_HZ : integer := 100000000;
   SCLK_FREQUENCY_HZ   : integer := 1000000;
   NUM_READS_AVG       : integer := 16;
   UPDATE_FREQUENCY_HZ : integer := 100
);
port
(
 SYSCLK     : in STD_LOGIC; -- System Clock
 RESET      : in STD_LOGIC;

 -- SPI interface Signals
 SCLK       : out STD_LOGIC;
 MOSI       : out STD_LOGIC;
 MISO       : in STD_LOGIC;
 SS         : out STD_LOGIC;

 -- Accelerometer data signals
 ACCEL_X_OUT    : out STD_LOGIC_VECTOR (8 downto 0);
 ACCEL_Y_OUT    : out STD_LOGIC_VECTOR (8 downto 0);
 ACCEL_MAG_OUT  : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_TMP_OUT  : out STD_LOGIC_VECTOR (11 downto 0);
 LED           : out STD_LOGIC  -- LED output
);
end AccelerometerCtl;

architecture Behavioral of AccelerometerCtl is

-- Component declarations (ADXL362Ctrl and AccelArithmetics)
component ADXL362Ctrl
generic 
(
   SYSCLK_FREQUENCY_HZ : integer := 100000000;
   SCLK_FREQUENCY_HZ   : integer := 1000000;
   NUM_READS_AVG       : integer := 16;
   UPDATE_FREQUENCY_HZ : integer := 1000
);
port
(
 SYSCLK     : in STD_LOGIC; -- System Clock
 RESET      : in STD_LOGIC;
 
 -- Accelerometer data signals
 ACCEL_X    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_Y    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_Z    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_TMP  : out STD_LOGIC_VECTOR (11 downto 0);
 Data_Ready : out STD_LOGIC;
 
 --SPI Interface Signals
 SCLK       : out STD_LOGIC;
 MOSI       : out STD_LOGIC;
 MISO       : in STD_LOGIC;
 SS         : out STD_LOGIC
);
end component;

-- Signal declarations for accelerometer data
signal ACCEL_X    : STD_LOGIC_VECTOR (11 downto 0);
signal ACCEL_Y    : STD_LOGIC_VECTOR (11 downto 0);
signal ACCEL_Z    : STD_LOGIC_VECTOR (11 downto 0);

signal Data_Ready : STD_LOGIC;

-- Intermediate signals for calculations
signal ACCEL_X_INT : integer;
signal ACCEL_Y_INT : integer;
signal ACCEL_Z_INT : integer;
signal ACCEL_MAG_SQ : integer;
signal magnitude : integer;
signal inclination : integer;
signal LED_signal : STD_LOGIC := '0';

-- Constant for 45 degrees threshold
constant THRESHOLD : integer := 707;  -- 0.707 * 1000

-- Constant for the scale factor (fixed-point)
constant SCALE : integer := 1000;

-- Table for approximating the square root (for small numbers)
type sqrt_table_type is array(0 to 1023) of integer; -- up to 1023 for simple range
constant sqrt_table : sqrt_table_type := (
   0 => 0,   1 => 1,   2 => 1,   3 => 1,   4 => 2,   5 => 2,   6 => 2,   7 => 2,   -- Initial values
   8 => 2,   9 => 3,  10 => 3,  11 => 3,  12 => 3,  13 => 3,  14 => 4,  15 => 4,   -- More values
   -- Continue filling the table with precomputed square roots for small numbers...
   -- Ensure the table has enough values for your use case
   others => 31  -- Maximum root approximation (max for 1023^2)
);

constant ACC_RESET_PERIOD_US : integer := 10;
constant ACC_RESET_IDLE_CLOCKS   : integer := ((ACC_RESET_PERIOD_US * 1000) / (1000000000 / SYSCLK_FREQUENCY_HZ));

-- Self-blocking reset counter
signal cnt_acc_reset : integer range 0 to (ACC_RESET_IDLE_CLOCKS - 1):= 0;
signal RESET_INT: std_logic;

begin

-- Reset and clock control
COUNT_RESET: process(SYSCLK, cnt_acc_reset, RESET)
begin
   if SYSCLK'EVENT and SYSCLK = '1' then
      if (RESET = '1') then
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

-- Instantiate the ADXL362Ctrl to read accelerometer data
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
 ACCEL_X    => ACCEL_X,
 ACCEL_Y    => ACCEL_Y, 
 ACCEL_Z    => ACCEL_Z,
 ACCEL_TMP  => ACCEL_TMP_OUT, 
 Data_Ready => Data_Ready, 
 SCLK       => SCLK, 
 MOSI       => MOSI,
 MISO       => MISO, 
 SS         => SS
);

-- Calculate the magnitude and inclination when the data is ready
Accel_Calculation: process(SYSCLK)
begin
   if rising_edge(SYSCLK) then
      if Data_Ready = '1' then
         -- Convert ACCEL_X, ACCEL_Y, ACCEL_Z to integer values (signed)
         ACCEL_X_INT <= to_integer(signed(ACCEL_X));
         ACCEL_Y_INT <= to_integer(signed(ACCEL_Y));
         ACCEL_Z_INT <= to_integer(signed(ACCEL_Z));

         -- Calculate the square of the magnitude (X^2 + Y^2 + Z^2) in integer form
         ACCEL_MAG_SQ <= (ACCEL_X_INT * ACCEL_X_INT) + 
                         (ACCEL_Y_INT * ACCEL_Y_INT) + 
                         (ACCEL_Z_INT * ACCEL_Z_INT);

         -- Look up the square root approximation from the table
         magnitude <= sqrt_table(ACCEL_MAG_SQ);

         -- Calculate inclination (ACC_Z / magnitude) using scaled integer
         if magnitude > 0 then
            inclination <= (ACCEL_Z_INT * SCALE) / magnitude;

            -- Compare inclination to threshold
            if inclination > THRESHOLD then
                LED_signal <= '1';  -- Turn on LED
            else
                LED_signal <= '0';  -- Turn off LED
            end if;
         end if;
      end if;
   end if;
end process Accel_Calculation;

-- Map the LED signal to the output pin
LED <= LED_signal;

end Behavioral;
