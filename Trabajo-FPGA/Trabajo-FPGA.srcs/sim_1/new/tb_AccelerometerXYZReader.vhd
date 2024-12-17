library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_AccelerometerXYZReader is
-- No ports for a testbench
end entity;

architecture Behavioral of tb_AccelerometerXYZReader is

    -- Component Declaration for the AccelerometerXYZReader
    component AccelerometerXYZReader is
        Port (
            SYSCLK     : in  std_logic;
            RESET      : in  std_logic;
            ACCEL_X    : out std_logic_vector(11 downto 0);
            ACCEL_Y    : out std_logic_vector(11 downto 0);
            ACCEL_Z    : out std_logic_vector(11 downto 0);
            SCLK       : out std_logic;
            MOSI       : out std_logic;
            MISO       : in  std_logic;
            SS         : out std_logic;
            Data_Ready : out std_logic
        );
    end component;

    -- Signals to connect to the DUT (Device Under Test)
    signal SYSCLK     : std_logic := '0';
    signal RESET      : std_logic := '0';
    signal ACCEL_X    : std_logic_vector(11 downto 0);
    signal ACCEL_Y    : std_logic_vector(11 downto 0);
    signal ACCEL_Z    : std_logic_vector(11 downto 0);
    signal SCLK       : std_logic;
    signal MOSI       : std_logic;
    signal MISO       : std_logic := '0';
    signal SS         : std_logic;
    signal Data_Ready : std_logic;

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

    -- Signals to emulate SPI behavior
    signal done_signal     : std_logic := '0';
    signal data_received   : std_logic_vector(7 downto 0) := (others => '0');
    signal spi_data_to_send: std_logic_vector(7 downto 0) := "10101010"; -- Example data
    signal bit_counter     : integer range 0 to 7 := 0;

begin

    -- Instantiate the DUT
    DUT: AccelerometerXYZReader
        Port map (
            SYSCLK     => SYSCLK,
            RESET      => RESET,
            ACCEL_X    => ACCEL_X,
            ACCEL_Y    => ACCEL_Y,
            ACCEL_Z    => ACCEL_Z,
            SCLK       => SCLK,
            MOSI       => MOSI,
            MISO       => MISO,
            SS         => SS,
            Data_Ready => Data_Ready
        );

    -- Clock generation process
    clk_process : process
    begin
        while true loop
            SYSCLK <= '0';
            wait for CLK_PERIOD / 2;
            SYSCLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- SPI Slave Emulation Process
    spi_slave_emulation : process
    begin
        wait until SCLK'event and SCLK = '1'; -- Detect rising edge of SCLK
        if SS = '0' then -- Active low chip select
            if bit_counter < 8 then
                MISO <= spi_data_to_send(bit_counter);
                bit_counter <= bit_counter + 1;
            else
                bit_counter <= 0; -- Reset counter after 8 bits
            end if;
        else
            MISO <= '0'; -- Default idle state
            bit_counter <= 0;
        end if;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Reset the system
        RESET <= '1';
        wait for 20 ns;
        RESET <= '0';
        
        -- Wait for the system to initialize
        wait for 100 ns;

        -- Simulate SPI communication by toggling done_signal and SS
        SS <= '0'; -- Activate slave select
        for i in 0 to 7 loop
            done_signal <= '1';
            wait for CLK_PERIOD;
            done_signal <= '0';
            wait for CLK_PERIOD;
        end loop;
        SS <= '1'; -- Deactivate slave select

        -- End simulation
        wait;
    end process;

end Behavioral;

