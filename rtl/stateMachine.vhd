library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity stateMachine is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        data  : out std_logic
    );
end entity;

architecture a_state_machine of stateMachine is
    signal estado : std_logic;
begin
    process(clk, reset) 
    begin                
        if reset='1' then
           estado <= '0';
        else
         if rising_edge(clk) then
            estado <= not estado;
         end if;
      end if;
   end process;
    data <= estado;
end architecture;

