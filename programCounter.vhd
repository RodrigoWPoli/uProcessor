library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity programCounter is
   port( clk      : in std_logic;
         wr_en    : in std_logic;
		 reset    : in std_logic;
         data_in  : in unsigned(15 downto 0)
   );
end entity;

architecture a_programCounter of programCounter is
   component register16bits 
    port (
        clk   : in std_logic;
        reset : in std_logic;
        enable: in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    ); 
	end component;
	
   signal data_out: unsigned(15 downto 0);
   signal data_in_s: unsigned(15 downto 0);
  
begin
 pcreg : register16bits
 port map
  (
    data_in => data_in_s,
    data_out => data_out,
    clk  => clk,
    enable => wr_en ,
    reset  => reset
  
  );
   process(clk,wr_en)  
   begin     
         if rising_edge(clk) then
            data_in_s <= data_out + "0000000000000001";
         end if;
   end process;
   
end architecture;