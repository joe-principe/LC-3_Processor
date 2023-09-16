library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_clk: 1-bit clock input
-- i_val: 16-bit input value
-- o_n:   1-bit check for negative boolean value
-- o_z:   1-bit check for zero boolean value
-- o_p:   1-bit check for positive boolean value
entity logic is
    port(
            i_clk : in  std_logic;
            i_val : in  std_logic_vector(15 downto 0);
            o_n   : out std_logic;
            o_z   : out std_logic;
            o_p   : out std_logic
        );
end logic;

architecture beh of logic is
begin
    p_logic : process(i_clk) is
    begin
        if rising_edge(i_clk) then
            if i_val(15) = '1' then
                o_n <= '1';
                o_z <= '0';
                o_p <= '0';
            -- I have no idea if this is a valid way to do this comparison
            elsif i_val AND "1111111111111111" = "0000000000000000" then
                o_n <= '0';
                o_z <= '1';
                o_p <= '0';
            else
                o_n <= '0';
                o_z <= '0';
                o_p <= '0';
            end if;
        end if;
    end process p_logic;
end beh;
