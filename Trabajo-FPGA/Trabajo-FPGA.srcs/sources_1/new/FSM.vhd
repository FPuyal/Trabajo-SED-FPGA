library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PUSHBUTTON : in STD_LOGIC;
           state : out STD_LOGIC_VECTOR (1 downto 0));
end FSM;

architecture Behavioral of FSM is
type STATES is (S0, S1);
signal current_state: STATES := S0;
signal next_state: STATES; 
begin
 state_register: process(RESET, CLK)
 begin
  if RESET = '0' then
    current_state <= S0;
  elsif rising_edge(CLK) then
   current_state <= next_state;
  end if;
 end process;
 
 next_state_decod: process(PUSHBUTTON,current_state)
 begin
  next_state <= current_state;
  case current_state is
    when S0 =>
     if PUSHBUTTON = '1' then
        next_state <= S1;
     end if;
    when S1 =>
     if PUSHBUTTON = '1' then
        next_state <= S0;
     end if;
    when others =>
     next_state <= S0;
  end case;
 end process;
 
 output_decod: process (current_state)
 begin
  state <= (OTHERS => '0');
  case current_state is
   when s0 =>
    state <= "00";
   when s1 =>
    state <= "01";
   when others =>
    state <= "00";
  end case;
 end process;
end Behavioral;
