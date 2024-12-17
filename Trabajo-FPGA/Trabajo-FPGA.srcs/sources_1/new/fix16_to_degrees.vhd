library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entidad que convierte valores en formato fix16_13 (radianes) a grados enteros
entity fix16_to_degrees is
    Port (
        fix_in    : in  signed(15 downto 0); -- Entrada en formato fix16_13 (16 bits con signo)
        degrees   : out signed(11 downto 0) -- Salida en grados (12 bits con signo)
    );
end fix16_to_degrees;

architecture Behavioral of fix16_to_degrees is
    -- Constante de escala: 57.2958 (180/pi) multiplicado por 2^13 para ajustar la fracción
    -- Esto permite la conversión directa de radianes a grados sin perder precisión.
    constant SCALE_FACTOR : integer := 46905; -- 57.2958 * 2^13 ≈ 46905
begin
    process(fix_in)
        variable result : integer; -- Variable para almacenar el resultado temporal
    begin
        -- Multiplicación del valor en fix16_13 por el factor de escala
        -- Luego se desplaza a la derecha 13 bits para "dividir" por 2^13, compensando la parte fraccional.
        result := (to_integer(fix_in) * SCALE_FACTOR) / (2**13);
        
        -- Limitar el resultado a 12 bits con signo (-2048 a 2047 grados, suficiente para -180 a 180)
        degrees <= to_signed(result, 12);
    end process;
end Behavioral;

