library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.array_package.all;

-- I/O Definition
-- i_val: Array of 16-bit inputs to the MUX
-- i_sel: Vector of select inputs to the MUX
-- o_val: 16-bit output value
entity mux is
    generic(
            g_num_inputs : natural := 2;
            g_num_select : natural := 1
           );
    port(
            i_val : in  t_word_array(g_num_inputs - 1 downto 0);
            i_sel : in  std_logic_vector(g_num_select - 1 downto 0);
            o_val : out std_logic_vector(15 downto 0)
        );
end mux;

architecture beh of mux is
begin
    o_val <= i_val(to_integer(unsigned(i_sel)));
end beh;
