library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top1 is
port(
    SYSCLK : in STD_LOGIC;    -- System Clock
    RESET  : in STD_LOGIC;    -- Reset signal (activo por bajo)
    MISO   : in STD_LOGIC;    -- SPI Master-In-Slave-Out
    LEDS   : out STD_LOGIC_VECTOR (11 downto 0); -- LEDs for ACCEL_X bits
    SCLK   : out STD_LOGIC;   -- SPI Clock
    MOSI   : out STD_LOGIC;   -- SPI Master-Out-Slave-In
    SS     : out STD_LOGIC    -- SPI Slave Select
);
end Top1;

architecture Behavioral of Top1 is

signal ANGULO : std_logic_vector(15 downto 0);

-- Signal for connecting AccelerometerCtl output to LEDs
signal ACCEL_X : STD_LOGIC_VECTOR(11 downto 0);
signal ACCEL_Z : std_logic_vector(11 downto 0);
signal accel_x_aux : std_logic_vector (15 downto 0) := ACCEL_X(11) & ACCEL_X & ACCEL_X(11) & ACCEL_X(11) & ACCEL_X(11);
signal accel_z_aux : std_logic_vector (15 downto 0) := ACCEL_Z(11) & ACCEL_Z & ACCEL_Z(11) & ACCEL_Z(11) & ACCEL_Z(11);

-- Signal for inverted reset
signal RESET_N : STD_LOGIC;

-- Component declaration for AccelerometerCtl
component AccelerometerCtl is
generic 
(
   SYSCLK_FREQUENCY_HZ : integer := 108000000;
   SCLK_FREQUENCY_HZ   : integer := 1000000;
   NUM_READS_AVG       : integer := 16;
   UPDATE_FREQUENCY_HZ : integer := 100
);
port
(
    SYSCLK      : in STD_LOGIC;
    RESET       : in STD_LOGIC; -- Reset input
    SCLK        : out STD_LOGIC;
    MOSI        : out STD_LOGIC;
    MISO        : in STD_LOGIC;
    SS          : out STD_LOGIC;
    ACCEL_X_OUT : out STD_LOGIC_VECTOR (11 downto 0);
    ACCEL_Y_OUT : out STD_LOGIC_VECTOR (11 downto 0);
    ACCEL_Z_OUT : out STD_LOGIC_VECTOR (11 downto 0);
    ACCEL_TMP_OUT : out STD_LOGIC_VECTOR (11 downto 0)
);
end component;

component AngleCalculator is
port(
    X: in STD_LOGIC_VECTOR (15 downto 0); -- Entrada X (16 bits)
    Y: in STD_LOGIC_VECTOR (15 downto 0); -- Entrada Y (16 bits)
    ANGULO: out STD_LOGIC_VECTOR (15 downto 0) -- Salida del ángulo (16 bits)    
);
end component;

begin

-- Invert RESET signal
RESET_N <= not RESET;

-- Instantiate the AccelerometerCtl component
Accelerometer: AccelerometerCtl
generic map(
    SYSCLK_FREQUENCY_HZ => 108000000, -- System clock frequency
    SCLK_FREQUENCY_HZ   => 1000000,  -- SPI clock frequency
    NUM_READS_AVG       => 16,       -- Number of samples to average
    UPDATE_FREQUENCY_HZ => 100       -- Update frequency
)
port map(
    SYSCLK      => SYSCLK,
    RESET       => RESET_N, -- Use the inverted reset
    SCLK        => SCLK,
    MOSI        => MOSI,
    MISO        => MISO,
    SS          => SS,
    ACCEL_X_OUT => ACCEL_X,
    ACCEL_Y_OUT => open,  -- Not used
    ACCEL_Z_OUT => ACCEL_Z,
    ACCEL_TMP_OUT => open -- Not used
);

AngleCalc: AngleCalculator
port map(
    X      => accel_x_aux,  -- Conectar accel_x_aux a la entrada X
    Y      => accel_z_aux,  -- Conectar accel_z_aux a la entrada Y
    ANGULO => ANGULO        -- Salida ANGULO
);

-- Map ACCEL_X to LEDs
LEDS <= ACCEL_X;

end Behavioral;

