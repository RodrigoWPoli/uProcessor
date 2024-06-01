library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity register1bit is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        wr_en: in std_logic;
        data_in  : in std_logic;
        data_out : out std_logic
    );
end entity;

architecture rtl of register1bit is
    signal data : std_logic := '0';
begin
    process(clk, reset, wr_en) 
    begin                
        if reset='1' then
          data <= '0';
      elsif wr_en='1' then
         if rising_edge(clk) then
            data <= data_in;
         end if;
      end if;
   end process;
    data_out <= data;
end architecture;