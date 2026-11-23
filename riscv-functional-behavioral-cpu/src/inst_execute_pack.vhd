-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

library work;
    use work.defs_pack.all;
    use work.constants_pack.all;
library ieee;
    use ieee.numeric_bit.all;
----------------------------------------------------------------------------------

-- Implementation: ---------------------------------------------------------------

package inst_execute_pack is

    -- Loads (I-Type) ---------------------------------------------------------

    procedure exec_lb (
        rd     : in    reg_type;
        rs1    : in    reg_type;
        imm    : in    integer;
        reg    : inout reg_file_type;
        memory : in    mem_type
    );

    procedure exec_lh (
        rd     : in    reg_type;
        rs1    : in    reg_type;
        imm    : in    integer;
        reg    : inout reg_file_type;
        memory : in    mem_type
    );

    procedure exec_lw (
        rd     : in    reg_type;
        rs1    : in    reg_type;
        imm    : in    integer;
        reg    : inout reg_file_type;
        memory : in    mem_type
    );

    procedure exec_lbu (
        rd     : in    reg_type;
        rs1    : in    reg_type;
        imm    : in    integer;
        reg    : inout reg_file_type;
        memory : in    mem_type
    );

    procedure exec_lhu (
        rd     : in    reg_type;
        rs1    : in    reg_type;
        imm    : in    integer;
        reg    : inout reg_file_type;
        memory : in    mem_type
    );

    -- Stores (S-Type) --------------------------------------------------------

    procedure exec_sb (
        rs1    : in    reg_type;
        rs2    : in    reg_type;
        imm    : in    integer;
        reg    : in    reg_file_type;
        memory : inout mem_type
    );

    procedure exec_sh (
        rs1    : in    reg_type;
        rs2    : in    reg_type;
        imm    : in    integer;
        reg    : in    reg_file_type;
        memory : inout mem_type
    );

    procedure exec_sw (
        rs1    : in    reg_type;
        rs2    : in    reg_type;
        imm    : in    integer;
        reg    : in    reg_file_type;
        memory : inout mem_type
    );

    -- Register-register operations (R-Type) ----------------------------------

    procedure exec_add (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    procedure exec_sub (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    procedure exec_sll (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    procedure exec_srl (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    procedure exec_sra (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    procedure exec_slt (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    procedure exec_sltu (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    procedure exec_xor (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    procedure exec_or (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    procedure exec_and (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        rs2 : in    reg_type;
        reg : inout reg_file_type
    );

    -- Register-immediate operations (I-Type) ---------------------------------

    procedure exec_addi (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        imm : in    integer;
        reg : inout reg_file_type
    );

    procedure exec_slti (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        imm : in    integer;
        reg : inout reg_file_type
    );

    procedure exec_sltiu (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        imm : in    integer;
        reg : inout reg_file_type
    );

    procedure exec_xori (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        imm : in    integer;
        reg : inout reg_file_type
    );

    procedure exec_ori (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        imm : in    integer;
        reg : inout reg_file_type
    );

    procedure exec_andi (
        rd  : in    reg_type;
        rs1 : in    reg_type;
        imm : in    integer;
        reg : inout reg_file_type
    );

    -- Shifts with immediate shift amount (I-Type, shamt is 5 bit) -----------

    procedure exec_slli (
        rd    : in    reg_type;
        rs1   : in    reg_type;
        shamt : in    reg_type;
        reg   : inout reg_file_type
    );

    procedure exec_srli (
        rd    : in    reg_type;
        rs1   : in    reg_type;
        shamt : in    reg_type;
        reg   : inout reg_file_type
    );

    procedure exec_srai (
        rd    : in    reg_type;
        rs1   : in    reg_type;
        shamt : in    reg_type;
        reg   : inout reg_file_type
    );

    -- Upper immediates (U-Type), imm is already shifted (imm & x"000") -----

    procedure exec_lui (
        rd  : in    reg_type;
        imm : in    data_type;
        reg : inout reg_file_type
    );

    procedure exec_auipc (
        rd       : in    reg_type;
        imm      : in    data_type;
        reg      : inout reg_file_type;
        instr_pc : in    natural
    );

    -- Branches (B-Type), imm is the signed byte offset ----------------------

    procedure exec_beq (
        rs1      : in    reg_type;
        rs2      : in    reg_type;
        imm      : in    integer;
        reg      : in    reg_file_type;
        instr_pc : in    natural;
        pc       : inout natural
    );

    procedure exec_bne (
        rs1      : in    reg_type;
        rs2      : in    reg_type;
        imm      : in    integer;
        reg      : in    reg_file_type;
        instr_pc : in    natural;
        pc       : inout natural
    );

    procedure exec_blt (
        rs1      : in    reg_type;
        rs2      : in    reg_type;
        imm      : in    integer;
        reg      : in    reg_file_type;
        instr_pc : in    natural;
        pc       : inout natural
    );

    procedure exec_bge (
        rs1      : in    reg_type;
        rs2      : in    reg_type;
        imm      : in    integer;
        reg      : in    reg_file_type;
        instr_pc : in    natural;
        pc       : inout natural
    );

    procedure exec_bltu (
        rs1      : in    reg_type;
        rs2      : in    reg_type;
        imm      : in    integer;
        reg      : in    reg_file_type;
        instr_pc : in    natural;
        pc       : inout natural
    );

    procedure exec_bgeu (
        rs1      : in    reg_type;
        rs2      : in    reg_type;
        imm      : in    integer;
        reg      : in    reg_file_type;
        instr_pc : in    natural;
        pc       : inout natural
    );

    -- Jumps -------------------------------------------------------------------

    procedure exec_jal (
        rd       : in    reg_type;
        imm      : in    integer;
        instr_pc : in    natural;
        pc       : inout natural;
        reg      : inout reg_file_type
    );

    procedure exec_jalr (
        rd       : in    reg_type;
        rs1      : in    reg_type;
        imm      : in    integer;
        instr_pc : in    natural;
        pc       : inout natural;
        reg      : inout reg_file_type
    );

    -- System -------------------------------------------------------------------

    procedure exec_ebreak (
        execute : inout boolean
    );

end package inst_execute_pack;

package body inst_execute_pack is

    -- Loads (I-Type) ---------------------------------------------------------

    procedure exec_lb (
        rd     : in reg_type;
        rs1    : in reg_type;
        imm    : in integer;
        reg    : inout reg_file_type;
        memory : in mem_type
    ) is
    begin

        null; -- TODO: implement LB

    end procedure exec_lb;

    procedure exec_lh (
        rd     : in reg_type;
        rs1    : in reg_type;
        imm    : in integer;
        reg    : inout reg_file_type;
        memory : in mem_type
    ) is
    begin

        null; -- TODO: implement LH

    end procedure exec_lh;

    procedure exec_lw (
        rd     : in reg_type;
        rs1    : in reg_type;
        imm    : in integer;
        reg    : inout reg_file_type;
        memory : in mem_type
    ) is
    begin

        null; -- TODO: implement LW

    end procedure exec_lw;

    procedure exec_lbu (
        rd     : in reg_type;
        rs1    : in reg_type;
        imm    : in integer;
        reg    : inout reg_file_type;
        memory : in mem_type
    ) is
    begin

        null; -- TODO: implement LBU

    end procedure exec_lbu;

    procedure exec_lhu (
        rd     : in reg_type;
        rs1    : in reg_type;
        imm    : in integer;
        reg    : inout reg_file_type;
        memory : in mem_type
    ) is
    begin

        null; -- TODO: implement LHU

    end procedure exec_lhu;

    -- Stores (S-Type) --------------------------------------------------------

    procedure exec_sb (
        rs1    : in reg_type;
        rs2    : in reg_type;
        imm    : in integer;
        reg    : in reg_file_type;
        memory : inout mem_type
    ) is
    begin

        null; -- TODO: implement SB

    end procedure exec_sb;

    procedure exec_sh (
        rs1    : in reg_type;
        rs2    : in reg_type;
        imm    : in integer;
        reg    : in reg_file_type;
        memory : inout mem_type
    ) is
    begin

        null; -- TODO: implement SH

    end procedure exec_sh;

    procedure exec_sw (
        rs1    : in reg_type;
        rs2    : in reg_type;
        imm    : in integer;
        reg    : in reg_file_type;
        memory : inout mem_type
    ) is
    begin

        null; -- TODO: implement SW

    end procedure exec_sw;

    -- Register-register operations (R-Type) ----------------------------------

    procedure exec_add (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement ADD

    end procedure exec_add;

    procedure exec_sub (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SUB

    end procedure exec_sub;

    procedure exec_sll (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SLL

    end procedure exec_sll;

    procedure exec_srl (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SRL

    end procedure exec_srl;

    procedure exec_sra (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SRA

    end procedure exec_sra;

    procedure exec_slt (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SLT

    end procedure exec_slt;

    procedure exec_sltu (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SLTU

    end procedure exec_sltu;

    procedure exec_xor (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement XOR

    end procedure exec_xor;

    procedure exec_or (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement OR

    end procedure exec_or;

    procedure exec_and (
        rd  : in reg_type;
        rs1 : in reg_type;
        rs2 : in reg_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement AND

    end procedure exec_and;

    -- Register-immediate operations (I-Type) ---------------------------------

    procedure exec_addi (
        rd  : in reg_type;
        rs1 : in reg_type;
        imm : in integer;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement ADDI

    end procedure exec_addi;

    procedure exec_slti (
        rd  : in reg_type;
        rs1 : in reg_type;
        imm : in integer;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SLTI

    end procedure exec_slti;

    procedure exec_sltiu (
        rd  : in reg_type;
        rs1 : in reg_type;
        imm : in integer;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SLTIU

    end procedure exec_sltiu;

    procedure exec_xori (
        rd  : in reg_type;
        rs1 : in reg_type;
        imm : in integer;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement XORI

    end procedure exec_xori;

    procedure exec_ori (
        rd  : in reg_type;
        rs1 : in reg_type;
        imm : in integer;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement ORI

    end procedure exec_ori;

    procedure exec_andi (
        rd  : in reg_type;
        rs1 : in reg_type;
        imm : in integer;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement ANDI

    end procedure exec_andi;

    -- Shifts with immediate shift amount -------------------------------------

    procedure exec_slli (
        rd    : in reg_type;
        rs1   : in reg_type;
        shamt : in reg_type;
        reg   : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SLLI

    end procedure exec_slli;

    procedure exec_srli (
        rd    : in reg_type;
        rs1   : in reg_type;
        shamt : in reg_type;
        reg   : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SRLI

    end procedure exec_srli;

    procedure exec_srai (
        rd    : in reg_type;
        rs1   : in reg_type;
        shamt : in reg_type;
        reg   : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement SRAI

    end procedure exec_srai;

    -- Upper immediates (U-Type) ----------------------------------------------

    procedure exec_lui (
        rd  : in reg_type;
        imm : in data_type;
        reg : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement LUI

    end procedure exec_lui;

    procedure exec_auipc (
        rd       : in reg_type;
        imm      : in data_type;
        reg      : inout reg_file_type;
        instr_pc : in natural
    ) is
    begin

        null; -- TODO: implement AUIPC

    end procedure exec_auipc;

    -- Branches (B-Type) ------------------------------------------------------

    procedure exec_beq (
        rs1      : in reg_type;
        rs2      : in reg_type;
        imm      : in integer;
        reg      : in reg_file_type;
        instr_pc : in natural;
        pc       : inout natural
    ) is
    begin

        null; -- TODO: implement BEQ

    end procedure exec_beq;

    procedure exec_bne (
        rs1      : in reg_type;
        rs2      : in reg_type;
        imm      : in integer;
        reg      : in reg_file_type;
        instr_pc : in natural;
        pc       : inout natural
    ) is
    begin

        null; -- TODO: implement BNE

    end procedure exec_bne;

    procedure exec_blt (
        rs1      : in reg_type;
        rs2      : in reg_type;
        imm      : in integer;
        reg      : in reg_file_type;
        instr_pc : in natural;
        pc       : inout natural
    ) is
    begin

        null; -- TODO: implement BLT

    end procedure exec_blt;

    procedure exec_bge (
        rs1      : in reg_type;
        rs2      : in reg_type;
        imm      : in integer;
        reg      : in reg_file_type;
        instr_pc : in natural;
        pc       : inout natural
    ) is
    begin

        null; -- TODO: implement BGE

    end procedure exec_bge;

    procedure exec_bltu (
        rs1      : in reg_type;
        rs2      : in reg_type;
        imm      : in integer;
        reg      : in reg_file_type;
        instr_pc : in natural;
        pc       : inout natural
    ) is
    begin

        null; -- TODO: implement BLTU

    end procedure exec_bltu;

    procedure exec_bgeu (
        rs1      : in reg_type;
        rs2      : in reg_type;
        imm      : in integer;
        reg      : in reg_file_type;
        instr_pc : in natural;
        pc       : inout natural
    ) is
    begin

        null; -- TODO: implement BGEU

    end procedure exec_bgeu;

    -- Jumps -------------------------------------------------------------------

    procedure exec_jal (
        rd       : in reg_type;
        imm      : in integer;
        instr_pc : in natural;
        pc       : inout natural;
        reg      : inout reg_file_type
    ) is
    begin
        reg(to_integer(unsigned(rd))) := bit_vector(to_signed(pc,RegDataSize));
        pc := instr_pc + (imm * instr_bytes);

    end procedure exec_jal;

    procedure exec_jalr (
        rd       : in reg_type;
        rs1      : in reg_type;
        imm      : in integer;
        instr_pc : in natural;
        pc       : inout natural;
        reg      : inout reg_file_type
    ) is
    begin

        null; -- TODO: implement JALR

    end procedure exec_jalr;

    -- System -------------------------------------------------------------------

    procedure exec_ebreak (
        execute : inout boolean
    ) is
    begin

        execute := false; -- TODO: implement EBREAK

    end procedure exec_ebreak;

end package body inst_execute_pack;
