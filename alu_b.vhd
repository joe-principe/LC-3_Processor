library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definitions
-- i_aluk: 2-bit operation input (ADD, AND, NOT, PASSA)
-- i_a:    16-bit SR1 input
-- i_b:    16-bit SR2 or immediate input
-- o_res:  16-bit operation result output
entity alu is
    port( 
            i_aluk : in  std_logic_vector( 1 downto 0);
            i_a    : in  std_logic_vector(15 downto 0);
            i_b    : in  std_logic_vector(15 downto 0);
            o_res  : out std_logic_vector(15 downto 0)
        );
end alu;

architecture beh of alu is
    -- These register signals are used for the addition operation
    signal r_a : signed := 0;
    signal r_b : signed := 0;
begin
    r_a <= signed(i_a);
    r_b <= signed(i_b);

    with i_aluk select
        o_res <= std_logic_vector(r_a + r_b) when "00",
                 i_a AND i_b when "01",
                 NOT(i_a) when "10",
                 i_a when "11",
                 (others => '0') when others;
end beh;
