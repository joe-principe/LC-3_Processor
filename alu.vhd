library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definitions
-- i_clk:  1-bit clock input
-- i_aluk: 2-bit operation input (ADD, AND, NOT, PASSA)
-- i_a:    16-bit SR1 input
-- i_b:    16-bit SR2 or immediate input
-- o_res:  16-bit operation result output
entity alu is
    port( 
            i_clk  : in  std_logic;
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
    p_op : process (i_clk) is
    begin
        if rising_edge(i_clk) then
            r_a <= signed(i_a);
            r_b <= signed(i_b);
            case (i_aluk) is
                when "00" => o_res <= std_logic_vector(r_a + r_b);
                when "01" => o_res <= i_a AND i_b;
                when "10" => o_res <= NOT(i_a);
                when "11" => o_res <= i_a;
                when others => null;
            end case;
        end if;
    end process p_op;
end beh;
