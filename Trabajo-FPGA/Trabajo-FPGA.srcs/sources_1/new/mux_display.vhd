library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux_display is
    Port (
        seleccion : in  STD_LOGIC_VECTOR(2 downto 0); -- Selección del contador (3 bits para 8 opciones)
        entrada   : in  STD_LOGIC_VECTOR(31 downto 0); -- 8 entradas de 4 bits concatenadas
        salida    : out STD_LOGIC_VECTOR(3 downto 0)   -- Salida del dato seleccionado
    );
end mux_display;

architecture Behavioral of mux_display is
begin
    process(seleccion, entrada)
    begin
        case seleccion is
            when "000" => salida <= entrada(3 downto 0);    -- Estado
            when "001" => salida <= entrada(7 downto 4);    -- Vacío
            when "010" => salida <= entrada(11 downto 8);   -- Vacío
            when "011" => salida <= entrada(15 downto 12);  -- Signo
            when "100" => salida <= entrada(19 downto 16);  -- Centenas
            when "101" => salida <= entrada(23 downto 20);  -- Decenas
            when "110" => salida <= entrada(27 downto 24);  -- Unidades
            when "111" => salida <= entrada(31 downto 28);  --Decimas
            when others => salida <= "0000";               -- Por defecto
        end case;
    end process;
end Behavioral;
