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
begin
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
    next_state_decod: process(PUSHBUTTON, current_state)
    begin
        next_state <= current_state;
        case current_state is
            when S0 =>
                if PUSHBUTTON = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                if PUSHBUTTON = '1' then
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
                STATE_OUT <= "00"; -- Estado 0 (eje X)
            when S1 =>
                STATE_OUT <= "01"; -- Estado 1 (eje Y)
            when others =>
                STATE_OUT <= "00";
        end case;
    end process;
end Behavioral;

