library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity registerPC is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        wr_en: in std_logic;
        data_in  : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
    );
end entity;

architecture rtl of registerPC is
    signal data : unsigned(6 downto 0);
begin
    process(clk, reset, wr_en) 
    begin                
        if reset='1' then
          data <= "0000000";
      elsif wr_en='1' then
         if rising_edge(clk) then
            data <= data_in;
         end if;
      end if;
   end process;
    data_out <= data;
end architecture;