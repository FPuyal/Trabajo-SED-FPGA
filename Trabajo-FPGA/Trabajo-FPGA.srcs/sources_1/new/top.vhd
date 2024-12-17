library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is 
    port(
         SYSCLK     : in  std_logic;                       -- Reloj del sistema
         RESET      : in  std_logic;                       -- Reset del sistema
         SCLK       : out std_logic;                       -- Señal de reloj SPI
         MOSI       : out std_logic;                       -- Señal de datos hacia el esclavo (acelerómetro)
         MISO       : in  std_logic;                       -- Señal de datos desde el esclavo (acelerómetro)
         SS         : out std_logic;                       -- Señal de selección del esclavo (activo en bajo)
         LEDS       : out std_logic_vector (11 downto 0)   -- LEDS de salida
    );
end entity;

architecture Behavioral of top is
    signal Data_Ready: std_logic;
    signal ACCEL_X: std_logic_vector(11 downto 0);
    signal ACCEL_Y: std_logic_vector(11 downto 0);
    signal ACCEL_Z: std_logic_vector(11 downto 0);
    
    -- Para controlar los leds
    signal accel_x_real: real;
    signal accel_x_extended: std_logic_vector (15 downto 0); 
    
    component AccelerometerXYZReader is
        Port (
            SYSCLK     : in  std_logic;                       -- Reloj del sistema
            RESET      : in  std_logic;                       -- Reset del sistema
            ACCEL_X    : out std_logic_vector(11 downto 0);   -- Salida del eje X del acelerómetro
            ACCEL_Y    : out std_logic_vector(11 downto 0);   -- Salida del eje Y del acelerómetro
            ACCEL_Z    : out std_logic_vector(11 downto 0);   -- Salida del eje Z del acelerómetro
            SCLK       : out std_logic;                       -- Señal de reloj SPI
            MOSI       : out std_logic;                       -- Señal de datos hacia el esclavo (acelerómetro)
            MISO       : in  std_logic;                       -- Señal de datos desde el esclavo (acelerómetro)
            SS         : out std_logic;                       -- Señal de selección del esclavo (activo en bajo)
            Data_Ready : out std_logic                        -- Indica cuando los datos están listos
        );
    end component;
    
  --  component AngleCalculator is
  --      Port (
  --          SYSCLK     : in  std_logic;                       -- Reloj del sistema
  --          RESET      : in  std_logic;                       -- Reset del sistema
  --          ACCEL_X    : out std_logic_vector(11 downto 0);   -- Salida del eje X del acelerómetro
  --          ACCEL_Y    : out std_logic_vector(11 downto 0);   -- Salida del eje Y del acelerómetro
  --          ACCEL_Z    : out std_logic_vector(11 downto 0);   -- Salida del eje Z del acelerómetro
  --          SCLK       : out std_logic;                       -- Señal de reloj SPI
  --          MOSI       : out std_logic;                       -- Señal de datos hacia el esclavo (acelerómetro)
  --          MISO       : in  std_logic;                       -- Señal de datos desde el esclavo (acelerómetro)
  --          SS         : out std_logic;                       -- Señal de selección del esclavo (activo en bajo)
  --          Data_Ready : out std_logic                        -- Indica cuando los datos están listos
  --      );
  --  end component;

begin
    -- Instanciación del módulo AccelerometerXZReader
    Accelerometer_Instance: AccelerometerXYZReader
    Port map (
        SYSCLK     => SYSCLK,        -- Conexión del reloj del sistema
        RESET      => RESET,         -- Conexión del reset del sistema
        ACCEL_X    => ACCEL_X,       -- Salida del valor del eje X
        ACCEL_Y    => ACCEL_Y,        -- Salida del valor del eje Y
        ACCEL_Z    => ACCEL_Z,       -- Salida del valor del eje Z
        SCLK       => SCLK,          -- Conexión del reloj SPI del acelerómetro
        MOSI       => MOSI,          -- Conexión del MOSI del acelerómetro
        MISO       => MISO,          -- Conexión del MISO del acelerómetro       
        SS         => SS,            -- Conexión del SS (Slave Select) del acelerómetro
        Data_Ready => Data_Ready     -- Salida para indicar que los datos están listos
    );
    
   -- Accelerometer_Instance: AngleCalculator
   -- Port map (
     --   SYSCLK     => SYSCLK,        -- Conexión del reloj del sistema
       -- RESET      => RESET,         -- Conexión del reset del sistema
        --ACCEL_X    => ACCEL_X,       -- Salida del valor del eje X
       -- ACCEL_Y    => ACCEL_Y,        -- Salida del valor del eje Y
     --   ACCEL_Z    => ACCEL_Z,       -- Salida del valor del eje Z
       -- SCLK       => SCLK,          -- Conexión del reloj SPI del acelerómetro
      --  MOSI       => MOSI,          -- Conexión del MOSI del acelerómetro
      --  MISO       => MISO,          -- Conexión del MISO del acelerómetro       
      --  SS         => SS,            -- Conexión del SS (Slave Select) del acelerómetro
      --  Data_Ready => Data_Ready     -- Salida para indicar que los datos están listos
   -- );
        
    LEDS_Control: process(SYSCLK)
    begin        
        if rising_edge(SYSCLK) then
            if Data_Ready = '1' then
            for i in 0 to 11 loop
                LEDS(i) <= accel_x(i);  -- Asignar cada bit individualmente
            end loop;                
            end if;
        end if;
    end process;
end architecture;