library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity ulaBankTL is
    port (
        inData            : in  unsigned(15 downto 0);
        outView           : out unsigned(15 downto 0);
        writeSel          : in  unsigned(2 downto 0);
        outSel            : in unsigned(2 downto 0);
        aluOp             : in unsigned(1 downto 0);
        wr_en, clk, reset : in std_logic;
        zero, carry       : out std_logic
    );
end entity ulaBankTL;

architecture rtl of ulaBankTL is
    component registerBank is
        port
            (
            outData      : out unsigned(15 downto 0);
            inData       : in  unsigned(15 downto 0);
            writeSel     : in  unsigned(2 downto 0);
            outSel       : in unsigned(2 downto 0);
            wr_en        : in std_logic;
            clk          : in std_logic;
            reset        : in std_logic
            );
    end component;
    component register16bits is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            wr_en: in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    component ula is
        port (
            entr0 : in unsigned(15 downto 0);
            entr1 : in unsigned(15 downto 0);
            sel   : in unsigned(1 downto 0);
            saida : out unsigned(15 downto 0);
            zero  : out std_logic;
            carry : out std_logic
        );
    end component;
    component mux2 is
        port (
            in_0, in_1, src   : in std_logic;
            output            : out std_logic
        );
    end component;
    signal ulaOut, ulaInA, ulaInB : unsigned(15 downto 0);
begin
bank : registerBank port map (
    outData  => ulaInA,
    inData   => inData,
    writeSel => writeSel,
    outSel   => outSel,
    wr_en    => wr_en,
    clk      => clk,
    reset    => reset
);
alu : ula port map (
    entr0 => ulaInA,
    entr1 => ulaInB,
    sel   => aluOp,
    saida => ulaOut,
    zero  => zero,
    carry => carry
);
acu : register16bits port map (
    clk      => clk,
    reset    => reset,
    wr_en    => wr_en,
    data_in  => ulaOut,
    data_out => ulaInB
);
    outView <= ulaOut;

end architecture;