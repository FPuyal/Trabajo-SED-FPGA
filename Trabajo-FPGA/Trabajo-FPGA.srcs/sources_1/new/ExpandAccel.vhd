library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ExpandAccel is
    Port (
        accel_x_in : in  STD_LOGIC_VECTOR(11 downto 0); -- Entrada X (12 bits)
        accel_y_in : in  STD_LOGIC_VECTOR(11 downto 0); -- Entrada Y (12 bits)
        accel_z_in : in  STD_LOGIC_VECTOR(11 downto 0); -- Entrada Z (12 bits)
        accel_x_out : out STD_LOGIC_VECTOR(15 downto 0); -- Salida expandida X (16 bits)
        accel_y_out : out STD_LOGIC_VECTOR(15 downto 0); -- Salida expandida Y (16 bits)
        accel_z_out : out STD_LOGIC_VECTOR(15 downto 0)  -- Salida expandida Z (16 bits)
    );
end ExpandAccel;

architecture Behavioral of ExpandAccel is
begin
    process(accel_x_in, accel_y_in, accel_z_in)
    begin
        -- Expansión de accel_x
        accel_x_out <= accel_x_in(11) & accel_x_in & accel_x_in(11) & accel_x_in(11) & accel_x_in(11);

        -- Expansión de accel_y
        accel_y_out <= accel_y_in(11) & accel_y_in & accel_y_in(11) & accel_y_in(11) & accel_y_in(11);

        -- Expansión de accel_z
        accel_z_out <= accel_z_in(11) & accel_z_in & accel_z_in(11) & accel_z_in(11) & accel_z_in(11);
    end process;

end Behavioral;

