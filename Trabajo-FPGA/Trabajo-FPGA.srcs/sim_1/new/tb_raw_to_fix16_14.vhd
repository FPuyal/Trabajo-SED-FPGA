library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_raw_to_fix16_14 is
end entity tb_raw_to_fix16_14;

architecture testbench of tb_raw_to_fix16_14 is
    -- Component under test (CUT)
    component raw_to_fix16_14
        port (
            valor_raw     : in  std_logic_vector(11 downto 0);
            valor_fix16_14: out std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals for connecting to the CUT
    signal valor_raw     : std_logic_vector(11 downto 0);
    signal valor_fix16_14: std_logic_vector(15 downto 0);

begin
    -- Instantiate the CUT
    uut: raw_to_fix16_14
        port map (
            valor_raw     => valor_raw,
            valor_fix16_14 => valor_fix16_14
        );

    -- Test process
    process
        variable expected_signed : signed(15 downto 0);
        variable output_signed   : signed(15 downto 0);
    begin
        -- Test case 1: Minimum value (-2048)
        valor_raw <= std_logic_vector(to_signed(-2048, 12));
        wait for 10 ns;
        expected_signed := to_signed(-2048 * 8, 16);
        output_signed := signed(valor_fix16_14);
        report "Input: " & integer'image(to_integer(signed(valor_raw))) & 
               ", Output: " & integer'image(to_integer(output_signed)) & 
               ", Expected: " & integer'image(to_integer(expected_signed));
        assert output_signed = expected_signed report "Test case 1 failed" severity error;

        -- Test case 2: Maximum value (+2047)
        valor_raw <= std_logic_vector(to_signed(2047, 12));
        wait for 10 ns;
        expected_signed := to_signed(2047 * 8, 16);
        output_signed := signed(valor_fix16_14);
        report "Input: " & integer'image(to_integer(signed(valor_raw))) & 
               ", Output: " & integer'image(to_integer(output_signed)) & 
               ", Expected: " & integer'image(to_integer(expected_signed));
        assert output_signed = expected_signed report "Test case 2 failed" severity error;

        -- Test case 3: Zero (0)
        valor_raw <= std_logic_vector(to_signed(0, 12));
        wait for 10 ns;
        expected_signed := to_signed(0, 16);
        output_signed := signed(valor_fix16_14);
        report "Input: " & integer'image(to_integer(signed(valor_raw))) & 
               ", Output: " & integer'image(to_integer(output_signed)) & 
               ", Expected: " & integer'image(to_integer(expected_signed));
        assert output_signed = expected_signed report "Test case 3 failed" severity error;

        -- Test case 4: Mid positive value (1024)
        valor_raw <= std_logic_vector(to_signed(1024, 12));
        wait for 10 ns;
        expected_signed := to_signed(1024 * 8, 16);
        output_signed := signed(valor_fix16_14);
        report "Input: " & integer'image(to_integer(signed(valor_raw))) & 
               ", Output: " & integer'image(to_integer(output_signed)) & 
               ", Expected: " & integer'image(to_integer(expected_signed));
        assert output_signed = expected_signed report "Test case 4 failed" severity error;

        -- Test case 5: Mid negative value (-1024)
        valor_raw <= std_logic_vector(to_signed(-1024, 12));
        wait for 10 ns;
        expected_signed := to_signed(-1024 * 8, 16);
        output_signed := signed(valor_fix16_14);
        report "Input: " & integer'image(to_integer(signed(valor_raw))) & 
               ", Output: " & integer'image(to_integer(output_signed)) & 
               ", Expected: " & integer'image(to_integer(expected_signed));
        assert output_signed = expected_signed report "Test case 5 failed" severity error;

        -- End simulation
        report "All test cases passed" severity note;
        wait;
    end process;
end architecture testbench;

