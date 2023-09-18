library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_old_add: 16-bit program counter address input
-- o_new_add: 16-bit next instruction address output
entity plus_one is
    port(
            i_old_add : in  std_logic_vector(15 downto 0);
            o_new_add : out std_logic_vector(15 downto 0)
        );
end plus_one;

architecture beh of plus_one is
begin
    o_new_add <= std_logic_vector(signed(i_old_add) + 1);
end beh;
