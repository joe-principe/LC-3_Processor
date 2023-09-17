library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_clk: 1-bit clock input
-- i_val: n-bit input value (5, 6, 9, 11)
-- o_val: 16-bit sign extended output value
entity sext is
    generic(
            g_input_len : natural
           );
    port(
            i_clk : in  std_logic;
            i_val : in  std_logic_vector(g_input_len - 1 downto 0);
            o_val : out std_logic_vector(15 downto 0)
        );
end sext;

architecture beh of sext is
begin
    p_sext : process(i_clk) is
    begin
        if rising_edge(i_clk) then
            o_val <= resize(signed(i_val), o_val'length);
        end if;
    end process p_sext;
end beh;
