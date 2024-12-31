library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux_display is
    Port (
        seleccion : in  STD_LOGIC_VECTOR(2 downto 0); -- Selección del contador (3 bits para 8 opciones)
        entrada   : in  STD_LOGIC_VECTOR(31 downto 0); -- 8 entradas de 4 bits concatenadas
        salida    : out STD_LOGIC_VECTOR(3 downto 0);   -- Salida del dato seleccionado
        punto : out std_logic
    );
end mux_display;

architecture Behavioral of mux_display is
begin
    process(seleccion, entrada)
    begin
        case seleccion is
            when "000" => salida <= entrada(3 downto 0);    -- Estado
            punto <= '1';
            when "001" => salida <= entrada(7 downto 4);    -- Vacío
            punto <= '1';
            when "010" => salida <= entrada(11 downto 8);   -- Vacío
            punto <= '1';
            when "011" => salida <= entrada(15 downto 12);  -- Signo
            punto <= '1';
            when "100" => salida <= entrada(19 downto 16);  -- Centenas
            punto <= '1';
            when "101" => salida <= entrada(23 downto 20);  -- Decenas
            punto <= '1';
            when "110" => salida <= entrada(27 downto 24);  -- Unidades con el punto decimal
            punto <= '0';
            when "111" => salida <= entrada(31 downto 28);  --Decimas
            punto <= '1';
            when others => salida <= "0000";               -- Por defecto
            punto <= '1';
        end case;
    end process;
end Behavioral;
