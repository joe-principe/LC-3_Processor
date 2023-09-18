library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_val: 16-bit input value
-- o_n:   1-bit check for negative boolean value
-- o_z:   1-bit check for zero boolean value
-- o_p:   1-bit check for positive boolean value
entity logic is
    port(
            i_val : in  std_logic_vector(15 downto 0);
            o_n   : out std_logic;
            o_z   : out std_logic;
            o_p   : out std_logic
        );
end logic;

architecture beh of logic is
begin
    o_n <= i_val(15) AND '1';
    o_z <= '1' when (i_val AND X"FFFF") = X"0000" else '0';
    o_p <= i_val(15) NAND '1';
end beh;
