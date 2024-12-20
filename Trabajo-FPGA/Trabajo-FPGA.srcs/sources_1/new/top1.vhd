library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.MATH_REAL.ALL; -- Librería para operaciones matemáticas

entity Top is
    port(
        SYSCLK   : in  STD_LOGIC;                -- Reloj del sistema
        RESET    : in  STD_LOGIC;                -- Señal de reinicio (activo bajo)
        MISO     : in  STD_LOGIC;                -- SPI Master-In-Slave-Out
        BTN      : in  STD_LOGIC;                -- Botón para cambiar de estado
        SCLK     : out STD_LOGIC;               -- SPI Clock
        MOSI     : out STD_LOGIC;               -- SPI Master-Out-Slave-In
        SS       : out STD_LOGIC;               -- SPI Slave Select
        AN       : out STD_LOGIC_VECTOR(7 downto 0); -- Ánodos del display
        SEGMENTS : out STD_LOGIC_VECTOR(6 downto 0)  -- Segmentos del display
        
    );
end Top;

architecture Behavioral of Top is
    -- Componentes utilizados
    component AccelerometerCtl
        generic (
            SYSCLK_FREQUENCY_HZ : integer := 108000000;
            SCLK_FREQUENCY_HZ   : integer := 1000000;
            NUM_READS_AVG       : integer := 16;
            UPDATE_FREQUENCY_HZ : integer := 100
        );
        port (
            SYSCLK      : in  STD_LOGIC;
            RESET       : in  STD_LOGIC;
            SCLK        : out STD_LOGIC;
            MOSI        : out STD_LOGIC;
            MISO        : in  STD_LOGIC;
            SS          : out STD_LOGIC;
            ACCEL_X_OUT : out STD_LOGIC_VECTOR(11 downto 0);
            ACCEL_Y_OUT : out STD_LOGIC_VECTOR(11 downto 0);
            ACCEL_Z_OUT : out STD_LOGIC_VECTOR(11 downto 0);
            ACCEL_TMP_OUT : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;

    component raw_to_fix16_14 is
    port (
        valor_raw     : in  std_logic_vector(11 downto 0); -- Entrada de 12 bits en complemento a 2
        valor_fix16_14: out std_logic_vector(15 downto 0) -- Salida en formato fix16_14
    );
    end component;
    
    component AngleCalculator
        Port (
            X      : in  STD_LOGIC_VECTOR(15 downto 0);
            Y      : in  STD_LOGIC_VECTOR(15 downto 0);
            ANGULO : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
    component Converter
        Port (
            FIX16_13_IN : in  signed(15 downto 0);
            GRADOS_int : out integer;
            signo       : out std_logic
        );
    end component;

    component split_integer_number_bin
        Port (
            int_in   : in  integer;
            centenas  : out std_logic_vector(3 downto 0);
            decenas   : out std_logic_vector(3 downto 0);
            unidades  : out std_logic_vector(3 downto 0);
            decimas   : out std_logic_vector(3 downto 0);
            signo_in  : in  std_logic;
            signo_out : out std_logic_vector(3 downto 0)
        );
    end component;
    
   component FSM
        Port (
            RESET       : in  STD_LOGIC;
            CLK         : in  STD_LOGIC;
            PUSHBUTTON  : in  STD_LOGIC;
            STATE_OUT   : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;
    
    component FrequencyDivider is
    Port (
        clk_in  : in  STD_LOGIC;  -- Reloj rápido de entrada (por ejemplo, 100 MHz)
        reset   : in  STD_LOGIC;  -- Reset
        clk_out : out STD_LOGIC   -- Reloj lento de salida (por ejemplo, 1 kHz)
    );
   end component;
   
   component RingCounter is
    Port (
        clk       : in  STD_LOGIC;               -- Reloj lento
        reset     : in  STD_LOGIC;               -- Señal de reinicio activa baja
        counter   : out STD_LOGIC_VECTOR(2 downto 0) -- Salida del contador (3 bits)
    );
    end component;
    
    component mux_display is
    Port (
        seleccion : in  STD_LOGIC_VECTOR(2 downto 0); -- Selección del contador (3 bits para 8 opciones)
        entrada   : in  STD_LOGIC_VECTOR(31 downto 0); -- 8 entradas de 4 bits concatenadas
        salida    : out STD_LOGIC_VECTOR(3 downto 0)   -- Salida del dato seleccionado
    );
    end component;
    
    COMPONENT SelectorDisplay is
    Port (
        display_select : in  STD_LOGIC_VECTOR(2 downto 0); -- Selección del display (3 bits)
        anodes         : out STD_LOGIC_VECTOR(7 downto 0) -- Control de ánodos (8 bits)
    );
    end COMPONENT;
    
    component decoder IS
    PORT (
        bin_in : IN std_logic_vector(3 DOWNTO 0);
        seg_out : OUT std_logic_vector(6 DOWNTO 0)
    );
    END component;
   -- component seven_segment_dynamic
     --   Port (
    --        clk       : in  STD_LOGIC;
      --      sign      : in  STD_LOGIC;
     --       STATE_in   : in STD_LOGIC_VECTOR (3 downto 0);
     --       centenas  : in  STD_LOGIC_VECTOR(3 downto 0);
     --       decenas   : in  STD_LOGIC_VECTOR(3 downto 0);
     --       unidades  : in  STD_LOGIC_VECTOR(3 downto 0);
      --      decimas   : in  STD_LOGIC_VECTOR(3 downto 0);
      --      an        : out STD_LOGIC_VECTOR(7 downto 0);
      --      segments  : out STD_LOGIC_VECTOR(7 downto 0)
      --  );
    --end component;
    
    

    -- Señales internas
    signal RESET_N        : STD_LOGIC;                          -- Señal de reinicio invertida
    signal clk_display : std_logic;    --- reloj lento para el display 1kHz
    signal counter : std_logic_vector(2 downto 0);
    signal ACCEL_X, ACCEL_Y, ACCEL_Z : STD_LOGIC_VECTOR(11 downto 0); -- Lecturas del acelerómetro
    signal accel_x_exp, accel_y_exp, accel_z_exp : STD_LOGIC_VECTOR(15 downto 0);
    signal ANGULO_X, ANGULO_Y : STD_LOGIC_VECTOR(15 downto 0);
    signal ANGULO_X_DEG, ANGULO_Y_DEG, ANGULO_X_DEG_desplazado, ANGULO_Y_DEG_desplazado: integer;
    signal SIGNO_X, SIGNO_Y : STD_LOGIC;
   -- Señales para los dígitos y signo del eje X
    signal CENTENAS_X, DECENAS_X, UNIDADES_X, DECIMAS_X : STD_LOGIC_VECTOR(3 downto 0);
    signal SIGNO_X_DISPLAY : STD_LOGIC_vector(3 downto 0);
    
    -- Señales para los dígitos y signo del eje Y
    signal CENTENAS_Y, DECENAS_Y, UNIDADES_Y, DECIMAS_Y : STD_LOGIC_VECTOR(3 downto 0);
    signal SIGNO_Y_DISPLAY : STD_LOGIC_vector(3 downto 0);
    
    -- Señales seleccionadas para el display dinámico
    signal CENTENAS, DECENAS, UNIDADES, DECIMAS : STD_LOGIC_VECTOR(3 downto 0);
    signal SIGNO_DISPLAY : STD_LOGIC_vector(3 downto 0);
    
    -- Señal de estado de la FSM
    signal STATE : STD_LOGIC_VECTOR(1 downto 0);
    
    --Señal para decirle al display si mostrar x o y
    signal estado: std_logic_vector(3 downto 0);
    
    -- Salida del Mux
    signal Mux_in: std_logic_vector(31 downto 0);
    signal Mux_out: std_logic_vector(3 downto 0);
    
    
begin
    -- Invertir la señal de reinicio
    RESET_N <= not RESET;

    -- Instancia del Acelerómetro
    Accelerometer: AccelerometerCtl
        generic map (
            SYSCLK_FREQUENCY_HZ => 108000000,
            SCLK_FREQUENCY_HZ   => 1000000,
            NUM_READS_AVG       => 16,
            UPDATE_FREQUENCY_HZ => 100
        )
        port map (
            SYSCLK      => SYSCLK,
            RESET       => RESET_N,
            SCLK        => SCLK,
            MOSI        => MOSI,
            MISO        => MISO,
            SS          => SS,
            ACCEL_X_OUT => ACCEL_X,
            ACCEL_Y_OUT => ACCEL_Y,
            ACCEL_Z_OUT => ACCEL_Z,
            ACCEL_TMP_OUT => open
        );

 
     expander_x: raw_to_fix16_14 
    port map (
        valor_raw  => ACCEL_X,
        valor_fix16_14  =>  accel_x_exp
    );
    
     expander_y: raw_to_fix16_14 
    port map (
        valor_raw  => ACCEL_y,
        valor_fix16_14  =>  accel_y_exp
    );

     expander_z: raw_to_fix16_14 
    port map (
        valor_raw  => ACCEL_z,
        valor_fix16_14  =>  accel_z_exp
    );
   


      -- Calculador de ángulo para el eje X
    calc_angle_x: AngleCalculator
        port map (
            X      => accel_z_exp,
            Y      => accel_x_exp,
            ANGULO => ANGULO_X
        );

    -- Calculador de ángulo para el eje Y
    calc_angle_y: AngleCalculator
        port map (
            X      => accel_y_exp,
            Y      => accel_z_exp,
            ANGULO => ANGULO_Y
        );
            
         -- Instancia del convertidor para el eje X
    converter_x: Converter
        port map (
            FIX16_13_IN => signed(ANGULO_X), -- Entrada del ángulo en formato signed
            GRADOS_INT  => ANGULO_X_DEG,    -- Salida como entero escalado
            signo       => SIGNO_X          -- Signo del ángulo
        );
    
    -- Instancia del convertidor para el eje Y
    converter_y: Converter
        port map (
            FIX16_13_IN => signed(ANGULO_Y), -- Entrada del ángulo en formato signed
            GRADOS_INT  => ANGULO_Y_DEG,    -- Salida como entero escalado
            signo       => SIGNO_Y          -- Signo del ángulo
        );
 
  process(SIGNO_X, ANGULO_X_DEG)
begin
    if SIGNO_X = '0' then
        ANGULO_X_DEG_desplazado <= 1800 - ANGULO_X_DEG;
    else
        ANGULO_X_DEG_desplazado <= 1800 + ANGULO_X_DEG;
    end if;
end process;

         -- División en dígitos para el eje X
    split_x: split_integer_number_bin
        port map (
            int_in   => ANGULO_X_DEG_desplazado,   -- Ángulo del eje X en grados reales
            centenas  => CENTENAS_X,    -- Centenas del eje X
            decenas   => DECENAS_X,     -- Decenas del eje X
            unidades  => UNIDADES_X,    -- Unidades del eje X
            decimas   => DECIMAS_X,     -- Décimas del eje X
            signo_in  => SIGNO_X,       -- Signo del ángulo del eje X
            signo_out => SIGNO_X_DISPLAY -- Salida del signo del eje X
        );
    
    -- División en dígitos para el eje Y
    split_y: split_integer_number_bin
        port map (
            int_in   => ANGULO_Y_DEG,   -- Ángulo del eje Y en grados reales
            centenas  => CENTENAS_Y,    -- Centenas del eje Y
            decenas   => DECENAS_Y,     -- Decenas del eje Y
            unidades  => UNIDADES_Y,    -- Unidades del eje Y
            decimas   => DECIMAS_Y,     -- Décimas del eje Y
            signo_in  => SIGNO_Y,       -- Signo del ángulo del eje Y
            signo_out => SIGNO_Y_DISPLAY -- Salida del signo del eje Y
        );
    
    
    -- FSM para controlar el estado
    fsm_inst: FSM
    port map (
        RESET       => RESET_N,  -- Señal de reinicio
        CLK         => SYSCLK,   -- Reloj del sistema
        PUSHBUTTON  => BTN,      -- Botón para cambiar de estado
        STATE_OUT   => STATE     -- Salida del estado actual
    );
    
      -- Proceso para seleccionar datos según el estado de la FSM
    process(STATE, CENTENAS_X, DECENAS_X, UNIDADES_X, DECIMAS_X, SIGNO_X_DISPLAY,
            CENTENAS_Y, DECENAS_Y, UNIDADES_Y, DECIMAS_Y, SIGNO_Y_DISPLAY)
    begin
        case STATE is
            when "00" =>  -- Estado: Mostrar ángulo del eje X
                CENTENAS <= CENTENAS_X;
                DECENAS  <= DECENAS_X;
                UNIDADES <= UNIDADES_X;
                DECIMAS  <= DECIMAS_X;
                SIGNO_DISPLAY <= SIGNO_X_DISPLAY;
                estado <= "1010";
            when "01" =>  -- Estado: Mostrar ángulo del eje Y
                CENTENAS <= CENTENAS_Y;
                DECENAS  <= DECENAS_Y;
                UNIDADES <= UNIDADES_Y;
                DECIMAS  <= DECIMAS_Y;
                SIGNO_DISPLAY <= SIGNO_Y_DISPLAY;
                estado <= "1011";
            when others =>  -- Estado por defecto
                CENTENAS <= (others => '0');
                DECENAS  <= (others => '0');
                UNIDADES <= (others => '0');
                DECIMAS  <= (others => '0');
                SIGNO_DISPLAY <= "0000";
        end case;
    end process;
    
     Mux_in   <= DECIMAS & UNIDADES & DECENAS & CENTENAS & SIGNO_DISPLAY & "00000000" & estado;
     
    FrecDiv: FrequencyDivider
        port map(
        clk_in  => SYSCLK, -- Reloj rápido de entrada (por ejemplo, 100 MHz)
        reset   => reset,  -- Reset
        clk_out  => clk_display
        );
        
    RingCount: RingCounter 
    Port map(
        clk  =>  clk_display,   
        reset =>    reset,
        counter => counter
    );
    
    MuxInst:  mux_display 
    Port map(
        seleccion => counter,
        entrada   => Mux_in,
        salida    => Mux_out
    );

    Disp: SelectorDisplay 
    Port map (
        display_select => counter,
        anodes        => an
    );
    
        Dec:  decoder 
    PORT map (
        bin_in => Mux_out,
        seg_out => segments
    );
   

    -- Instancia del display dinámico
    --display: seven_segment_dynamic
     --   port map (
    --        clk       => SYSCLK,
       --     sign      => SIGNO_DISPLAY,
     --       centenas  => CENTENAS,
     --       decenas   => DECENAS,
     --       unidades  => UNIDADES,
     --       decimas   => DECIMAS,
      --      an        => AN,
      --      segments  => SEGMENTS,
     --       state_in => estado
    --    );
        
end Behavioral;
        
        





