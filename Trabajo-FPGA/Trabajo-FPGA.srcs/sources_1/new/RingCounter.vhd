library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RingCounter is
    Port (
        clk       : in  STD_LOGIC;               -- Reloj lento
        reset     : in  STD_LOGIC;               -- Señal de reinicio activa baja
        counter   : out STD_LOGIC_VECTOR(2 downto 0) -- Salida del contador (3 bits)
    );
end RingCounter;

architecture Behavioral of RingCounter is
    signal ring_counter : STD_LOGIC_VECTOR(2 downto 0) := "000"; -- Contador interno
begin

    process(clk, reset)
    begin
        if reset = '0' then
            ring_counter <= "000"; -- Reiniciar el contador a 000
        elsif rising_edge(clk) then
            if ring_counter = "111" then
                ring_counter <= "000"; -- Reinicia a 000 después de llegar a 111
            else
                ring_counter <= std_logic_vector(unsigned(ring_counter) + 1); -- Incrementa el contador
            end if;
        end if;
    end process;

    counter <= ring_counter; -- Asignar la salida del contador
end Behavioral;

