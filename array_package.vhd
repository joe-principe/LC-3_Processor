library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package array_package is
    type t_word_array is array (integer range <>) of std_logic_vector(15 downto 0);
end package array_package;
