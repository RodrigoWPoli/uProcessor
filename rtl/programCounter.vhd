library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity programCounter is
   port( clk       : in std_logic;
         pc_en : in std_logic;
         reset     : in std_logic;
         data_in   : in unsigned(6 downto 0);
         jump_en   : in std_logic;
         jump_cond : in std_logic;               -- jump condicional 
         jump_addr : in unsigned(6 downto 0)    -- endereco do jump
   );
end entity;

architecture rtl of programCounter is
   component registerPC 
    port (
        clk   : in std_logic;
        reset : in std_logic;
        wr_en: in std_logic;
        data_in  : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
    ); 
    end component;
    component stateMachine is
      port (
         clk       : in std_logic;
         reset     : in std_logic;
         data_out  : out std_logic
     );
    end component;

   signal data_out: unsigned(6 downto 0);
   signal data_in_s: unsigned(6 downto 0);
   signal state: std_logic := '0';  -- maquina de estado de 1 bit

begin
 pcreg : registerPC
 port map
  (
    data_in => data_in_s,
    data_out => data_out,
    clk  => clk,
    wr_en => pc_en,
    reset  => reset

  );
 sm : stateMachine port map (
   clk => clk,
   reset => reset,
   data_out => state
 );
   process(clk)
   begin
   if reset = '1' then
            data_in_s <= (others => '0'); 
        elsif rising_edge(clk) then
            case state is
                when '0' => -- Vai para o execute/decode
                    data_in_s <= data_out;
                when '1' =>  -- volta para o fetch
                    if jump_en = '1' and jump_cond = '1' then
                        data_in_s <= jump_addr;  -- jump condicional
                    else
                        data_in_s <= data_out + "0000000000000001";  -- incrementa + 1 na saida 
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end process;


end architecture;