-- RV32I instruction encoding constants.

package constants_pack is

    --! !! insert other packages here!

    --! !! move into defs package: subtype funct3_type is bit_vector(2 downto 0);
    --! !! move into defs package: subtype funct7_type is bit_vector(6 downto 0);
    --! !! move into defs package: subtype opcode_type is bit_vector(6 downto 0);

    -- Main opcodes (Instr(6 downto 0))
    constant opcode_load   : opcode_type := "0000011";
    constant opcode_op_imm : opcode_type := "0010011";
    constant opcode_auipc  : opcode_type := "0010111";
    constant opcode_store  : opcode_type := "0100011";
    constant opcode_op     : opcode_type := "0110011";
    constant opcode_lui    : opcode_type := "0110111";
    constant opcode_branch : opcode_type := "1100011";
    constant opcode_jalr   : opcode_type := "1100111";
    constant opcode_jal    : opcode_type := "1101111";
    constant opcode_system : opcode_type := "1110011";

    -- LOAD funct3
    constant f3_lb  : funct3_type := "000";
    constant f3_lh  : funct3_type := "001";
    constant f3_lw  : funct3_type := "010";
    constant f3_lbu : funct3_type := "100";
    constant f3_lhu : funct3_type := "101";

    -- STORE funct3
    constant f3_sb : funct3_type := "000";
    constant f3_sh : funct3_type := "001";
    constant f3_sw : funct3_type := "010";

    -- Register-register OP funct3
    constant f3_add_sub : funct3_type := "000";
    constant f3_sll     : funct3_type := "001";
    constant f3_slt     : funct3_type := "010";
    constant f3_sltu    : funct3_type := "011";
    constant f3_xor     : funct3_type := "100";
    constant f3_srl_sra : funct3_type := "101";
    constant f3_or      : funct3_type := "110";
    constant f3_and     : funct3_type := "111";

    -- Register-immediate OP-IMM funct3
    constant f3_addi      : funct3_type := "000";
    constant f3_slli      : funct3_type := "001";
    constant f3_slti      : funct3_type := "010";
    constant f3_sltiu     : funct3_type := "011";
    constant f3_xori      : funct3_type := "100";
    constant f3_srli_srai : funct3_type := "101";
    constant f3_ori       : funct3_type := "110";
    constant f3_andi      : funct3_type := "111";

    -- BRANCH funct3
    constant f3_beq  : funct3_type := "000";
    constant f3_bne  : funct3_type := "001";
    constant f3_blt  : funct3_type := "100";
    constant f3_bge  : funct3_type := "101";
    constant f3_bltu : funct3_type := "110";
    constant f3_bgeu : funct3_type := "111";

    constant f3_jalr : funct3_type := "000";

    -- funct7 for RV32I register operations and immediate shifts
    constant f7_base    : funct7_type := "0000000";
    constant f7_sub_sra : funct7_type := "0100000";

    -- Full instruction encodings (NOP is ADDI x0,x0,0)
    constant instr_ebreak : bit_vector(31 downto 0) := x"00100073";

    constant x0          : bit_vector(4 downto 0) := "00000";
    constant instr_bytes : positive               := 4;

end package constants_pack;
