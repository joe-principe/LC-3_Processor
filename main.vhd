library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    port(
            i_clk : in std_logic
        );
end main;

architecture beh of main is
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

    component plus1
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
end beh;
