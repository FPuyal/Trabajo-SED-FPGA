library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity split_integer_number_bin is
    Port (
        int_in    : in  integer;                  -- Entrada escalada
        centenas  : out std_logic_vector(3 downto 0);
        decenas   : out std_logic_vector(3 downto 0);
        unidades  : out std_logic_vector(3 downto 0);
        decimas   : out std_logic_vector(3 downto 0);
        signo_in  : in  std_logic;
        signo_out : out std_logic_vector(3 downto 0)
    );
end split_integer_number_bin;

architecture Behavioral of split_integer_number_bin is
signal signo: std_logic_vector(3 downto 0);
begin
    process(int_in)
        variable temp_value : integer;
    begin
        temp_value := int_in;

        -- Extraer cada dígito
        centenas <= std_logic_vector(to_unsigned((temp_value / 1000) mod 10, 4));
        decenas  <= std_logic_vector(to_unsigned((temp_value / 100) mod 10, 4));
        unidades <= std_logic_vector(to_unsigned((temp_value / 10) mod 10, 4));
        decimas  <= std_logic_vector(to_unsigned(temp_value mod 10, 4));
        signo <= signo_in & signo_in & signo_in & signo_in;
    end process;
    signo_out <= signo;
end Behavioral;

