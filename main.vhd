library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    port(
            i_clk : in std_logic
        );
end main;

architecture beh of main is
    -- r_clock : 1-bit clock signal
    signal r_clock : std_logic;

    -- w_bus_line : 16-bit bus line for the CPU
    signal w_bus_line : std_logic_vector(15 downto 0);

    -- w_gate_marmux_en : 1-bit GateMARMUX enable signal
    -- w_marmux_sel     : 1-bit MARMUX input selection signal
    -- w_marmux_out     : 16-bit MARMUX output signal
    signal w_gate_marmux_en : std_logic;
    signal w_marmux_sel     : std_logic;
    signal w_marmux_out     : std_logic_vector(15 downto 0);

    -- w_gate_pc_en : 1-bit GatePC enable signal
    -- w_ld_pc      : 1-bit PC load signal
    -- w_pc_out     : 16-bit PC output signal
    -- w_pcmux_sel  : 2-bit PCMUX selection signal
    -- w_pcmux_out  : 16-bit PCMUX output signal
    -- w_p_one_out  : 16-bit PC+1 output signal
    signal w_gate_pc_en : std_logic;
    signal w_ld_pc      : std_logic;
    signal w_pc_out     : std_logic_vector(15 downto 0);
    signal w_pcmux_sel  : std_logic_vector( 1 downto 0);
    signal w_pcmux_out  : std_logic_vector(15 downto 0);
    signal w_p_one_out  : std_logic_vector(15 downto 0);

    -- w_ld_ir      : 1-bit IR load signal
    -- w_ir_out     : 16-bit instruction register output signal
    -- w_trapvect8  : 16-bit zero extended trapvect8 signal
    -- w_PCoffset9  : 16-bit sign extended IR[8:0] PC offset value signal
    -- w_PCoffset11 : 16-bit sign extended IR[10:0] PC offset value signal
    -- w_offset6    : 16-bit sign extended IR[5:0] offset value signal
    signal w_ld_ir      : std_logic;
    signal w_ir_out     : std_logic_vector(15 downto 0);
    signal w_trapvect8  : std_logic_vector(15 downto 0);
    signal w_PCoffset9  : std_logic_vector(15 downto 0);
    signal w_PCoffset11 : std_logic_vector(15 downto 0);
    signal w_offset6    : std_logic_vector(15 downto 0);

    -- w_adder_out    : 16-bit adder output signal
    -- w_addr1mux_sel : 1-bit ADDR1MUX selection signal
    -- w_addr1mux_out : 16-bit ADDR1MUX output signal
    -- w_addr2mux_sel : 2-bit ADDR2MUX selection signal
    -- w_addr2mux_out : 16-bit ADDR2MUX output signal
    signal w_adder_out    : std_logic_vector(15 downto 0);
    signal w_addr1mux_sel : std_logic;
    signal w_addr1mux_out : std_logic_vector(15 downto 0);
    signal w_addr2mux_sel : std_logic_vector( 1 downto 0);
    signal w_addr2mux_out : std_logic_vector(15 downto 0);

    -- w_ld_reg     : 1-bit reg file load signal
    -- w_dr         : 3-bit destination register selection signal
    -- w_sr1        : 3-bit source register 1 selection signal
    -- w_sr1_out    : 16-bit source register 1 value signal
    -- w_sr2        : 3-bit source register 2 selection signal
    -- w_sr2_out    : 16-bit source register 2 value signal
    -- w_imm5       : 16-bit sign extended immediate value signal
    -- w_sr2mux_out : 16-bit SR2MUX output signal
    signal w_ld_reg     : std_logic;
    signal w_dr         : std_logic_vector( 2 downto 0);
    signal w_sr1        : std_logic_vector( 2 downto 0);
    signal w_sr1_out    : std_logic_vector(15 downto 0);
    signal w_sr2        : std_logic_vector( 2 downto 0);
    signal w_sr2_out    : std_logic_vector(15 downto 0);
    signal w_imm5       : std_logic_vector(15 downto 0);
    signal w_sr2mux_out : std_logic_vector(15 downto 0);

    -- w_aluk        : 2-bit ALU operation selection signal
    -- w_alu_out     : 16-bit ALU result signal
    -- w_gate_alu_en : 1-bit GateALU enable signal
    signal w_aluk        : std_logic_vector( 1 downto 0);
    signal w_alu_out     : std_logic_vector(15 downto 0);
    signal w_gate_alu_en : std_logic;

    -- w_logic_n : 1-bit result is negative signal
    -- w_logic_z : 1-bit result is zero signal
    -- w_logic_p : 1-bit result is positive signal
    -- w_ld_cc   : 1-bit nzp load signal
    -- w_n_out   : 1-bit negative control signal
    -- w_z_out   : 1-bit zero control signal
    -- w_p_out   : 1-bit positive control signal
    signal w_logic_n : std_logic;
    signal w_logic_z : std_logic;
    signal w_logic_p : std_logic;
    signal w_ld_cc   : std_logic;
    signal w_n_out   : std_logic;
    signal w_z_out   : std_logic;
    signal w_p_out   : std_logic;

    -- w_gate_mdr_en : 1-bit GateMDR enable signal
    -- w_ld_mdr      : 1-bit MDR load signal
    -- w_mdr_out     : 16-bit MDR output signal
    -- w_mdrmux_out  : 16-bit MDRMUX output signal
    signal w_gate_mdr_en : std_logic;
    signal w_ld_mdr      : std_logic;
    signal w_mdr_out     : std_logic_vector(15 downto 0);
    signal w_mdrmux_out  : std_logic_vector(15 downto 0);

    -- w_ld_mar  : 1-bit MAR load signal
    -- w_mar_out : 16-bit MAR output signal
    signal w_ld_mar  : std_logic;
    signal w_mar_out : std_logic_vector(15 downto 0);

    -- w_mio_en : 16-bit Mem/IO operation enable signal
    -- w_mem_en : 1-bit memory read/write enable signal
    -- w_rw     : 1-bit read/write operation selection signal
    -- w_r      : 1-bit end of memory operation control signal
    signal w_mio_en : std_logic_vector(15 downto 0);
    signal w_mem_en : std_logic;
    signal w_rw     : std_logic;
    signal w_r      : std_logic;

    -- w_inmux_sel : 2-bit INMUX selection signal
    -- w_inmux_out : 16-bit INMUX output signal
    -- w_mem_out   : 16-bit memory output signal
    signal w_inmux_sel : std_logic_vector( 1 downto 0);
    signal w_inmux_out : std_logic_vector(15 downto 0);
    signal w_mem_out   : std_logic_vector(15 downto 0);

    -- w_ld_kbsr : 1-bit kbsr load signal
    -- w_ld_dsr  : 1-bit dsr load signal
    -- w_ld_ddr  : 1-bit ddr load signal
    signal w_ld_kbsr : std_logic;
    signal w_ld_dsr  : std_logic;
    signal w_ld_ddr  : std_logic;

    type state is (loading, running, done);
    signal s : state := loading;

    component acl
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
    end component;

    component adder
        port(
                i_add1 : in  std_logic_vector(15 downto 0);
                i_add2 : in  std_logic_vector(15 downto 0);
                o_add  : out std_logic_vector(15 downto 0)
            );
    end component;

    component alu
        port( 
                i_aluk : in  std_logic_vector( 1 downto 0);
                i_a    : in  std_logic_vector(15 downto 0);
                i_b    : in  std_logic_vector(15 downto 0);
                o_res  : out std_logic_vector(15 downto 0)
            );
    end component;

    component logic
        port(
                i_val : in  std_logic_vector(15 downto 0);
                o_n   : out std_logic;
                o_z   : out std_logic;
                o_p   : out std_logic
            );
    end component;

    component memory
        port(
                i_clk    : in  std_logic;
                i_rw     : in  std_logic;
                i_mem_en : in  std_logic;
                i_mar    : in  std_logic_vector(15 downto 0);
                i_mdr    : in  std_logic_vector(15 downto 0);
                o_r      : out std_logic;
                o_val    : out std_logic_vector(15 downto 0);
            );
    end component;

    component mux
        generic(
                g_num_inputs : natural := 2;
                g_num_select : natural := 1
               );
        port(
                i_val : in  t_word_array(g_num_inputs - 1 downto 0);
                i_sel : in  std_logic_vector(g_num_select - 1 downto 0);
                o_val : out std_logic_vector(15 downto 0)
            );
    end component;

    component nzp
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
    end component;

    component plus_one
        port(
                i_old_add : in  std_logic_vector(15 downto 0);
                o_new_add : out std_logic_vector(15 downto 0)
            );
    end component;

    component reg
        port(
                i_clk : in  std_Logic;
                i_ld  : in  std_logic;
                i_val : in  std_logic_vector(15 downto 0);
                o_val : out std_logic_vector(15 downto 0)
            );
    end component;

    component regfile
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
    end component;

    component sext
        generic(
                g_input_len : natural
               );
        port(
                i_extend : in  std_logic_vector(g_input_len - 1 downto 0);
                o_extended : out std_logic_vector(15 downto 0)
            );
    end component;

    component tsb
        port(
                i_en  : in  std_logic;
                i_clk : in  std_logic;
                i_val : in  std_logic_vector(15 downto 0);
                o_val : out std_logic_vector(15 downto 0)
            );
    end component;

    component zext
        port(
                i_val : in  std_logic_vector( 7 downto 0);
                o_val : out std_logic_vector(15 downto 0)
            );
    end component;

-- BEGIN
begin
-- BEGIN

    p_main : process(i_clk) is
    begin
        case s is
            when running => r_clock <= i_clk;
            when others => r_clock <= '0';
        end case;

        if rising_edge(i_clk) then
            case s is
                when loading => s <= running;
                when running =>
                    if instr_address > last_instr_address then
                        s <= done;
                        r_clock <= '0';
                    end if;
                when others => null;
            end case;
        end if;
    end process p_main;

    marmux : mux
        generic map (
            g_num_inputs => 2,
            g_num_select => 1
                    )
        port map (
            i_val(0) => w_adder_out,
            i_val(1) => w_trapvec8,
            i_sel    => w_marmux_sel,
            o_val    => w_marmux_out
    );

    gatemarmux : tsb
        port map (
            i_en  => w_gate_marmux_en,
            i_clk => r_clock,
            i_val => w_marmux_out,
            o_val => w_bus_line
    );

    PC : reg
        port map (
            i_clk => r_clock,
            i_ld  => w_ld_pc,
            i_val => w_pcmux_out,
            o_val => w_pc_out
    );

    gatepc : tsb
        port map (
            i_en  => w_gate_pc_en,
            i_clk => r_clock,
            i_val => w_pc_out,
            o_val => w_bus_line
     );

     p_one : plus_one
        port map (
            i_old_add => w_pc_out,
            o_new_add => w_p_one_out
     );

     pcmux : mux
        generic map (
            g_num_inputs => 3,
            g_num_select => 2
        )
        port map (
            i_val(0) => w_p_one_out,
            i_val(1) => w_adder_out,
            i_val(2) => w_bus_line,
            i_sel    => w_pcmux_sel,
            o_val    => w_pcmux_out
     );

     reg_file : regfile
        port map (
            i_clk    => r_clock,
            i_ld_reg => w_ld_reg,
            i_dr     => w_dr,
            i_sr1    => w_sr1,
            i_sr2    => w_sr2,
            i_bus    => w_bus_line,
            o_sr1out => w_sr1_out,
            o_sr2out => w_sr2_out
     );

     zero_ext : zext
        port map (
            i_val => w_ir_out(7 downto 0),
            o_val => w_trapvect8
     );

     add1 : adder
        port map (
            i_add1 => w_addr2mux_out,
            i_add2 => w_addr1mux_out,
            o_add  => w_adder_out
     );

     addr2mux : mux
        generic map (
            g_num_inputs => 4,
            g_num_select => 2
                    )
        port map (
            i_val(0) => x"0000",
            i_val(1) => w_offset6,
            i_val(2) => w_PCoffset9,
            i_val(3) => w_PCoffset11,
            i_sel    => w_addr2mux_sel,
            o_val    => w_addr2mux_out
     );

     addr1mux : mux
        generic map (
            g_num_inputs => 2
            g_num_select => 1
                    )
        port map (
            i_val(0) => w_pc_out,
            i_val(1) => w_sr1_out,
            i_sel    => w_addr1mux_sel,
            o_val    => w_addr1mux_out
     );

     sext_pcoffset11 : sext
        generic map (
            g_input_len => 11
                    )
        port map (
            i_extend   => w_ir_out(10 downto 0),
            o_extended => w_PCoffset11
     );

     sext_pcoffset9 : sext
        generic map (
            g_input_len => 9
                    )
        port map (
            i_extend   => w_ir_out(8 downto 0),
            o_extended => w_PCoffset9
     );

     sext_offset6 : sext
        generic map (
            g_input_len => 6
                    )
        port map (
            i_extend   => w_ir_out(5 downto 0),
            o_extended => w_offset6
     );

     sext_imm5 : sext
        generic map (
            g_input_len => 5
                    )
        port map (
            i_extend   => w_ir_out(4 downto 0),
            o_extended => w_imm5
     );

     sr2mux : mux
        generic map (
            g_num_inputs => 2,
            g_num_select => 1
                    )
        port map (
            i_val(0) => w_sr2_out,
            i_val(1) => w_imm5,
            i_sel    => w_ir_out(5),
            o_val    => w_sr2mux_out
     );

     alu1 : alu
        port map (
            i_aluk => w_aluk,
            i_a    => w_sr1_out,
            i_b    => w_sr2mux_out,
            o_res  => w_alu_out
     );

     ir : reg
        port map (
            i_clk => r_clock,
            i_ld  => w_ld_ir,
            i_val => w_bus_line,
            o_val => w_ir_out
     );

     nzp1 : nzp
        port map (
            i_clk  => r_clock,
            i_ldcc => w_ld_cc,
            i_n    => w_logic_n,
            i_z    => w_logic_z,
            i_p    => w_logic_p,
            o_n    => w_n_out,
            o_z    => w_z_out,
            o_p    => w_p_out
     );

     logic1 : logic
        port map (
            i_val => w_bus_line,
            o_n   => w_logic_n,
            o_z   => w_logic_z,
            o_p   => w_logic_p
     );

     gatealu : tsb
        port map (
            i_en  => w_gate_alu_en,
            i_clk => r_clock,
            i_val => w_alu_out,
            o_val => w_bus_line
     );

     gatemdr : tsb
        port map (
            i_en  => w_gate_mdr_en,
            i_clk => r_clock,
            i_val => w_mdr_out,
            o_val => w_bus_line
     );

     mdr : reg
        port map (
            i_clk => r_clock,
            i_ld  => w_ld_mdr,
            i_val => w_mdrmux_out,
            o_val => w_mdr_out
     );

     mar : reg
        port map (
            i_clk => r_clock,
            i_ld  => w_ld_mar,
            i_val => w_bus_line,
            o_val => w_mar_out
     );

     mdrmux : mux
        generic map (
            g_num_inputs => 2,
            g_num_select => 1
                    )
        port map (
            i_val(0) => w_inmux_out,
            i_val(1) => w_bus_line,
            i_sel    => w_mio_en,
            o_val    => w_mdrmux_out
     );

     mem : memory
        port map (
            i_clk    => r_clock,
            i_rw     => w_rw,
            i_mem_en => w_mem_en,
            i_mar    => w_mar_out,
            i_mdr    => w_mdr_out,
            o_r      => w_r,
            o_val    => w_mem_out
     );

     addrctl : acl
        port map (
            i_clk       => r_clock,
            i_rw        => w_rw,
            i_mio_en    => w_mio_en,
            i_mem_add   => w_mar_out,
            o_mem_en    => w_mem_en,
            o_ld_kbsr   => w_ld_kbsr,
            o_ld_dsr    => w_ld_dsr,
            o_ld_ddr    => w_ld_ddr,
            o_inmux_sel => w_inmux_sel
     );

     inmux : mux
        generic map (
            g_num_inputs => 4,
            g_num_select => 2
                    )
        port map (
            i_val(0) => w_mem_out,
            i_val(1) => w_dsr_out, -- TODO: dsr value output
            i_val(2) => w_kbsr_out, -- TODO: kbsr value output
            i_val(3) => w_kbdr_out, -- TODO: kbdr value output
            i_sel    => w_inmux_sel,
            o_val    => w_inmux_out
     );

end beh;
