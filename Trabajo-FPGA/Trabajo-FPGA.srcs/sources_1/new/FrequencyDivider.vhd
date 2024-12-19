library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FrequencyDivider is
    Port (
        clk_in  : in  STD_LOGIC;  -- Reloj rápido de entrada (por ejemplo, 100 MHz)
        reset   : in  STD_LOGIC;  -- Reset
        clk_out : out STD_LOGIC   -- Reloj lento de salida (por ejemplo, 1 kHz)
    );
end FrequencyDivider;

architecture Behavioral of FrequencyDivider is
    constant DIVISOR : integer := 100000;  -- Factor de división (para 1 kHz)
    signal counter   : integer range 0 to DIVISOR-1 := 0; -- Contador interno
    signal clk_temp  : STD_LOGIC := '0'; -- Señal temporal para el reloj lento
begin
    process(clk_in, reset)
    begin
        if reset = '0' then
            counter <= 0;
            clk_temp <= '0';
        elsif rising_edge(clk_in) then
            if counter = DIVISOR-1 then
                counter <= 0;
                clk_temp <= not clk_temp; -- Cambiar el estado del reloj lento
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_temp; -- Conectar el reloj lento a la salida
end Behavioral;
