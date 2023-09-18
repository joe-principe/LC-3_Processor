library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_extend:   n-bit input value (5, 6, 9, 11)
-- o_extended: 16-bit sign extended output value
entity sext is
    generic(
            g_input_len : natural
           );
    port(
            i_extend : in  std_logic_vector(g_input_len - 1 downto 0);
            o_extended : out std_logic_vector(15 downto 0)
        );
end sext;

architecture beh of sext is
begin
    o_extended <= resize(signed(i_extend), o_extended'length);
end beh;
