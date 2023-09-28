library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    port(
            i_clk : in std_logic
        );
end main;

-- Signal definitions:
-- w_bus_line   : 16-bit bus line for the CPU
-- w_trapvect8  : 16-bit zero extended trapvect 8 wire
-- w_imm5       : 16-bit sign extended immediate value wire
-- w_PCoffset9  : 16-bit sign extended PC[8:0] offset value wire
-- w_PCoffset11 : 16-bit sign extended PC[10:0] offset value wire
-- w_offset6    : 16-bit sign extended [5:0] offset value wire
-- w_ir_out     : 16-bit instruction register output wire
architecture beh of main is
    signal w_bus_line   : std_logic_vector(15 downto 0);
    signal w_trapvect8  : std_logic_vector(15 downto 0);
    signal w_imm5       : std_logic_vector(15 downto 0);
    signal w_PCoffset9  : std_logic_vector(15 downto 0);
    signal w_PCoffset11 : std_logic_vector(15 downto 0);
    signal w_offset6    : std_logic_vector(15 downto 0);
    signal w_ir_out     : std_logic_vector(15 downto 0);

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
    end acl;

    component adder
        port(
                i_add1 : in  std_logic_vector(15 downto 0);
                i_add2 : in  std_logic_vector(15 downto 0);
                o_add  : out std_logic_vector(15 downto 0)
            );
    end adder;

    component alu
        port( 
                i_aluk : in  std_logic_vector( 1 downto 0);
                i_a    : in  std_logic_vector(15 downto 0);
                i_b    : in  std_logic_vector(15 downto 0);
                o_res  : out std_logic_vector(15 downto 0)
            );
    end alu;

    component logic
        port(
                i_val : in  std_logic_vector(15 downto 0);
                o_n   : out std_logic;
                o_z   : out std_logic;
                o_p   : out std_logic
            );
    end logic;

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
    end memory;

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
    end mux;

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
    end nzp;

    component plus_one
        port(
                i_old_add : in  std_logic_vector(15 downto 0);
                o_new_add : out std_logic_vector(15 downto 0)
            );
    end plus_one;

    component reg
        port(
                i_clk : in  std_Logic;
                i_ld  : in  std_logic;
                i_val : in  std_logic_vector(15 downto 0);
                o_val : out std_logic_vector(15 downto 0)
            );
    end reg;

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
    end regfile;

    component sext
        generic(
                g_input_len : natural
               );
        port(
                i_extend : in  std_logic_vector(g_input_len - 1 downto 0);
                o_extended : out std_logic_vector(15 downto 0)
            );
    end sext;

    component tsb
        port(
                i_en  : in  std_logic;
                i_clk : in  std_logic;
                i_val : in  std_logic_vector(15 downto 0);
                o_val : out std_logic_vector(15 downto 0)
            );
    end tsb;

    component zext
        port(
                i_val : in  std_logic_vector( 7 downto 0);
                o_val : out std_logic_vector(15 downto 0)
            );
    end zext;
begin
    marmux : mux
        generic map (
            g_num_inputs => 2,
            g_num_select => 1
                    )
        port map (
            i_val(0) => w_imm5,
            i_val(1) => w_adder_out, -- TODO: adder output
            i_sel => w_marmux_sel, -- TODO: marmux select
            o_val => w_marmux_out, -- TODO: marmux output
    );

    gatemarmux : tsb
        port map (
            i_en  => w_gate_marmux_en, -- TODO: marmux gate enable
            i_clk => w_clock_signal, -- TODO: clock signal
            i_val => w_marmux_out, -- TODO: marmux output
            o_val => w_bus_line
    );

    PC : reg
        port map (
            i_clk => w_clock_signal, -- TODO: clock signal
            i_ld  => w_ld_pc, -- TODO: pc enable
            i_val => w_pcmux_out, -- TODO: pcmux output
            o_val => w_pc_out -- TODO: pc output
    );

    gatepc : tsb
        port map (
            i_en  => w_gate_pc_en, -- TODO: pc gate enable
            i_clk => w_clock_signal, -- TODO: clock signal
            i_val => w_pcmux_out, -- TODO: pcmux output
            o_val => w_bus_line
     );

     p_one : plus_one
        port map (
            i_old_add => w_pc_out, -- TODO: pc output
            o_new_add => w_p_one_out, -- TODO: +1 output
     );

     pcmux : mux
        generic map (
            g_num_inputs => 3,
            g_num_select => 2
        )
        port map (
            i_val(0) => w_pc_out, -- TODO: pc output
            i_val(1) => w_adder_out, -- TODO: adder output
            i_val(2) => w_bus_line,
            i_sel    => w_pcmux_sel, -- TODO: pcmux select
            o_val    => w_pcmux_out, -- TODO: pcmux output
     );

     reg_file : regfile
        port map (
            i_clk    => w_clock_signal, -- TODO: clock signal
            i_ld_reg => w_ld_reg, -- TODO: regfile load signal
            i_dr     => w_dr, -- TODO: destination register signal
            i_sr1    => w_sr1, -- TODO: source register 1 select
            i_sr2    => w_sr2, -- TODO: source register 2 select
            i_bus    => w_bus_line,
            o_sr1out => w_sr1_out, -- TODO: source register 1 value
            o_sr2out => w_sr2_out -- TODO: source register 2 value
     );

     zero_ext : zext
        port map (
            i_val => w_ir_out(7 downto 0),
            o_val => w_imm5
     );

     add1 : adder
        port map (
            i_add1 => w_addr2mux_out, -- TODO: addr2mux output
            i_add2 => w_addr1mux_out, -- TODO: addr1mux output
            o_add  => w_adder_out -- TODO: adder output
     );

     addr2mux : mux
        generic map (
            g_num_inputs => 4,
            g_num_select => 2
                    )
        port map (
            i_val(0) => w_zeros, -- TODO: all zero signal
            i_val(1) => w_offset6,
            i_val(2) => w_PCoffset9,
            i_val(3) => w_PCoffset11,
            i_sel    => w_addr2mux_sel, -- TODO: addr2mux select
            o_val    => w_addr2mux_out, -- TODO: addr2mux output
     );

     addr1mux : mux
        generic map (
            g_num_inputs => 2
            g_num_select => 1
                    )
        port map (
            i_val(0) => w_pcmux_out, -- TODO: pc output
            i_val(1) => w_sr1_out -- TODO: source register 1 value
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
            i_val(0) => w_sr2_out, -- TODO: source register 2 value
            i_val(1) => w_imm5,
            i_sel    => w_ir_out(5),
            o_val    => w_sr2mux_out, -- TODO: sr2mux output
     );

     alu1 : alu
        port map (
            i_aluk => w_aluk, -- TODO: alu operation select
            i_a    => w_sr1_out, -- TODO: source register 1 value
            i_b    => w_sr2mux_out, -- TODO: sr2mux output
            o_res  => w_alu_out, -- TODO: alu output
     );

     ir : reg
        port map (
            i_clk => w_clock_signal, -- TODO: clock signal
            i_ld  => w_ld_ir, -- TODO: ir load enable signal
            i_val => w_bus_line,
            o_val => w_ir_out
     );

     nzp1 : nzp
        port map (
            i_clk  => w_clock_signal, -- TODO: clock signal
            i_ldcc => w_ld_cc, -- TODO: nzp load enable signal
            i_n    => w_logic_n, -- TODO: logic n output
            i_z    => w_logic_z, -- TODO: logic z output
            i_p    => w_logic_p, -- TODO: logic p output
            o_n    => w_n_out, -- TODO: n output
            o_z    => w_z_out, -- TODO: z output
            o_p    => w_p_out -- TODO: p output
     );

     logic1 : logic
        port map (
            i_val => w_bus_line,
            o_n   => w_logic_n, -- TODO: logic n output
            o_z   => w_logic_z, -- TODO: logic z output
            o_p   => w_logic_p -- TODO: logic p output
     );

     gatealu : tsb
        port map (
            i_en  => w_gate_alu_en, -- TODO: alu gate enable
            i_clk => w_clock_signal, -- TODO: clock signal
            i_val => w_alu_out, -- TODO: alu output
            o_val => w_bus_line
     );

     gatemdr : tsb
        port map (
            i_en  => w_gate_mdr_en, -- TODO: mdr gate enable
            i_clk => w_clock_signal, -- TODO: clock signal
            i_val => w_mdr_out, -- TODO: mdr output
            o_val => w_bus_line
     );

     mdr : reg
        port map (
            i_clk => w_clock_signal, -- TODO: clock signal
            i_ld  => w_ld_mdr, -- TODO: mdr load enable signal
            i_val => w_mdrmux_out, -- TODO: mdrmux output
            o_val => w_mdr_out -- TODO: mdr output
     );

     mar : reg
        port map (
            i_clk => w_clock_signal, -- TODO: clock signal
            i_ld  => w_ld_mar, -- TODO: mar load enable signal
            i_val => w_bus_line,
            o_val => w_mar_out -- TODO: mar output
     );

     mdrmux : mux
        generic map (
            g_num_inputs => 2,
            g_num_select => 1
                    )
        port map (
            i_val(0) => w_inmux_out, -- TODO: inmux output
            i_val(1) => w_bus_line,
            i_sel    => w_mio_en, -- TODO: mdrmux select
            o_val    => w_mdrmux_out -- TODO: mdrmux output
     );

     mem : memory
        port map (
            i_clk => w_clock_signal, -- TODO: clock signal
            i_rw  => w_rw, -- TODO: memory read/write signal
            i_mio_en => w_mio_en, -- TODO: mem/IO en signal
            i_mar    => w_mar_out, -- TODO: mar output
            i_mdr    => w_mdr_out, -- TODO: mdr output
            o_r      => w_r, -- TODO: end of memory op signal
            o_val    => w_mem_out -- TODO: memory value output
     );

end beh;
