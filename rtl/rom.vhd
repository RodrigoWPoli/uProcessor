library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
   port( clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(15 downto 0) 
   );
end entity;
architecture rtl of rom is
   type mem is array (0 to 127) of unsigned(15 downto 0);
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
        0 => "0000000000000000",  -- Endereço 0: NOP
        1 => "0000000000000001",  -- Endereço 1: NOP
        2 => "0000000000000010",  -- Endereço 2: NOP
        3 => "0000000000000011",  -- Endereço 3: NOP
        4 => "0000000000000100",  -- Endereço 4: NOP
        5 => "0000000000000101",  -- Endereço 5: NOP
        6 => "0000000000000110",  -- Endereço 6: NOP
        7 => "0000000000000111",  -- Endereço 7: NOP
        8 => "0000000000001000",  -- Endereço 8: NOP
        9 => "0000000000001001",  -- Endereço 9: NOP
        10 => "1111000000010011",  -- Endereço 10: Jump para o endereço 0x0123
        11 => "0000000000001011",  -- Endereço 11: NOP
        12 => "0000000000001100",  -- Endereço 12: NOP
        13 => "0000000000001101",  -- Endereço 13: NOP
        14 => "0000000000001110",  -- Endereço 14: NOP
        15 => "0000000000001111",   -- Endereço 15: NOP
      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_rom(to_integer(endereco));
      end if;
   end process;
end architecture;