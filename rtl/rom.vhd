library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
   port( clk      : in std_logic;
         address : in unsigned(6 downto 0);
         data     : out unsigned(15 downto 0) 
   );
end entity;
architecture rtl of rom is
   type mem is array (0 to 127) of unsigned(15 downto 0);
   constant rom_content : mem := (
      -- case adress => content
        0 => "0110011000000101",
        1 => "0110100000001000",
        2 => "1011011000000000", 
        3 => "0001100000000000",
        4 => "1010101000000000",
        5 => "0111000000000001",
        6 => "0011101000000000",
        7 => "1010101000000000",
        8 => "1100001010000000",
        9 => "0110101000000000",
        10 => "0000000000000000",
        11 => "0000000000000000",
        12 => "0000000000000000",
        13 => "0000000000000000",
        14 => "0000000000000000",
        15 => "0000000000000000",
        16 => "0000000000000000",
        17 => "0000000000000000",
        18 => "0000000000000000",
        19 => "0000000000000000",
        20 => "1011101000000000",
        21 => "1010011000000000",
        22 => "1100000001000000",
        23 => "0110011000000000",
      others => (others=>'0')
   );
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         data <= rom_content(to_integer(address));
      end if;
   end process;
end architecture;