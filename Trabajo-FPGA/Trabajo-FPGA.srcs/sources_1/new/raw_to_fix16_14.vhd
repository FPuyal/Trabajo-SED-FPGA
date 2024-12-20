library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity raw_to_fix16_14 is
    port (
        valor_raw     : in  std_logic_vector(11 downto 0); -- Entrada de 12 bits en complemento a 2
        valor_fix16_14: out std_logic_vector(15 downto 0) -- Salida en formato fix16_14
    );
end entity raw_to_fix16_14;

architecture behavioral of raw_to_fix16_14 is
begin
    process(valor_raw)
        variable signed_value: signed(15 downto 0); -- Variable para almacenar el resultado intermedio con 16 bits
    begin
        -- Convertir entrada a signed y calcular el resultado
        signed_value := resize(resize(signed(valor_raw), 19) * 8, 16); -- Multiplica por 8 y mantiene 16 bits
        -- Asignar el resultado convertido a std_logic_vector directamente desde la variable
        valor_fix16_14 <= std_logic_vector(signed_value);
    end process;
end architecture behavioral;

