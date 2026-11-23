
-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

library ieee;
    use work.defs_pack.all;
--! !! add other packages here later.

----------------------------------------------------------------------------------

-- Implementation: ---------------------------------------------------------------

-- RV32I instruction encoding constants.

package constants_pack is

    -- Main opcodes (Instr(6 downto 0))
    constant opcode_load   : optype := "0000011";
    constant opcode_op_imm : optype := "0010011";
    constant opcode_auipc  : optype := "0010111";
    constant opcode_store  : optype := "0100011";
    constant opcode_op     : optype := "0110011";
    constant opcode_lui    : optype := "0110111";
    constant opcode_branch : optype := "1100011";
    constant opcode_jalr   : optype := "1100111";
    constant opcode_jal    : optype := "1101111";
    constant opcode_system : optype := "1110011";

    -- LOAD funct3
    constant f3_lb  : func3type := "000";
    constant f3_lh  : func3type := "001";
    constant f3_lw  : func3type := "010";
    constant f3_lbu : func3type := "100";
    constant f3_lhu : func3type := "101";

    -- STORE funct3
    constant f3_sb : func3type := "000";
    constant f3_sh : func3type := "001";
    constant f3_sw : func3type := "010";

    -- Register-register OP funct3
    constant f3_add_sub : func3type := "000";
    constant f3_sll     : func3type := "001";
    constant f3_slt     : func3type := "010";
    constant f3_sltu    : func3type := "011";
    constant f3_xor     : func3type := "100";
    constant f3_srl_sra : func3type := "101";
    constant f3_or      : func3type := "110";
    constant f3_and     : func3type := "111";

    -- Register-immediate OP-IMM funct3
    constant f3_addi      : func3type := "000";
    constant f3_slli      : func3type := "001";
    constant f3_slti      : func3type := "010";
    constant f3_sltiu     : func3type := "011";
    constant f3_xori      : func3type := "100";
    constant f3_srli_srai : func3type := "101";
    constant f3_ori       : func3type := "110";
    constant f3_andi      : func3type := "111";

    -- BRANCH funct3
    constant f3_beq  : func3type := "000";
    constant f3_bne  : func3type := "001";
    constant f3_blt  : func3type := "100";
    constant f3_bge  : func3type := "101";
    constant f3_bltu : func3type := "110";
    constant f3_bgeu : func3type := "111";

    constant f3_jalr : func3type := "000";

    -- funct7 for RV32I register operations and immediate shifts
    constant f7_base    : func7type := "0000000";
    constant f7_sub_sra : func7type := "0100000";

    -- Full instruction encodings (NOP is ADDI x0,x0,0)
    constant instr_ebreak : bit_vector(31 downto 0) := x"00100073";

    constant x0          : bit_vector(4 downto 0) := "00000";
    constant instr_bytes : positive               := 4;

end package constants_pack;
