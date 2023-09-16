library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_clk: 1-bit clock input
-- i_val: n-bit input value (5, 6, 9, 11)
-- o_val: 16-bit sign extended output value
entity sext is
    generic(
            g_input_len : natural
           );
    port(
            i_clk : in  std_logic;
            i_val : in  std_logic_vector(g_input_len - 1 downto 0);
            o_val : out std_logic_vector(15 downto 0)
        );
end sext;

architecture beh of sext is
    signal r_mem : std_logic_vector(15 downto 0) := (others => '1');
begin
    p_sext : process(i_clk) is
    begin
        if rising_edge(i_clk) then
            -- First, copy i_val bits to r_mem
            for ii in 0 to g_input_len - 1 loop
                r_mem(ii) <= i_val(ii);
            end loop;

            -- Next, sign extend by checking if i_val is positive or negative
            if i_val(g_input_len - 1) = '1' then
                for ii in 15 downto g_input_len loop
                    r_mem(ii) <= '1';
                end loop;
            else
                for ii in 15 downto g_input_len loop
                    r_mem(ii) <= '0';
                end loop;
            end if;

            o_val <= r_mem;
        end if;
    end process p_sext;
end beh;
