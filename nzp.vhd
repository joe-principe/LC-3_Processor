library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_clk: 1-bit clock input
-- i_ldcc: 1-bit write enable (?)
-- i_n: 1-bit negative result input
-- i_z: 1-bit zero result input
-- i_p: 1-bit positive result input
-- o_n: 1-bit negative result output
-- o_z: 1-bit zero result output
-- o_p: 1-bit positive result output
entity nzp is
    port(
            i_clk  : in  std_logic;
            i_ldcc : in  std_logic;
            i_n    : in  std_logic;
            i_z    : in  std_logic;
            i_p    : in  std_logic;
            o_n    : out std_logic;
            o_z    : out std_logic;
            o_p    : out std_logic
        );
end nzp;

architecture beh of nzp is
    signal r_n : std_logic := '0';
    signal r_z : std_logic := '0';
    signal r_p : std_logic := '0';
begin
    p_nzp : process(i_clk) is
    begin
        if rising_edge(i_clk) then
            if i_ldcc = '1' then
                r_n <= i_n;
                r_z <= i_z;
                r_p <= i_p;
            end if;
        end if;
    end process p_nzp;

    o_n <= r_n;
    o_z <= r_z;
    o_p <= r_p;
end beh;
