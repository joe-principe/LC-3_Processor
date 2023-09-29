library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.array_package.all;

-- NOTE: The lc3tools program on github has some initial locations in memory
-- defined for different system operations (like PUTS). Until I learn how to
-- initialize memory with these values (ie, I copy them all over to this
-- program), I will not consider memory to be complete
--
-- Link to github repo: https://github.com/chiragsakhuja/lc3tools

-- I/O Definition
-- i_clk:    1-bit clock input
-- i_rw:     1-bit read/write choice input
-- i_mem_en: 1-bit memory enable input
-- i_mar:    16-bit memory address register input
-- i_mdr:    16-bit memory data register input
-- o_r:      1-bit end of memory operation control signal output
-- o_val:    16-bit memory output value
entity memory is
    port(
            i_clk    : in  std_logic;
            i_rw     : in  std_logic;
            i_mem_en : in  std_logic;
            i_mar    : in  std_logic_vector(15 downto 0);
            i_mdr    : in  std_logic_vector(15 downto 0);
            o_r      : out std_logic;
            o_val    : out std_logic_vector(15 downto 0)
        );
end memory;

architecture beh of memory is
    signal r_mem : t_word_array(0 to 65535) := (others => (others => '0'));
begin
    p_mem : process(i_clk) is
    begin
        if rising_edge(i_clk) AND i_mem_en = '1' then
            if i_rw = '0' then
                o_r <= '0';
                o_val <= r_mem(to_integer(unsigned(i_mar)));
            elsif i_rw = '1' then
                o_r <= '0';
                r_mem(to_integer(unsigned(i_mdr))) <= i_mdr;
            end if;
            o_r <= '1';
        end if;
    end process p_mem;
end beh;
