library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definition:
-- i_clk       : 1-bit clock input
-- i_rw        : 1-bit load/store input signal
-- i_mio_en    : 1-bit memory or i/o operation input signal
-- i_mem_add   : 16-bit memory location input
-- o_mem_en    : 1-bit memory enable output
-- o_ld_kbsr   : 1-bit keyboard status register load input signal
-- o_ld_dsr    : 1-bit display status register load input signal
-- o_ld_ddr    : 1-bit display data resister load input signal
-- o_inmux_sel : 2-bit multiplexer select output

-- NOTE: I chose 00 for mem->INMUX, 01 for DSR->INMUX, 10 for KBDR->INMUX, and
-- 11 for KBSR->INMUX.
-- TODO: Verify that the above are the actual input selections of INMUX
entity acl is
    port(
            i_clk       : in  std_logic;
            i_rw        : in  std_logic;
            i_mio_en    : in  std_logic;
            i_mem_add   : in  std_logic_vector(15 downto 0);
            o_mem_en    : out std_logic;
            o_ld_kbsr   : out std_logic;
            o_ld_dsr    : out std_logic;
            o_ld_ddr    : out std_logic;
            o_inmux_sel : out std_logic_vector( 1 downto 0)
        );
end acl;

-- NOTE: xFE00 - KBSR, xFE02 - KBDR, xFE04 - DSR, xFE06 - DDR
architecture beh of acl is
begin
    p_acl : process(i_clk) is
    begin
        if rising_edge(i_clk) AND i_mio_en = '1' then
            -- Load into MDR if 0, store from MDR if 1
            if i_rw = '0' then
                case (i_mem_add) is
                    when x"FE00" => 
                        o_mem_en    <= '0';
                        o_inmux_sel <= "11";
                    when x"FE02" =>
                        o_mem_en    <= '0';
                        o_inmux_sel <= "10";
                    when x"FE04" =>
                        o_mem_en    <= '0';
                        o_inmux_sel <= "01";
                    when x"FE06" =>
                        o_mem_en <= '0';
                    when others =>
                        o_mem_en    <= '1';
                        o_inmux_sel <= "00";
                end case;
                o_ld_kbsr <= '0';
                o_ld_dsr <= '0';
                o_ld_ddr <= '0';
            elsif i_rw = '1' then
                case (i_mem_add) is
                    when x"FE00" =>
                        o_mem_en  <= '0';
                        o_ld_kbsr <= '1';
                        o_ld_dsr  <= '0';
                        o_ld_ddr  <= '0';
                    when x"FE02" =>
                        o_mem_en <= '0';
                    when x"FE04" =>
                        o_mem_en  <= '0';
                        o_ld_kbsr <= '0';
                        o_ld_dsr  <= '1';
                        o_ld_ddr  <= '0';
                    when x"FE06" =>
                        o_mem_en  <= '0';
                        o_ld_kbsr <= '0';
                        o_ld_dsr  <= '0';
                        o_ld_ddr  <= '1';
                    when others =>
                        o_mem_en  <= '1';
                        o_ld_kbsr <= '0';
                        o_ld_dsr  <= '0';
                        o_ld_ddr  <= '0';
                end case;
            end if;
        end if;
    end process p_acl;
end beh;
