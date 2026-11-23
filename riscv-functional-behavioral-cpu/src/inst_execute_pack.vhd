-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

library work;
  use work.defs_pack.all;

  ----------------------------------------------------------------------------------

  -- Implementation: ---------------------------------------------------------------

package inst_execute_pack is

  -- Loads (I-Type) ---------------------------------------------------------
  procedure EXEC_LB(
    rd     : in    reg_type;
    rs1    : in    reg_type;
    imm    : in    integer;
    reg    : inout reg_file_type;
    memory : in    mem_type
  );

  procedure EXEC_LH(
    rd     : in    reg_type;
    rs1    : in    reg_type;
    imm    : in    integer;
    reg    : inout reg_file_type;
    memory : in    mem_type
  );

  procedure EXEC_LW(
    rd     : in    reg_type;
    rs1    : in    reg_type;
    imm    : in    integer;
    reg    : inout reg_file_type;
    memory : in    mem_type
  );

  procedure EXEC_LBU(
    rd     : in    reg_type;
    rs1    : in    reg_type;
    imm    : in    integer;
    reg    : inout reg_file_type;
    memory : in    mem_type
  );

  procedure EXEC_LHU(
    rd     : in    reg_type;
    rs1    : in    reg_type;
    imm    : in    integer;
    reg    : inout reg_file_type;
    memory : in    mem_type
  );

  -- Stores (S-Type) --------------------------------------------------------
  procedure EXEC_SB(
    rs1    : in    reg_type;
    rs2    : in    reg_type;
    imm    : in    integer;
    reg    : in    reg_file_type;
    memory : inout mem_type
  );

  procedure EXEC_SH(
    rs1    : in    reg_type;
    rs2    : in    reg_type;
    imm    : in    integer;
    reg    : in    reg_file_type;
    memory : inout mem_type
  );

  procedure EXEC_SW(
    rs1    : in    reg_type;
    rs2    : in    reg_type;
    imm    : in    integer;
    reg    : in    reg_file_type;
    memory : inout mem_type
  );

  -- Register-register operations (R-Type) ----------------------------------
  procedure EXEC_ADD(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  procedure EXEC_SUB(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  procedure EXEC_SLL(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  procedure EXEC_SRL(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  procedure EXEC_SRA(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  procedure EXEC_SLT(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  procedure EXEC_SLTU(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  procedure EXEC_XOR(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  procedure EXEC_OR(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  procedure EXEC_AND(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    rs2 : in    reg_type;
    reg : inout reg_file_type
  );

  -- Register-immediate operations (I-Type) ---------------------------------
  procedure EXEC_ADDI(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    imm : in    integer;
    reg : inout reg_file_type
  );

  procedure EXEC_SLTI(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    imm : in    integer;
    reg : inout reg_file_type
  );

  procedure EXEC_SLTIU(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    imm : in    integer;
    reg : inout reg_file_type
  );

  procedure EXEC_XORI(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    imm : in    integer;
    reg : inout reg_file_type
  );

  procedure EXEC_ORI(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    imm : in    integer;
    reg : inout reg_file_type
  );

  procedure EXEC_ANDI(
    rd  : in    reg_type;
    rs1 : in    reg_type;
    imm : in    integer;
    reg : inout reg_file_type
  );

  -- Shifts with immediate shift amount (I-Type, shamt is 5 bit) -----------
  procedure EXEC_SLLI(
    rd    : in    reg_type;
    rs1   : in    reg_type;
    shamt : in    reg_type;
    reg   : inout reg_file_type
  );

  procedure EXEC_SRLI(
    rd    : in    reg_type;
    rs1   : in    reg_type;
    shamt : in    reg_type;
    reg   : inout reg_file_type
  );

  procedure EXEC_SRAI(
    rd    : in    reg_type;
    rs1   : in    reg_type;
    shamt : in    reg_type;
    reg   : inout reg_file_type
  );

  -- Upper immediates (U-Type), imm is already shifted (imm & x"000") -----
  procedure EXEC_LUI(
    rd  : in    reg_type;
    imm : in    data_type;
    reg : inout reg_file_type
  );

  procedure EXEC_AUIPC(
    rd       : in    reg_type;
    imm      : in    data_type;
    reg      : inout reg_file_type;
    instr_pc : in    natural
  );

  -- Branches (B-Type), imm is the signed byte offset ----------------------
  procedure EXEC_BEQ(
    rs1      : in    reg_type;
    rs2      : in    reg_type;
    imm      : in    integer;
    reg      : in    reg_file_type;
    instr_pc : in    natural;
    pc       : inout natural
  );

  procedure EXEC_BNE(
    rs1      : in    reg_type;
    rs2      : in    reg_type;
    imm      : in    integer;
    reg      : in    reg_file_type;
    instr_pc : in    natural;
    pc       : inout natural
  );

  procedure EXEC_BLT(
    rs1      : in    reg_type;
    rs2      : in    reg_type;
    imm      : in    integer;
    reg      : in    reg_file_type;
    instr_pc : in    natural;
    pc       : inout natural
  );

  procedure EXEC_BGE(
    rs1      : in    reg_type;
    rs2      : in    reg_type;
    imm      : in    integer;
    reg      : in    reg_file_type;
    instr_pc : in    natural;
    pc       : inout natural
  );

  procedure EXEC_BLTU(
    rs1      : in    reg_type;
    rs2      : in    reg_type;
    imm      : in    integer;
    reg      : in    reg_file_type;
    instr_pc : in    natural;
    pc       : inout natural
  );

  procedure EXEC_BGEU(
    rs1      : in    reg_type;
    rs2      : in    reg_type;
    imm      : in    integer;
    reg      : in    reg_file_type;
    instr_pc : in    natural;
    pc       : inout natural
  );

  -- Jumps -------------------------------------------------------------------
  procedure EXEC_JAL(
    rd       : in    reg_type;
    imm      : in    integer;
    instr_pc : in    natural;
    pc       : inout natural;
    reg      : inout reg_file_type
  );

  procedure EXEC_JALR(
    rd       : in    reg_type;
    rs1      : in    reg_type;
    imm      : in    integer;
    instr_pc : in    natural;
    pc       : inout natural;
    reg      : inout reg_file_type
  );

  -- System -------------------------------------------------------------------
  procedure EXEC_EBREAK(
    execute : inout boolean
  );

end package;

package body inst_execute_pack is

  -- Loads (I-Type) ---------------------------------------------------------
  procedure EXEC_LB(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type; memory : in mem_type) is
  begin
    null; -- TODO: implement LB
  end procedure;

  procedure EXEC_LH(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type; memory : in mem_type) is
  begin
    null; -- TODO: implement LH
  end procedure;

  procedure EXEC_LW(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type; memory : in mem_type) is
  begin
    null; -- TODO: implement LW
  end procedure;

  procedure EXEC_LBU(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type; memory : in mem_type) is
  begin
    null; -- TODO: implement LBU
  end procedure;

  procedure EXEC_LHU(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type; memory : in mem_type) is
  begin
    null; -- TODO: implement LHU
  end procedure;

  -- Stores (S-Type) --------------------------------------------------------
  procedure EXEC_SB(rs1 : in reg_type; rs2 : in reg_type; imm : in integer; reg : in reg_file_type; memory : inout mem_type) is
  begin
    null; -- TODO: implement SB
  end procedure;

  procedure EXEC_SH(rs1 : in reg_type; rs2 : in reg_type; imm : in integer; reg : in reg_file_type; memory : inout mem_type) is
  begin
    null; -- TODO: implement SH
  end procedure;

  procedure EXEC_SW(rs1 : in reg_type; rs2 : in reg_type; imm : in integer; reg : in reg_file_type; memory : inout mem_type) is
  begin
    null; -- TODO: implement SW
  end procedure;

  -- Register-register operations (R-Type) ----------------------------------
  procedure EXEC_ADD(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement ADD
  end procedure;

  procedure EXEC_SUB(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SUB
  end procedure;

  procedure EXEC_SLL(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SLL
  end procedure;

  procedure EXEC_SRL(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SRL
  end procedure;

  procedure EXEC_SRA(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SRA
  end procedure;

  procedure EXEC_SLT(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SLT
  end procedure;

  procedure EXEC_SLTU(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SLTU
  end procedure;

  procedure EXEC_XOR(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement XOR
  end procedure;

  procedure EXEC_OR(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement OR
  end procedure;

  procedure EXEC_AND(rd : in reg_type; rs1 : in reg_type; rs2 : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement AND
  end procedure;

  -- Register-immediate operations (I-Type) ---------------------------------
  procedure EXEC_ADDI(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement ADDI
  end procedure;

  procedure EXEC_SLTI(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SLTI
  end procedure;

  procedure EXEC_SLTIU(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SLTIU
  end procedure;

  procedure EXEC_XORI(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement XORI
  end procedure;

  procedure EXEC_ORI(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement ORI
  end procedure;

  procedure EXEC_ANDI(rd : in reg_type; rs1 : in reg_type; imm : in integer; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement ANDI
  end procedure;

  -- Shifts with immediate shift amount -------------------------------------
  procedure EXEC_SLLI(rd : in reg_type; rs1 : in reg_type; shamt : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SLLI
  end procedure;

  procedure EXEC_SRLI(rd : in reg_type; rs1 : in reg_type; shamt : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SRLI
  end procedure;

  procedure EXEC_SRAI(rd : in reg_type; rs1 : in reg_type; shamt : in reg_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement SRAI
  end procedure;

  -- Upper immediates (U-Type) ----------------------------------------------
  procedure EXEC_LUI(rd : in reg_type; imm : in data_type; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement LUI
  end procedure;

  procedure EXEC_AUIPC(rd : in reg_type; imm : in data_type; reg : inout reg_file_type; instr_pc : in natural) is
  begin
    null; -- TODO: implement AUIPC
  end procedure;

  -- Branches (B-Type) ------------------------------------------------------
  procedure EXEC_BEQ(rs1 : in reg_type; rs2 : in reg_type; imm : in integer; reg : in reg_file_type; instr_pc : in natural; pc : inout natural) is
  begin
    null; -- TODO: implement BEQ
  end procedure;

  procedure EXEC_BNE(rs1 : in reg_type; rs2 : in reg_type; imm : in integer; reg : in reg_file_type; instr_pc : in natural; pc : inout natural) is
  begin
    null; -- TODO: implement BNE
  end procedure;

  procedure EXEC_BLT(rs1 : in reg_type; rs2 : in reg_type; imm : in integer; reg : in reg_file_type; instr_pc : in natural; pc : inout natural) is
  begin
    null; -- TODO: implement BLT
  end procedure;

  procedure EXEC_BGE(rs1 : in reg_type; rs2 : in reg_type; imm : in integer; reg : in reg_file_type; instr_pc : in natural; pc : inout natural) is
  begin
    null; -- TODO: implement BGE
  end procedure;

  procedure EXEC_BLTU(rs1 : in reg_type; rs2 : in reg_type; imm : in integer; reg : in reg_file_type; instr_pc : in natural; pc : inout natural) is
  begin
    null; -- TODO: implement BLTU
  end procedure;

  procedure EXEC_BGEU(rs1 : in reg_type; rs2 : in reg_type; imm : in integer; reg : in reg_file_type; instr_pc : in natural; pc : inout natural) is
  begin
    null; -- TODO: implement BGEU
  end procedure;

  -- Jumps -------------------------------------------------------------------
  procedure EXEC_JAL(rd : in reg_type; imm : in integer; instr_pc : in natural; pc : inout natural; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement JAL
  end procedure;

  procedure EXEC_JALR(rd : in reg_type; rs1 : in reg_type; imm : in integer; instr_pc : in natural; pc : inout natural; reg : inout reg_file_type) is
  begin
    null; -- TODO: implement JALR
  end procedure;

  -- System -------------------------------------------------------------------
  procedure EXEC_EBREAK(execute : inout boolean) is
  begin
    execute := false; -- TODO: implement EBREAK
  end procedure;

end package body;
