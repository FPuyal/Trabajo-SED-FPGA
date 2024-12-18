library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity split_real_number_bin is
    Port (
        real_in  : in  real;                     -- Entrada: número real
        centenas : out std_logic_vector(3 downto 0); -- Salida: centenas en binario
        decenas  : out std_logic_vector(3 downto 0); -- Salida: decenas en binario
        unidades : out std_logic_vector(3 downto 0); -- Salida: unidades en binario
        decimas  : out std_logic_vector(3 downto 0)  -- Salida: décimas en binario
    );
end split_real_number_bin;

architecture Behavioral of split_real_number_bin is
begin
    process(real_in)
        variable temp_scaled_value : integer;
    begin
        -- Escalar el número real para manejar décimas como enteros
        temp_scaled_value := integer(real_in * 10.0); -- Convertir a entero truncando

        -- Separar cada componente y convertir a binario de 4 bits
        centenas <= std_logic_vector(to_unsigned((temp_scaled_value / 1000) mod 10, 4)); -- Centenas
        decenas  <= std_logic_vector(to_unsigned((temp_scaled_value / 100) mod 10, 4));  -- Decenas
        unidades <= std_logic_vector(to_unsigned((temp_scaled_value / 10) mod 10, 4));   -- Unidades
        decimas  <= std_logic_vector(to_unsigned(temp_scaled_value mod 10, 4));          -- Décimas
    end process;
end Behavioral;
