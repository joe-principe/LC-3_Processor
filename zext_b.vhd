library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_val: 8-bit input value
-- o_val: 16-bit zero extended value
entity zext is
    port(
            i_val : in  std_logic_vector( 7 downto 0);
            o_val : out std_logic_vector(15 downto 0)
        );
end zext;

architecture beh of zext is
begin
    o_val <= resize(unsigned(i_val), o_val'length);
end beh;
