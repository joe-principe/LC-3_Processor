library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition
-- i_en:  1-bit enable input signal for the tri-state buffer
-- i_clk: 1-bit clock input signal
-- i_val: 16-bit input to the buffer
-- o_val: 16-bit output from the buffer to the bus
entity tsb is
    port(
            i_en  : in  std_logic;
            i_clk : in  std_logic;
            i_val : in  std_logic_vector(15 downto 0);
            o_val : out std_logic_vector(15 downto 0)
        );
end tsb;

architecture beh of tsb is
begin
    p_tsb : process (i_clk) is
    begin
        if rising_edge(i_clk) then
            case (i_en) is
                when '0' => o_val <= (others => 'Z');
                when '1' => o_val <= i_val;
            end case;
        end if;
    end process p_tsb;
end beh;
