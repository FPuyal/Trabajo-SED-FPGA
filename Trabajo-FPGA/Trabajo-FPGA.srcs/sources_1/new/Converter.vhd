library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Converter is
    Port (
        FIX16_13_IN : in  signed(15 downto 0); -- Entrada en formato fix16_13
        GRADOS_INT  : out integer;             -- Salida escalada (con décimas)
        signo       : out std_logic            -- Salida del signo
    );
end Converter;

architecture Behavioral of Converter is
    constant FRACTIONAL_BITS : integer := 13; -- Número de bits fraccionales
    constant RAD_TO_DEG_SCALED : integer := 573; -- 57.2958 escalado por 10 para incluir décimas
begin
    process(FIX16_13_IN)
        variable scaled_value : integer;
    begin
        -- Convertir el valor fix16_13 a entero escalado con décimas
        scaled_value := (to_integer(FIX16_13_IN) * RAD_TO_DEG_SCALED) / (2**FRACTIONAL_BITS);
        signo <= FIX16_13_IN(15); -- Extraer el signo
        GRADOS_INT <= scaled_value; -- Resultado escalado con décimas
    end process;
end Behavioral;

