library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_clk: 1-bit clock input
-- i_ld:  1-bit write enable input
-- i_val: 16-bit input value
-- o_val: 16-bit output value
entity reg is
    port(
            i_clk : in  std_Logic;
            i_ld  : in  std_logic;
            i_val : in  std_logic_vector(15 downto 0);
            o_val : out std_logic_vector(15 downto 0)
        );
end reg;

-- I think this is correct. The register processes whether it should write a new
-- value in on each rising edge, but it's always outputing because there's no
-- read enable line.

-- Though, this might have an issue with setting o_val because of concurrency or
-- something, but idk. That's future Joe's problem.
architecture beh of reg is
    signal r_mem : std_logic_vector(15 downto 0) := (others => '0');
begin
    p_reg : process (i_clk) is
    begin
        if rising_edge(i_clk) then
            if i_ld = '1' then
                r_mem <= i_val;
            end if;
        end if;
    end process p_reg;

    o_val <= r_mem;
end beh;
