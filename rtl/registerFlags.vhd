library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity registerFlags is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        rf_en, zero, carry: in std_logic;
        zero_out, carry_out: out std_logic
    );
end entity;

architecture rtl of registerFlags is
    signal zero_s, carry_s : std_logic := '0';
begin
    process(clk, reset) 
    begin                
        if reset='1' then
          zero_s <= '0';
          carry_s <= '0';
      elsif rf_en='1' then
         if rising_edge(clk) then
            zero_s <= zero;
            carry_s <= carry;
         end if;
      end if;
   end process;
    zero_out <= zero_s;
    carry_out <= carry_s;
end architecture;