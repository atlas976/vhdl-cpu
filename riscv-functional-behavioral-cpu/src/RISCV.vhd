----------------------------------------------------------------------------------
-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

library ieee;
  use ieee.numeric_bit.all;
  use work.defs_pack.all;
  use work.mem_pack.all;
  use work.inst_execute_pack.all;
  use work.tracer_pack.all;
  use work.mnemonic_pack.all;
  use work.constants_pack.all;
  --! !! add other packages here later.
library std;
  use std.textio.all;

  ----------------------------------------------------------------------------------

  -- Implementation: ---------------------------------------------------------------

entity riscv is
end entity;

architecture functional of riscv is

begin

  process is
    --! !! add range later here
    file f : text open WRITE_MODE is "trace.txt";
    variable l            : line;
    variable memory       : mem_type      := init_memory("test_program.asm");
    variable reg          : reg_file_type := (others => (others => '0'));
    variable instr        : BusDataType   := (others => '0');
    variable op           : optype        := (others => '0');
    variable rd           : reg_type      := (others => '0');
    variable rs1          : reg_type      := (others => '0');
    variable rs2          : reg_type      := (others => '0');
    variable shamt        : reg_type      := (others => '0');
    variable funct3       : func3type     := (others => '0');
    variable funct7       : func7type     := (others => '0');
    variable imm_i        : integer       := 0;
    variable imm_s        : integer       := 0;
    variable imm_b        : integer       := 0;
    variable imm_j        : integer       := 0;
    variable imm_u        : data_type     := (others => '0');
    variable pc, instr_pc : natural       := 0;
    variable execute      : boolean       := TRUE;

  begin
    print_header(f => f);
    while execute loop

      -- Fetch: PC is a BYTE address, Memory has 32-bit words.
      instr_pc := pc;

      instr := Memory(pc / INSTR_BYTES);
      op := Instr(6 downto 0);
      write(l, string'(to_binary_string(op)));
      writeline(output, l);
      rd := Instr(11 downto 7);
      rs1 := Instr(19 downto 15);
      rs2 := Instr(24 downto 20);
      funct3 := Instr(14 downto 12);
      funct7 := Instr(31 downto 25);
      imm_i := to_integer(signed(Instr(31 downto 20)));
      imm_s := to_integer(signed(bit_vector'(Instr(31 downto 25) & Instr(11 downto 7))));
      imm_b := to_integer(signed(Instr(31) & Instr(7) & Instr(30 downto 25) & Instr(11 downto 8) & '0'));
      imm_u := Instr(31 downto 12) & x"000";
      imm_j := to_integer(signed(Instr(31) & Instr(19 downto 12) & Instr(20) & Instr(30 downto 21) & '0'));
      shamt := Instr(24 downto 20);
      print_pc(l => l, pc => pc);
      pc := pc + INSTR_BYTES;

      -- Decode and execute
      case op is

        -- Loads (I-Type)
        when OPCODE_LOAD =>

          case funct3 is

            when F3_LB =>
              print_cmd(l => l, cmd => LB_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
              EXEC_LB(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);
              print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));
            when F3_LH =>
              print_cmd(l => l, cmd => LH_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
              EXEC_LH(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);
              print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

            when F3_LW =>
              print_cmd(l => l, cmd => LW_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
              EXEC_LW(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);
              print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

            when F3_LBU =>
              print_cmd(l => l, cmd => LBU_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
              EXEC_LBU(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);
              print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

            when F3_LHU =>
              print_cmd(l => l, cmd => LHU_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
              EXEC_LHU(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);
              print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

            when others =>

              assert FALSE
                report "Illegal LOAD funct3"
                severity failure;

          end case;

        -- Stores (S-Type): trace shows the stored value (rs2) as result
        when OPCODE_STORE =>

          case funct3 is

            when F3_SB =>
              print_cmd(l => l, cmd => SB_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => imm_s);
              EXEC_SB(rs1 => rs1, rs2 => rs2, imm => imm_s, reg => reg, memory => memory);
              print_result(l => l, f => f, rd => reg(to_integer(unsigned(rs2))));

            when F3_SH =>
              print_cmd(l => l, cmd => SH_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => imm_s);
              EXEC_SH(rs1 => rs1, rs2 => rs2, imm => imm_s, reg => reg, memory => memory);
              print_result(l => l, f => f, rd => reg(to_integer(unsigned(rs2))));

            when F3_SW =>
              print_cmd(l => l, cmd => SW_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => imm_s);
              EXEC_SW(rs1 => rs1, rs2 => rs2, imm => imm_s, reg => reg, memory => memory);
              print_result(l => l, f => f, rd => reg(to_integer(unsigned(rs2))));

            when others =>

              assert FALSE
                report "Illegal STORE funct3"
                severity failure;

          end case;

        -- Register-register operations (R-Type)
        when OPCODE_OP =>

          case funct3 is

            when F3_ADD_SUB =>

              case funct7 is

                when F7_BASE =>
                  print_cmd(l => l, cmd => ADD_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                  EXEC_ADD(
                    rd => rd, rs1 => rs1, rs2 => rs2,
                    reg => reg
                  );
                  print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

                when F7_SUB_SRA =>
                  print_cmd(l => l, cmd => SUB_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                  EXEC_SUB(
                    rd => rd, rs1 => rs1, rs2 => rs2,
                    reg => reg
                  );
                  print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

                when others =>

                  assert FALSE
                    report "Illegal ADD/SUB funct7"
                    severity failure;

              end case;

            when F3_SRL_SRA =>

              case funct7 is

                when F7_BASE =>
                  print_cmd(l => l, cmd => SRL_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                  EXEC_SRL(
                    rd => rd, rs1 => rs1, rs2 => rs2,
                    reg => reg
                  );
                  print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

                when F7_SUB_SRA =>
                  print_cmd(l => l, cmd => SRA_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                  EXEC_SRA(
                    rd => rd, rs1 => rs1, rs2 => rs2,
                    reg => reg
                  );
                  print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

                when others =>

                  assert FALSE
                    report "Illegal SRL/SRA funct7"
                    severity failure;

              end case;

            when F3_SLL =>

              if (funct7 = F7_BASE) then
                print_cmd(l => l, cmd => SLL_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                EXEC_SLL(
                  rd => rd, rs1 => rs1, rs2 => rs2,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));
              else
                assert FALSE
                  report "Illegal SLL funct7"
                  severity failure;
              end if;

            when F3_SLT =>

              if (funct7 = F7_BASE) then
                print_cmd(l => l, cmd => SLT_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                EXEC_SLT(
                  rd => rd, rs1 => rs1, rs2 => rs2,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));
              else
                assert FALSE
                  report "Illegal SLT funct7"
                  severity failure;
              end if;

            when F3_SLTU =>

              if (funct7 = F7_BASE) then
                print_cmd(l => l, cmd => SLTU_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                EXEC_SLTU(
                  rd => rd, rs1 => rs1, rs2 => rs2,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));
              else
                assert FALSE
                  report "Illegal SLTU funct7"
                  severity failure;
              end if;

            when F3_XOR =>

              if (funct7 = F7_BASE) then
                print_cmd(l => l, cmd => XOR_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                EXEC_XOR(
                  rd => rd, rs1 => rs1, rs2 => rs2,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));
              else
                assert FALSE
                  report "Illegal XOR funct7"
                  severity failure;
              end if;

            when F3_OR =>

              if (funct7 = F7_BASE) then
                print_cmd(l => l, cmd => OR_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                EXEC_OR(
                  rd => rd, rs1 => rs1, rs2 => rs2,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));
              else
                assert FALSE
                  report "Illegal OR funct7"
                  severity failure;
              end if;

            when F3_AND =>

              if (funct7 = F7_BASE) then
                print_cmd(l => l, cmd => AND_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => 0);
                EXEC_AND(
                  rd => rd, rs1 => rs1, rs2 => rs2,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));
              else
                assert FALSE
                  report "Illegal AND funct7"
                  severity failure;
              end if;

            when others =>

              assert FALSE
                report "Illegal OP funct3"
                severity failure;

          end case;

        -- Register-immediate operations (I-Type)
        when OPCODE_OP_IMM =>

          if (instr = INSTR_NOP) then
            print_cmd(l => l, cmd => NOP_mnemonic, r1 => reg(0), r2 => reg(0), imm => 0);
            print_result(l => l, f => f, rd => reg(0));
            null; -- NOP is ADDI x0, x0, 0, not traced
          else

            case funct3 is

              when F3_ADDI =>
                print_cmd(l => l, cmd => ADDI_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
                EXEC_ADDI(
                  rd => rd, rs1 => rs1, imm => imm_i,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

              when F3_SLTI =>
                print_cmd(l => l, cmd => SLTI_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
                EXEC_SLTI(
                  rd => rd, rs1 => rs1, imm => imm_i,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

              when F3_SLTIU =>
                print_cmd(l => l, cmd => SLTIU_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
                EXEC_SLTIU(
                  rd => rd, rs1 => rs1, imm => imm_i,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

              when F3_XORI =>
                print_cmd(l => l, cmd => XORI_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
                EXEC_XORI(
                  rd => rd, rs1 => rs1, imm => imm_i,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

              when F3_ORI =>
                print_cmd(l => l, cmd => ORI_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
                EXEC_ORI(
                  rd => rd, rs1 => rs1, imm => imm_i,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

              when F3_ANDI =>
                print_cmd(l => l, cmd => ANDI_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
                EXEC_ANDI(
                  rd => rd, rs1 => rs1, imm => imm_i,
                  reg => reg
                );
                print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

              when F3_SLLI =>

                if (funct7 = F7_BASE) then
                  print_cmd(l => l, cmd => SLLI_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => to_integer(unsigned(shamt)));
                  EXEC_SLLI(
                    rd => rd, rs1 => rs1, shamt => shamt,
                    reg => reg
                  );
                  print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));
                else
                  assert FALSE
                    report "Illegal SLLI funct7"
                    severity failure;
                end if;

              when F3_SRLI_SRAI =>

                case funct7 is

                  when F7_BASE =>
                    print_cmd(l => l, cmd => SRLI_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => to_integer(unsigned(shamt)));
                    EXEC_SRLI(
                      rd => rd, rs1 => rs1, shamt => shamt,
                      reg => reg
                    );
                    print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

                  when F7_SUB_SRA =>
                    print_cmd(l => l, cmd => SRAI_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => to_integer(unsigned(shamt)));
                    EXEC_SRAI(
                      rd => rd, rs1 => rs1, shamt => shamt,
                      reg => reg
                    );
                    print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

                  when others =>

                    assert FALSE
                      report "Illegal SRLI/SRAI funct7"
                      severity failure;

                end case;

              when others =>

                assert FALSE
                  report "Illegal OP-IMM funct3"
                  severity failure;

            end case;

          end if;

        -- Special operations (U-Type)
        when OPCODE_LUI =>
          print_cmd(l => l, cmd => LUI_mnemonic, r1 => reg(0), r2 => reg(0), imm => to_integer(signed(imm_u)));
          EXEC_LUI(rd => rd, imm => imm_u, reg => reg);
          print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

        when OPCODE_AUIPC =>
          print_cmd(l => l, cmd => AUIPC_mnemonic, r1 => reg(0), r2 => reg(0), imm => to_integer(signed(imm_u)));
          EXEC_AUIPC(rd => rd, imm => imm_u, reg => reg, instr_pc => instr_pc);
          print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

        -- Branches (B-Type): no register written, RD column stays 0
        when OPCODE_BRANCH =>

          case funct3 is

            when F3_BEQ =>
              print_cmd(l => l, cmd => BEQ_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => imm_b);
              EXEC_BEQ(rs1 => rs1, rs2 => rs2, imm => imm_b, reg => reg, instr_pc => instr_pc, pc => pc);
              print_result(l => l, f => f, rd => reg(0));

            when F3_BNE =>
              print_cmd(l => l, cmd => BNE_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => imm_b);
              EXEC_BNE(rs1 => rs1, rs2 => rs2, imm => imm_b, reg => reg, instr_pc => instr_pc, pc => pc);
              print_result(l => l, f => f, rd => reg(0));

            when F3_BLT =>
              print_cmd(l => l, cmd => BLT_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => imm_b);
              EXEC_BLT(rs1 => rs1, rs2 => rs2, imm => imm_b, reg => reg, instr_pc => instr_pc, pc => pc);
              print_result(l => l, f => f, rd => reg(0));

            when F3_BGE =>
              print_cmd(l => l, cmd => BGE_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => imm_b);
              EXEC_BGE(rs1 => rs1, rs2 => rs2, imm => imm_b, reg => reg, instr_pc => instr_pc, pc => pc);
              print_result(l => l, f => f, rd => reg(0));

            when F3_BLTU =>
              print_cmd(l => l, cmd => BLTU_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => imm_b);
              EXEC_BLTU(
                rs1 => rs1, rs2 => rs2, imm => imm_b,
                reg => reg, instr_pc => instr_pc, pc => pc
              );
              print_result(l => l, f => f, rd => reg(0));

            when F3_BGEU =>
              print_cmd(l => l, cmd => BGEU_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(to_integer(unsigned(rs2))), imm => imm_b);
              EXEC_BGEU(
                rs1 => rs1, rs2 => rs2, imm => imm_b,
                reg => reg, instr_pc => instr_pc, pc => pc
              );
              print_result(l => l, f => f, rd => reg(0));

            when others =>

              assert FALSE
                report "Illegal BRANCH funct3"
                severity failure;

          end case;

        -- Jumps
        when OPCODE_JAL =>
          print_cmd(l => l, cmd => JAL_mnemonic, r1 => reg(0), r2 => reg(0), imm => imm_j);
          EXEC_JAL(rd => rd, imm => imm_j, instr_pc => instr_pc, pc => pc, reg => reg);
          print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));

        when OPCODE_JALR =>

          if (funct3 = F3_JALR) then
            print_cmd(l => l, cmd => JALR_mnemonic, r1 => reg(to_integer(unsigned(rs1))), r2 => reg(0), imm => imm_i);
            EXEC_JALR(rd => rd, rs1 => rs1, imm => imm_i, instr_pc => instr_pc, pc => pc, reg => reg);
            print_result(l => l, f => f, rd => reg(to_integer(unsigned(rd))));
          else
            assert FALSE
              report "Illegal JALR funct3"
              severity failure;
          end if;

        -- System instructions (EBREAK is the lab stop)
        when OPCODE_SYSTEM =>

          if (instr = INSTR_EBREAK) then
            print_cmd(l => l, cmd => EBREAK_mnemonic, r1 => reg(0), r2 => reg(0), imm => 0);
            EXEC_EBREAK(execute => execute);
            print_result(l => l, f => f, rd => reg(0));
          else
            assert FALSE
              report "Illegal SYSTEM instruction"
              severity failure;
          end if;

        when others =>

          assert FALSE
            report "Illegal opcode"
            severity failure;

      end case;

    end loop;

    wait;

  end process;

end architecture;
