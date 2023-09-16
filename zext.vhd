library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_clk: 1-bit clock input
-- i_val: 8-bit input value
-- o_val: 16-bit zero extended value
entity zext is
    port(
            i_clk : in  std_logic;
            i_val : in  std_logic_vector( 7 downto 0);
            o_val : out std_logic_vector(15 downto 0)
        );
end zext;

architecture beh of zext is
    signal r_mem : std_logic_vector(15 downto 0) := (others => '0');
begin
    p_zext : process(i_clk) is
    begin
        if rising_edge(i_clk) then
            for ii in 0 to i_val'length - 1 loop
                r_mem(ii) <= i_val(ii);
            end loop;
            o_val <= r_mem;
        end if;
    end process p_zext;
end beh;
