library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL; -- Librería para operaciones matemáticas

entity Converter is
    Port (
        FIX16_13_IN : in  signed(15 downto 0); -- Entrada en formato fix16_13
        GRADOS_REAL : out real                 -- Salida como número real
    );
end Converter;

architecture Behavioral of Converter is
    constant FRACTIONAL_BITS : integer := 13; -- Número de bits fraccionales
    constant RAD_TO_DEG : real := 57.2958;
begin
    process(FIX16_13_IN)
        variable frac_real : real;
        variable int_real : real;
        variable sol_real : real;
    begin
        -- Extraer y convertir la parte fraccional a un número real
        frac_real := real(to_integer(unsigned(FIX16_13_IN(12 downto 0)))) / 2.0**FRACTIONAL_BITS;
        int_real := real(to_integer(unsigned(FIX16_13_IN(14 downto 13))));
        sol_real := (frac_real + int_real)*RAD_TO_DEG;
        
        -- Asignar el resultado a la salida
        GRADOS_REAL <= sol_real;
    end process;
end Behavioral;
