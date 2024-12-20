library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    Port (
        RESET       : in  STD_LOGIC;
        CLK         : in  STD_LOGIC;
        PUSHBUTTON  : in  STD_LOGIC;
        STATE_OUT   : out STD_LOGIC_VECTOR (1 downto 0) -- Salida del estado actual
    );
end FSM;

architecture Behavioral of FSM is
    type STATES is (S0, S1); -- Dos estados: S0 (eje X), S1 (eje Y)
    signal current_state: STATES := S0;
    signal next_state: STATES;

    -- Señales para debouncing y detección de flanco
    signal pushbutton_last: STD_LOGIC := '0';
    signal pushbutton_edge: STD_LOGIC := '0';
    
    signal s_intermedia: STD_LOGIC_VECTOR(1 downto 0);
begin

    -- Proceso para la detección de flancos del botón
    edge_detection: process(CLK)
    begin
        if rising_edge(CLK) then
            pushbutton_edge <= PUSHBUTTON and not pushbutton_last; -- Detecta flanco de subida
            pushbutton_last <= PUSHBUTTON;
        end if;
    end process;

    -- Proceso para el registro de estado
    state_register: process(RESET, CLK)
    begin
        if RESET = '0' then
            current_state <= S0;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

    -- Proceso para determinar el siguiente estado
    next_state_decod: process(pushbutton_edge, current_state)
    begin
        next_state <= current_state; -- Por defecto, el siguiente estado es el actual
        case current_state is
            when S0 =>
                if pushbutton_edge = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                if pushbutton_edge = '1' then
                    next_state <= S0;
                end if;
            when others =>
                next_state <= S0;
        end case;
    end process;

    -- Proceso para codificar el estado actual en la salida
    output_decod: process(current_state)
    begin
        case current_state is
            when S0 =>
                 s_intermedia<= "00"; -- Estado 0 (eje X)
            when S1 =>
                s_intermedia<= "01"; -- Estado 1 (eje Y)
            when others =>
                s_intermedia<= "10";
        end case;
    end process;
STATE_OUT<=s_intermedia;
end Behavioral;

