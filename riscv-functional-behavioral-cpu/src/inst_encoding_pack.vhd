----------------------------------------------------------------------------------
-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

library ieee;
    use ieee.numeric_bit.all;

library work;
    use work.defs_pack.all;
    use work.constants_pack.all;

----------------------------------------------------------------------------------

-- Implementation: ---------------------------------------------------------------

package inst_encoding_pack is

    -- R-Type: add, sub, xor, or, and, sll, srl, sra, slt, sltu -----------------------

    function instr_add (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    function instr_sub (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    function instr_xor (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    function instr_or (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    function instr_and (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    function instr_sll (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    function instr_srl (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    function instr_sra (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    function instr_slt (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    function instr_sltu (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType;

    -------------------------------------------------------------------------------------

    -- I-Type: addi, xori, ori, andi, slti, sltiu ----------------------------------------

    function instr_addi (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_xori (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_ori (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_andi (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_slti (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_sltiu (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    --------------------------------------------------------------------------------------

    -- I-Type Shift: slli, srli, srai ----------------------------------------------------

    function instr_slli (
        rd    : reg_type;
        rs1   : reg_type;
        shamt : integer
    ) return BusDataType;

    function instr_srli (
        rd    : reg_type;
        rs1   : reg_type;
        shamt : integer
    ) return BusDataType;

    function instr_srai (
        rd    : reg_type;
        rs1   : reg_type;
        shamt : integer
    ) return BusDataType;

    -------------------------------------------------------------------------------------

    -- I-Type Load: lb, lh, lw, lbu, lhu -------------------------------------------------

    function instr_lb (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_lh (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_lw (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_lbu (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_lhu (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    -------------------------------------------------------------------------------------

    -- I-Type Jump & System: jalr, ebreak ------------------------------------------------

    function instr_jalr (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_ebreak return BusDataType;

    -------------------------------------------------------------------------------------

    -- S-Type Store: sb, sh, sw ---------------------------------------------------------

    function instr_sb (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_sh (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_sw (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType;

    -------------------------------------------------------------------------------------

    -- B-Type Branch: beq, bne, blt, bge, bltu, bgeu -------------------------------------

    function instr_beq (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_bne (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_blt (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_bge (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_bltu (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_bgeu (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType;

    -------------------------------------------------------------------------------------

    -- J-Type Jump: jal ------------------------------------------------------------------

    function instr_jal (
        rd  : reg_type;
        imm : integer
    ) return BusDataType;

    -------------------------------------------------------------------------------------

    -- U-Type: lui, auipc ----------------------------------------------------------------

    function instr_lui (
        rd  : reg_type;
        imm : integer
    ) return BusDataType;

    function instr_auipc (
        rd  : reg_type;
        imm : integer
    ) return BusDataType;

-------------------------------------------------------------------------------------

end package inst_encoding_pack;

package body inst_encoding_pack is

    -- Format Functions -----------------------------------------------------------------

    -- R-Type ---------------------------------------------------------------------------

    function encode_r_type (
        funct7 : func7type;
        rs2    : reg_type;
        rs1    : reg_type;
        funct3 : func3type;
        rd     : reg_type;
        opcode : optype
    ) return BusDataType is
    begin

        return funct7 & rs2 & rs1 & funct3 & rd & opcode;

    end function encode_r_type;

    -------------------------------------------------------------------------------------

    -- I-Type ---------------------------------------------------------------------------

    function encode_i_type (
        imm    : integer;
        rs1    : reg_type;
        funct3 : func3type;
        rd     : reg_type;
        opcode : optype
    ) return BusDataType is

        variable imm_bv : busdatatype := bit_vector(to_signed(imm, 32));

    begin

        return imm_bv(11 downto 0) & rs1 & funct3 & rd & opcode;

    end function encode_i_type;

    -------------------------------------------------------------------------------------

    -- I-Type Shift ---------------------------------------------------------------------------

    function encode_shift_i_type (
        funct7 : func7type;
        shamt  : integer;
        rs1    : reg_type;
        funct3 : func3type;
        rd     : reg_type;
        opcode : optype
    ) return BusDataType is
    begin

        return funct7 & bit_vector(to_unsigned(shamt, 5)) & rs1 & funct3 & rd & opcode;

    end function encode_shift_i_type;

    -------------------------------------------------------------------------------------

    -- S-Type ---------------------------------------------------------------------------

    function encode_s_type (
        imm    : integer;
        rs2    : reg_type;
        rs1    : reg_type;
        funct3 : func3type;
        opcode : optype
    ) return BusDataType is

        variable imm_bv : busdatatype := bit_vector(to_signed(imm, 32));

    begin

        return imm_bv(11 downto 5) & rs2 & rs1 & funct3 & imm_bv(4 downto 0) & opcode;

    end function encode_s_type;

    -------------------------------------------------------------------------------------

    -- B-Type ---------------------------------------------------------------------------

    function encode_b_type (
        imm    : integer;
        rs2    : reg_type;
        rs1    : reg_type;
        funct3 : func3type;
        opcode : optype
    ) return BusDataType is

        variable imm_bv : busdatatype := bit_vector(to_signed(imm, 32));

    begin

        return imm_bv(12) & imm_bv(10 downto 5) & rs2 & rs1 & funct3 & imm_bv(4 downto 1) & imm_bv(11) & opcode;

    end function encode_b_type;

    -------------------------------------------------------------------------------------

    -- U-Type ---------------------------------------------------------------------------

    function encode_u_type (
        imm    : integer;
        rd     : reg_type;
        opcode : optype
    ) return BusDataType is

        variable imm_bv : busdatatype := bit_vector(to_signed(imm, 32));

    begin

        return imm_bv(31 downto 12) & rd & opcode;

    end function encode_u_type;

    -------------------------------------------------------------------------------------

    -- J-Type ---------------------------------------------------------------------------

    function encode_j_type (
        imm    : integer;
        rd     : reg_type;
        opcode : optype
    ) return BusDataType is

        variable imm_bv : busdatatype := bit_vector(to_signed(imm, 32));

    begin

        return imm_bv(20) & imm_bv(10 downto 1) & imm_bv(11) & imm_bv(19 downto 12) & rd & opcode;

    end function encode_j_type;

    ----------------------------------------------------------------------------------

    -- R-Type: add, sub, xor, or, and, sll, srl, sra, slt, sltu -----------------------

    function instr_add (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_base, rs2, rs1, f3_add_sub, rd, opcode_op);

    end function instr_add;

    function instr_sub (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_sub_sra, rs2, rs1, f3_add_sub, rd, opcode_op);

    end function instr_sub;

    function instr_xor (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_base, rs2, rs1, f3_xor, rd, opcode_op);

    end function instr_xor;

    function instr_or (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_base, rs2, rs1, f3_or, rd, opcode_op);

    end function instr_or;

    function instr_and (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_base, rs2, rs1, f3_and, rd, opcode_op);

    end function instr_and;

    function instr_sll (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_base, rs2, rs1, f3_sll, rd, opcode_op);

    end function instr_sll;

    function instr_srl (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_base, rs2, rs1, f3_srl_sra, rd, opcode_op);

    end function instr_srl;

    function instr_sra (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_sub_sra, rs2, rs1, f3_srl_sra, rd, opcode_op);

    end function instr_sra;

    function instr_slt (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_base, rs2, rs1, f3_slt, rd, opcode_op);

    end function instr_slt;

    function instr_sltu (
        rd  : reg_type;
        rs1 : reg_type;
        rs2 : reg_type
    ) return BusDataType is
    begin

        return encode_r_type(f7_base, rs2, rs1, f3_sltu, rd, opcode_op);

    end function instr_sltu;

    -------------------------------------------------------------------------------------

    -- I-Type: addi, xori, ori, andi, slti, sltiu ----------------------------------------

    function instr_addi (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_addi, rd, opcode_op_imm);

    end function instr_addi;

    function instr_xori (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_xori, rd, opcode_op_imm);

    end function instr_xori;

    function instr_ori (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_ori, rd, opcode_op_imm);

    end function instr_ori;

    function instr_andi (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_andi, rd, opcode_op_imm);

    end function instr_andi;

    function instr_slti (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_slti, rd, opcode_op_imm);

    end function instr_slti;

    function instr_sltiu (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_sltiu, rd, opcode_op_imm);

    end function instr_sltiu;

    --------------------------------------------------------------------------------------

    -- I-Type Shift: slli, srli, srai ----------------------------------------------------

    function instr_slli (
        rd    : reg_type;
        rs1   : reg_type;
        shamt : integer
    ) return BusDataType is
    begin

        return encode_shift_i_type(f7_base, shamt, rs1, f3_slli, rd, opcode_op_imm);

    end function instr_slli;

    function instr_srli (
        rd    : reg_type;
        rs1   : reg_type;
        shamt : integer
    ) return BusDataType is
    begin

        return encode_shift_i_type(f7_base, shamt, rs1, f3_srli_srai, rd, opcode_op_imm);

    end function instr_srli;

    function instr_srai (
        rd    : reg_type;
        rs1   : reg_type;
        shamt : integer
    ) return BusDataType is
    begin

        return encode_shift_i_type(f7_sub_sra, shamt, rs1, f3_srli_srai, rd, opcode_op_imm);

    end function instr_srai;

    -------------------------------------------------------------------------------------

    -- I-Type Load: lb, lh, lw, lbu, lhu -------------------------------------------------

    function instr_lb (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_lb, rd, opcode_load);

    end function instr_lb;

    function instr_lh (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_lh, rd, opcode_load);

    end function instr_lh;

    function instr_lw (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_lw, rd, opcode_load);

    end function instr_lw;

    function instr_lbu (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_lbu, rd, opcode_load);

    end function instr_lbu;

    function instr_lhu (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_lhu, rd, opcode_load);

    end function instr_lhu;

    -------------------------------------------------------------------------------------

    -- I-Type Jump & System: jalr, ebreak ------------------------------------------------

    function instr_jalr (
        rd  : reg_type;
        rs1 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_i_type(imm, rs1, f3_jalr, rd, opcode_jalr);

    end function instr_jalr;

    function instr_ebreak return BusDataType is
    begin

        return work.constants_pack.instr_ebreak;

    end function instr_ebreak;

    -------------------------------------------------------------------------------------

    -- S-Type Store: sb, sh, sw ---------------------------------------------------------

    function instr_sb (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_s_type(imm, rs2, rs1, f3_sb, opcode_store);

    end function instr_sb;

    function instr_sh (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_s_type(imm, rs2, rs1, f3_sh, opcode_store);

    end function instr_sh;

    function instr_sw (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_s_type(imm, rs2, rs1, f3_sw, opcode_store);

    end function instr_sw;

    -------------------------------------------------------------------------------------

    -- B-Type Branch: beq, bne, blt, bge, bltu, bgeu -------------------------------------

    function instr_beq (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_b_type(imm, rs2, rs1, f3_beq, opcode_branch);

    end function instr_beq;

    function instr_bne (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_b_type(imm, rs2, rs1, f3_bne, opcode_branch);

    end function instr_bne;

    function instr_blt (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_b_type(imm, rs2, rs1, f3_blt, opcode_branch);

    end function instr_blt;

    function instr_bge (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_b_type(imm, rs2, rs1, f3_bge, opcode_branch);

    end function instr_bge;

    function instr_bltu (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_b_type(imm, rs2, rs1, f3_bltu, opcode_branch);

    end function instr_bltu;

    function instr_bgeu (
        rs1 : reg_type;
        rs2 : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_b_type(imm, rs2, rs1, f3_bgeu, opcode_branch);

    end function instr_bgeu;

    -------------------------------------------------------------------------------------

    -- J-Type Jump: jal ------------------------------------------------------------------

    function instr_jal (
        rd  : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_j_type(imm, rd, opcode_jal);

    end function instr_jal;

    -------------------------------------------------------------------------------------

    -- U-Type lui, auipc ----------------------------------------------------------------

    function instr_lui (
        rd  : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_u_type(imm, rd, opcode_lui);

    end function instr_lui;

    function instr_auipc (
        rd  : reg_type;
        imm : integer
    ) return BusDataType is
    begin

        return encode_u_type(imm, rd, opcode_auipc);

    end function instr_auipc;

-------------------------------------------------------------------------------------

end package body inst_encoding_pack;

