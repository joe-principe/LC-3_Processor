library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- I/O Definitions
-- i_clk:    1-bit clock input
-- i_ld_reg: 1-bit load from bus into register (write enable) input
-- i_dr:     3-bit destination register input
-- i_sr1:    3-bit source register 1 selection input
-- i_sr2:    3-bit source register 2 selection input
-- i_bus:    16-bit bus value input
-- o_sr1out: 16-bit source register 1 value output
-- o_sr2out: 16-bit source register 2 value output
entity regfile is
    port(
            i_clk    : in  std_logic;
            i_ld_reg : in  std_logic;
            i_dr     : in  std_logic_vector( 2 downto 0);
            i_sr1    : in  std_logic_vector( 2 downto 0);
            i_sr2    : in  std_logic_vector( 2 downto 0);
            i_bus    : in  std_logic_vector(15 downto 0);
            o_sr1out : out std_logic_vector(15 downto 0);
            o_sr2out : out std_logic_vector(15 downto 0)
        );
end regfile;

architecture beh of regfile is
    type t_register is array (0 to 7) of std_logic_vector(15 downto 0);
    signal r_mem : t_mem := (others => (others => '0'));
begin
    p_rf : process(i_clk) is
    begin
        if rising_edge(i_clk) then
            if i_ld_reg = '0' then
                -- Reads SR1 and SR2 from the register file
                o_sr1out <= r_mem(to_integer(unsigned(i_sr1)));
                o_sr2out <= r_mem(to_integer(unsigned(i_sr2)));
            elsif i_ld_reg = '1' then
                -- Writes the bus value into DR
                r_mem(to_integer(unsigned(i_dr))) <= i_bus;
            end if;
        end if;
    end process p_rf;
end beh;
