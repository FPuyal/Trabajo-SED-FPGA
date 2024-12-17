library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Fix16_13_to_Radians is
    Port (
        vector_entrada    : in  STD_LOGIC_VECTOR(15 downto 0); -- Vector de entrada de 16 bits
        bit_signo         : out STD_LOGIC;                    -- Bit de signo
        parte_entera      : out INTEGER range -2 to 1;        -- Parte entera (bits 2 y 3)
        parte_decimal     : out REAL;                         -- Parte decimal escalada
        resultado_radianes: out REAL                          -- Resultado final en radianes
    );
end Fix16_13_to_Radians;

architecture Behavioral of Fix16_13_to_Radians is
    -- Señales internas para la conversión
    signal temp_parte_entera   : SIGNED(1 downto 0);       -- Bits 2-3
    signal temp_parte_decimal  : SIGNED(12 downto 0);      -- Bits 4-16
begin
    process(vector_entrada)
        variable real_decimal : REAL;  -- Parte decimal como REAL
        variable real_entera  : REAL;  -- Parte entera como REAL
    begin
        -- Extraer el bit de signo
        bit_signo <= vector_entrada(15);

        -- Extraer y convertir la parte entera (bits 2 y 3)
        temp_parte_entera <= SIGNED(vector_entrada(14 downto 13));
        parte_entera <= to_integer(temp_parte_entera);

        -- Convertir la parte entera a REAL
        real_entera := REAL(to_integer(temp_parte_entera));

        -- Extraer y escalar la parte decimal (bits 4-16)
        temp_parte_decimal <= SIGNED(vector_entrada(12 downto 0));
        real_decimal := REAL(to_integer(temp_parte_decimal)) / 8192.0; -- 2^13 = 8192

        -- Asignar la parte decimal
        parte_decimal <= real_decimal;

        -- Combinar parte entera y decimal para obtener el resultado en radianes
        resultado_radianes <= real_entera + real_decimal;
    end process;
end Behavioral;

