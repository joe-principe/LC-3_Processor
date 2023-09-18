library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port(
            i_add1 : in  std_logic_vector(15 downto 0);
            i_add2 : in  std_logic_vector(15 downto 0);
            o_add  : out std_logic_vector(15 downto 0)
        );
end adder;

architecture beh of adder is
begin
    o_add <= std_logic_vector(signed(i_add1) + signed(i_add2));
end beh;
