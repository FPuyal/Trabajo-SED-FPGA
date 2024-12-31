----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2024 15:17:45
-- Design Name: 
-- Module Name: mux_state - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_state is
   Port (
   centenas_x : in std_logic_vector(3 downto 0);
   decenas_x: in std_logic_vector(3 downto 0);
   unidades_x :in std_logic_vector(3 downto 0);
   decimas_x: in std_logic_vector(3 downto 0);
   signo_x_display: in std_logic_vector(3 downto 0);
   centenas_y : in std_logic_vector(3 downto 0);
   decenas_y: in std_logic_vector(3 downto 0);
   unidades_y :in std_logic_vector(3 downto 0);
   decimas_y: in std_logic_vector(3 downto 0);
   signo_y_display: in std_logic_vector(3 downto 0);
   state: in std_logic_vector(1 downto 0);
   centenas : out std_logic_vector(3 downto 0);
   decenas: out std_logic_vector(3 downto 0);
   unidades :out std_logic_vector(3 downto 0);
   decimas: out std_logic_vector(3 downto 0);
   signo: out std_logic_vector(3 downto 0);
   estado: out std_logic_vector(3 downto 0)
     );
end mux_state;

architecture Behavioral of mux_state is
 
begin
     process(state)
        begin
        if state = "00" then
            centenas <= centenas_x;
            decenas <= decenas_x;
            unidades <= unidades_x;
            decimas <= decimas_x;
            signo <= signo_x_display;
            estado <= "1010";
        else
            centenas <= centenas_y;
            decenas <= decenas_y;
            unidades <= unidades_y;
            decimas <= decimas_y;
            signo <= signo_y_display;
            estado <= "1011"; 
        end if;
      end process;     

end Behavioral;
