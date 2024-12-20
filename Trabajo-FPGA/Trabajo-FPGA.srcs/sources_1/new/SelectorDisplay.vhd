library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SelectorDisplay is
    Port (
        display_select : in  STD_LOGIC_VECTOR(2 downto 0); -- Selección del display (3 bits)
        anodes         : out STD_LOGIC_VECTOR(7 downto 0) -- Control de ánodos (8 bits)
    );
end SelectorDisplay;

architecture Behavioral of SelectorDisplay is
begin
    process(display_select)
    begin
        case display_select is
            when "000" => anodes <= "01111111"; -- Activar A7
            when "001" => anodes <= "11111111"; -- Activar A6
            when "010" => anodes <= "11111111"; -- Activar A5
            when "011" => anodes <= "11101111"; -- Activar A4
            when "100" => anodes <= "11110111"; -- Activar A3
            when "101" => anodes <= "11111011"; -- Activar A2
            when "110" => anodes <= "11111101"; -- Activar A1
            when "111" => anodes <= "11111110"; -- Activar A0
            when others => anodes <= "11111111"; -- Apaga todos los displays (estado no válido)
        end case;
    end process;
end Behavioral;

