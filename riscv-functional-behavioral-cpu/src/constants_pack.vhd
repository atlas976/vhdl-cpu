-- RV32I instruction encoding constants.

package constants_pack is
    --!!! insert other packages here!
    
    --!!! move into defs package: subtype funct3_type is bit_vector(2 downto 0);
    --!!! move into defs package: subtype funct7_type is bit_vector(6 downto 0);
    --!!! move into defs package: subtype opcode_type is bit_vector(6 downto 0);


    -- Main opcodes (Instr(6 downto 0))
    constant OPCODE_LOAD   : opcode_type := "0000011";
    constant OPCODE_OP_IMM : opcode_type := "0010011";
    constant OPCODE_AUIPC  : opcode_type := "0010111";
    constant OPCODE_STORE  : opcode_type := "0100011";
    constant OPCODE_OP     : opcode_type := "0110011";
    constant OPCODE_LUI    : opcode_type := "0110111";
    constant OPCODE_BRANCH : opcode_type := "1100011";
    constant OPCODE_JALR   : opcode_type := "1100111";
    constant OPCODE_JAL    : opcode_type := "1101111";
    constant OPCODE_SYSTEM : opcode_type := "1110011";

    -- LOAD funct3
    constant F3_LB  : funct3_type := "000";
    constant F3_LH  : funct3_type := "001";
    constant F3_LW  : funct3_type := "010";
    constant F3_LBU : funct3_type := "100";
    constant F3_LHU : funct3_type := "101";

    -- STORE funct3
    constant F3_SB : funct3_type := "000";
    constant F3_SH : funct3_type := "001";
    constant F3_SW : funct3_type := "010";

    -- Register-register OP funct3
    constant F3_ADD_SUB : funct3_type := "000";
    constant F3_SLL     : funct3_type := "001";
    constant F3_SLT     : funct3_type := "010";
    constant F3_SLTU    : funct3_type := "011";
    constant F3_XOR     : funct3_type := "100";
    constant F3_SRL_SRA : funct3_type := "101";
    constant F3_OR      : funct3_type := "110";
    constant F3_AND     : funct3_type := "111";

    -- Register-immediate OP-IMM funct3
    constant F3_ADDI      : funct3_type := "000";
    constant F3_SLLI      : funct3_type := "001";
    constant F3_SLTI      : funct3_type := "010";
    constant F3_SLTIU     : funct3_type := "011";
    constant F3_XORI      : funct3_type := "100";
    constant F3_SRLI_SRAI : funct3_type := "101";
    constant F3_ORI       : funct3_type := "110";
    constant F3_ANDI      : funct3_type := "111";

    -- BRANCH funct3
    constant F3_BEQ  : funct3_type := "000";
    constant F3_BNE  : funct3_type := "001";
    constant F3_BLT  : funct3_type := "100";
    constant F3_BGE  : funct3_type := "101";
    constant F3_BLTU : funct3_type := "110";
    constant F3_BGEU : funct3_type := "111";

    constant F3_JALR : funct3_type := "000";

    -- funct7 for RV32I register operations and immediate shifts
    constant F7_BASE    : funct7_type := "0000000";
    constant F7_SUB_SRA : funct7_type := "0100000";

    -- Full instruction encodings (NOP is ADDI x0,x0,0)
    constant INSTR_EBREAK : bit_vector(31 downto 0) := X"00100073";

    constant X0          : bit_vector(4 downto 0) := "00000";
    constant INSTR_BYTES : positive := 4;
    
end package constants_pack;
