library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity stateMachine is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        data_out : out std_logic
    );
end entity;

architecture rtl of stateMachine is
    signal state : std_logic;
begin
    process(clk, reset) 
    begin                
        if reset='1' then
           state <= '0';
        else
         if rising_edge(clk) then
            state <= not state;
         end if;
      end if;
   end process;
    data_out <= state;
end architecture;

