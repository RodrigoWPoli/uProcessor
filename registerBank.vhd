library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity register16bits is
    port
        (
        outAData      : out std_logic_vector(15 downto 0);
        outBData      : out std_logic_vector(15 downto 0);
        writeData     : in  std_logic_vector(15 downto 0);
        writeSel      : in  std_logic_vector(2 downto 0);
        outASel       : in std_logic_vector(2 downto 0);
        outBSel       : in std_logic_vector(2 downto 0);
        writeEnable   : in std_logic;
        clk           : in std_logic;
        rst           : in std_logic
        );
end entity;

architecture rtl of registerBank is

    component register16bits is
        port (
            clk   : in std_logic;
            reset : in std_logic
            
        );
    end component;
begin

    

end architecture;