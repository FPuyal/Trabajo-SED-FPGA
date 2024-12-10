library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AccelerometerXYZReader is
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
end AccelerometerXYZReader;

architecture Behavioral of AccelerometerXYZReader is

    -- Señales internas de conexión con el módulo SPI_If
    signal data_received : std_logic_vector(7 downto 0);  -- Datos recibidos a través del SPI
    signal data_to_send  : std_logic_vector(7 downto 0);  -- Datos a enviar a través del SPI (comandos/direcciones)
    signal start_signal  : std_logic := '0';              -- Señal para iniciar la transmisión SPI
    signal done_signal   : std_logic := '0';              -- Señal que indica que la transmisión ha terminado
    signal hold_ss_signal: std_logic := '1';              -- Mantener la línea SS baja para recibir continuamente
    signal data_ready_internal : std_logic := '0';

    -- Máquina de estados para gestionar la secuencia de lectura
    type state_type is (IDLE, SEND_READ_CMD_X, SEND_ADDR_X, READ_LOW_BYTE_X, READ_HIGH_BYTE_X,
                        SEND_READ_CMD_Y, SEND_ADDR_Y, READ_LOW_BYTE_Y, READ_HIGH_BYTE_Y,
                        SEND_READ_CMD_Z, SEND_ADDR_Z, READ_LOW_BYTE_Z, READ_HIGH_BYTE_Z, DONE);
    signal current_state, next_state : state_type := IDLE;

    -- Registro para guardar los valores del eje X, Y y Z
    signal accel_x_reg : std_logic_vector(11 downto 0) := (others => '0');
    signal accel_y_reg : std_logic_vector(11 downto 0) := (others => '0');
    signal accel_z_reg : std_logic_vector(11 downto 0) := (others => '0');

begin

    -- Instancia del módulo SPI_If
    SPI_Instance: entity work.SPI_If
        generic map (
            SYSCLK_FREQUENCY_HZ => 108000000,
            SCLK_FREQUENCY_HZ   => 1000000
        )
        port map (
            SYSCLK     => SYSCLK,
            RESET      => RESET,
            Din        => data_to_send,     -- Datos a enviar (comandos/direcciones)
            Dout       => data_received,    -- Datos recibidos
            Start      => start_signal,     -- Señal para iniciar la transmisión
            Done       => done_signal,      -- Señal que indica que la transmisión terminó
            HOLD_SS    => hold_ss_signal,   -- Mantener la línea SS baja
            SCLK       => SCLK,             -- Reloj SPI hacia el acelerómetro
            MOSI       => MOSI,             -- Línea de datos hacia el acelerómetro
            MISO       => MISO,             -- Línea de datos desde el acelerómetro
            SS         => SS                -- Selección del esclavo
        );

    -- Máquina de estados para gestionar la lectura de datos del eje X, Y y Z
    process(SYSCLK, RESET)
    begin
        if RESET = '1' then
            current_state <= IDLE;
            accel_x_reg <= (others => '0');
            accel_y_reg <= (others => '0');
            accel_z_reg <= (others => '0');
        elsif rising_edge(SYSCLK) then
            current_state <= next_state;
        end if;
    end process;

    -- Lógica de transición de la máquina de estados
    process(current_state, done_signal)
    begin
        -- Estado predeterminado es mantenerse en el estado actual
        next_state <= current_state;

        -- Desactivar la señal de inicio por defecto
        start_signal <= '0';

        case current_state is
            when IDLE =>
                -- Reset de data_ready_internal
                data_ready_internal <= '0';
                -- Enviar comando de lectura para el eje X
                data_to_send <= X"0B"; -- Comando de lectura
                start_signal <= '1';
                next_state <= SEND_READ_CMD_X;
                
            when SEND_READ_CMD_X =>
                if done_signal = '1' then
                    -- Enviar dirección del registro del eje X
                    data_to_send <= X"0E"; -- Dirección del registro del eje X
                    start_signal <= '1';
                    next_state <= SEND_ADDR_X;
                end if;

            when SEND_ADDR_X =>
                if done_signal = '1' then
                    -- Leer el primer byte (parte baja) del eje X
                    start_signal <= '1';
                    next_state <= READ_LOW_BYTE_X;
                end if;

           
            when SEND_READ_CMD_Y =>
                if done_signal = '1' then
                    -- Enviar dirección del registro del eje Y
                    data_to_send <= X"10"; -- Dirección del registro del eje Y
                    start_signal <= '1';
                    next_state <= SEND_ADDR_Y;
                end if;

            when SEND_ADDR_Y =>
                if done_signal = '1' then
                    -- Leer el primer byte (parte baja) del eje Y
                    start_signal <= '1';
                    next_state <= READ_LOW_BYTE_Y;
                end if;

            when READ_LOW_BYTE_Y =>
                if done_signal = '1' then
                    accel_y_reg(7 downto 0) <= data_received;  -- Guarda la parte baja del valor de Y
                    start_signal <= '1';  -- Iniciar la próxima lectura para la parte alta
                    next_state <= READ_HIGH_BYTE_Y;
                end if;

            when READ_HIGH_BYTE_Y =>
                if done_signal = '1' then
                    accel_y_reg(11 downto 8) <= data_received(3 downto 0);  -- Guarda la parte alta del valor de Y
                    -- Iniciar el proceso para leer el eje Z
                    data_to_send <= X"0B"; -- Comando de lectura
                    start_signal <= '1';
                    next_state <= SEND_READ_CMD_Z;
                end if;

            when SEND_READ_CMD_Z =>
                if done_signal = '1' then
                    -- Enviar dirección del registro del eje Z
                    data_to_send <= X"12"; -- Dirección del registro del eje Z
                    start_signal <= '1';
                    next_state <= SEND_ADDR_Z;
                end if;

            when SEND_ADDR_Z =>
                if done_signal = '1' then
                    -- Leer el primer byte (parte baja) del eje Z
                    start_signal <= '1';
                    next_state <= READ_LOW_BYTE_Z;
                end if;

            when READ_LOW_BYTE_Z =>
                if done_signal = '1' then
                    accel_z_reg(7 downto 0) <= data_received;  -- Guarda la parte baja del valor de Z
                    start_signal <= '1';  -- Iniciar la próxima lectura para la parte alta
                    next_state <= READ_HIGH_BYTE_Z;
                end if;

            when READ_HIGH_BYTE_Z =>
                if done_signal = '1' then
                    accel_z_reg(11 downto 8) <= data_received(3 downto 0);  -- Guarda la parte alta del valor de Z
                    next_state <= DONE;
                end if;

            when DONE =>
                -- Finaliza la lectura, vuelve a IDLE para empezar de nuevo
                next_state <= IDLE;
                data_ready_internal <= '1';
            when others =>
                next_state <= IDLE;
        end case;
    end process;

    -- Asignar los valores de los registros de aceleración del eje X, Y y Z a las salidas
    ACCEL_X <= accel_x_reg;
    ACCEL_Y <= accel_y_reg;
    ACCEL_Z <= accel_z_reg;
    
    -- Asignación de data_ready_internal a Data_Ready
    Data_Ready <= data_ready_internal;

end Behavioral;
