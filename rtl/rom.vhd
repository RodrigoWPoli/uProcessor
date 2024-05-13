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
        0 => "0110111000101101", -- ld r7 45
        1 => "0111010001010011", -- lda 1107
        2 => "0001111000000000", -- add r7 
        3 => "0010100100011010", -- addi 2330
        4 => "0000000000000100",
        5 => "0000000000000101",
        6 => "0000000000000110",
        7 => "0000000000000111",
        8 => "0000000000001000",
        9 => "0000000000001001",
        10 => "0000000111010011",
        11 => "0000000000001011",
        12 => "0000000000001100",
        13 => "0000000000001101",
        14 => "0000000000001110",
        15 => "0000000000001111",
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