----------------------------------------------------------------------------------
-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

library ieee;
    use ieee.numeric_bit.all;
    use work.constants_pack.all;
--! !! add other packages here later.
----------------------------------------------------------------------------------

-- Implementation: ---------------------------------------------------------------

entity riscv is
end entity riscv;

architecture functional of riscv is

begin

    process is

        --! !! add range later here

        variable memory       : mem_type      := init_memory_empty;
        variable reg          : reg_type      := (others => (others => '0'));
        variable instr        : instr_type    := (others => '0');
        variable op           : opcode_type   := (others => '0');
        variable rd           : reg_addr_type := (others => '0');
        variable rs1          : reg_addr_type := (others => '0');
        variable rs2          : reg_addr_type := (others => '0');
        variable shamt        : reg_addr_type := (others => '0');
        variable funct3       : funct3_type   := (others => '0');
        variable funct7       : funct7_type   := (others => '0');
        variable imm_i        : integer       := 0;
        variable imm_s        : integer       := 0;
        variable imm_b        : integer       := 0;
        variable imm_j        : integer       := 0;
        variable imm_u        : data_type     := (others => '0');
        variable pc, instr_pc : natural       := 0;
        variable zero         : boolean       := FALSE;
        variable carry        : boolean       := FALSE;
        variable negative     : boolean       := FALSE;
        variable overflow     : boolean       := FALSE;
        variable execute      : boolean       := TRUE;

    begin

        while execute loop

            -- Fetch: PC is a BYTE address, Memory has 32-bit words.
            instr_pc := pc;
            instr    := Memory(pc / INSTR_BYTES);
            op       := Instr(6 downto 0);
            rd       := Instr(11 downto 7);
            rs1      := Instr(19 downto 15);
            rs2      := Instr(24 downto 20);
            funct3   := Instr(14 downto 12);
            funct7   := Instr(31 downto 25);
            imm_i    := to_integer(signed(Instr(31 downto 20)));
            imm_s    := to_integer(signed(Instr(31 downto 25) & Instr(11 downto 7)));
            imm_b    := to_integer(signed(Instr(31) & Instr(7) & Instr(30 downto 25) & Instr(11 downto 8) & '0'));
            imm_u    := Instr(31 downto 12) & x"000";
            imm_j    := to_integer(signed(Instr(31) & Instr(19 downto 12) & Instr(20) & Instr(30 downto 21) & '0'));
            shamt    := Instr(24 downto 20);
            pc       := pc + INSTR_BYTES;

            -- Decode and execute
            case op is

                -- Loads (I-Type)
                when OPCODE_LOAD =>

                    case funct3 is

                        when F3_LB =>

                            EXEC_LB(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);

                        when F3_LH =>

                            EXEC_LH(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);

                        when F3_LW =>

                            EXEC_LW(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);

                        when F3_LBU =>

                            EXEC_LBU(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);

                        when F3_LHU =>

                            EXEC_LHU(rd => rd, rs1 => rs1, imm => imm_i, reg => reg, memory => memory);

                        when others =>

                            assert FALSE
                                report "Illegal LOAD funct3"
                                severity failure;

                    end case;

                -- Stores (S-Type)
                when OPCODE_STORE =>

                    case funct3 is

                        when F3_SB =>

                            EXEC_SB(rs1 => rs1, rs2 => rs2, imm => imm_s, reg => reg, memory => memory);

                        when F3_SH =>

                            EXEC_SH(rs1 => rs1, rs2 => rs2, imm => imm_s, reg => reg, memory => memory);

                        when F3_SW =>

                            EXEC_SW(rs1 => rs1, rs2 => rs2, imm => imm_s, reg => reg, memory => memory);

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

                                    EXEC_ADD(
                                             rd       => rd, rs1 => rs1, rs2 => rs2,
                                             reg      => reg, zero => zero, carry => carry,
                                             negative => negative, overflow => overflow
                                         );

                                when F7_SUB_SRA =>

                                    EXEC_SUB(
                                             rd       => rd, rs1 => rs1, rs2 => rs2,
                                             reg      => reg, zero => zero, carry => carry,
                                             negative => negative, overflow => overflow
                                         );

                                when others =>

                                    assert FALSE
                                        report "Illegal ADD/SUB funct7"
                                        severity failure;

                            end case;

                        when F3_SRL_SRA =>

                            case funct7 is

                                when F7_BASE =>

                                    EXEC_SRL(
                                             rd       => rd, rs1 => rs1, rs2 => rs2,
                                             reg      => reg, zero => zero, carry => carry,
                                             negative => negative, overflow => overflow
                                         );

                                when F7_SUB_SRA =>

                                    EXEC_SRA(
                                             rd       => rd, rs1 => rs1, rs2 => rs2,
                                             reg      => reg, zero => zero, carry => carry,
                                             negative => negative, overflow => overflow
                                         );

                                when others =>

                                    assert FALSE
                                        report "Illegal SRL/SRA funct7"
                                        severity failure;

                            end case;

                        when F3_SLL =>

                            if (funct7 = F7_BASE) then
                                EXEC_SLL(
                                         rd       => rd, rs1 => rs1, rs2 => rs2,
                                         reg      => reg, zero => zero, carry => carry,
                                         negative => negative, overflow => overflow
                                     );
                            else
                                assert FALSE
                                    report "Illegal SLL funct7"
                                    severity failure;
                            end if;

                        when F3_SLT =>

                            if (funct7 = F7_BASE) then
                                EXEC_SLT(
                                         rd       => rd, rs1 => rs1, rs2 => rs2,
                                         reg      => reg, zero => zero, carry => carry,
                                         negative => negative, overflow => overflow
                                     );
                            else
                                assert FALSE
                                    report "Illegal SLT funct7"
                                    severity failure;
                            end if;

                        when F3_SLTU =>

                            if (funct7 = F7_BASE) then
                                EXEC_SLTU(
                                          rd       => rd, rs1 => rs1, rs2 => rs2,
                                          reg      => reg, zero => zero, carry => carry,
                                          negative => negative, overflow => overflow
                                      );
                            else
                                assert FALSE
                                    report "Illegal SLTU funct7"
                                    severity failure;
                            end if;

                        when F3_XOR =>

                            if (funct7 = F7_BASE) then
                                EXEC_XOR(
                                         rd       => rd, rs1 => rs1, rs2 => rs2,
                                         reg      => reg, zero => zero, carry => carry,
                                         negative => negative, overflow => overflow
                                     );
                            else
                                assert FALSE
                                    report "Illegal XOR funct7"
                                    severity failure;
                            end if;

                        when F3_OR =>

                            if (funct7 = F7_BASE) then
                                EXEC_OR(
                                        rd       => rd, rs1 => rs1, rs2 => rs2,
                                        reg      => reg, zero => zero, carry => carry,
                                        negative => negative, overflow => overflow
                                    );
                            else
                                assert FALSE
                                    report "Illegal OR funct7"
                                    severity failure;
                            end if;

                        when F3_AND =>

                            if (funct7 = F7_BASE) then
                                EXEC_AND(
                                         rd       => rd, rs1 => rs1, rs2 => rs2,
                                         reg      => reg, zero => zero, carry => carry,
                                         negative => negative, overflow => overflow
                                     );
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
                        null;  -- NOP is ADDI x0, x0, 0
                    else

                        case funct3 is

                            when F3_ADDI =>

                                EXEC_ADDI(
                                          rd       => rd, rs1 => rs1, imm => imm_i,
                                          reg      => reg, zero => zero, carry => carry,
                                          negative => negative, overflow => overflow
                                      );

                            when F3_SLTI =>

                                EXEC_SLTI(
                                          rd       => rd, rs1 => rs1, imm => imm_i,
                                          reg      => reg, zero => zero, carry => carry,
                                          negative => negative, overflow => overflow
                                      );

                            when F3_SLTIU =>

                                EXEC_SLTIU(
                                           rd       => rd, rs1 => rs1, imm => imm_i,
                                           reg      => reg, zero => zero, carry => carry,
                                           negative => negative, overflow => overflow
                                       );

                            when F3_XORI =>

                                EXEC_XORI(
                                          rd       => rd, rs1 => rs1, imm => imm_i,
                                          reg      => reg, zero => zero, carry => carry,
                                          negative => negative, overflow => overflow
                                      );

                            when F3_ORI =>

                                EXEC_ORI(
                                         rd       => rd, rs1 => rs1, imm => imm_i,
                                         reg      => reg, zero => zero, carry => carry,
                                         negative => negative, overflow => overflow
                                     );

                            when F3_ANDI =>

                                EXEC_ANDI(
                                          rd       => rd, rs1 => rs1, imm => imm_i,
                                          reg      => reg, zero => zero, carry => carry,
                                          negative => negative, overflow => overflow
                                      );

                            when F3_SLLI =>

                                if (funct7 = F7_BASE) then
                                    EXEC_SLLI(
                                              rd       => rd, rs1 => rs1, shamt => shamt,
                                              reg      => reg, zero => zero, carry => carry,
                                              negative => negative, overflow => overflow
                                          );
                                else
                                    assert FALSE
                                        report "Illegal SLLI funct7"
                                        severity failure;
                                end if;

                            when F3_SRLI_SRAI =>

                                case funct7 is

                                    when F7_BASE =>

                                        EXEC_SRLI(
                                                  rd       => rd, rs1 => rs1, shamt => shamt,
                                                  reg      => reg, zero => zero, carry => carry,
                                                  negative => negative, overflow => overflow
                                              );

                                    when F7_SUB_SRA =>

                                        EXEC_SRAI(
                                                  rd       => rd, rs1 => rs1, shamt => shamt,
                                                  reg      => reg, zero => zero, carry => carry,
                                                  negative => negative, overflow => overflow
                                              );

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

                    EXEC_LUI(rd => rd, imm => imm_u, reg => reg);

                when OPCODE_AUIPC =>

                    EXEC_AUIPC(rd => rd, imm => imm_u, reg => reg, instr_pc => instr_pc);

                -- Branches (B-Type)
                when OPCODE_BRANCH =>

                    case funct3 is

                        when F3_BEQ =>

                            EXEC_BEQ(rs1 => rs1, rs2 => rs2, imm => imm_b, reg => reg, instr_pc => instr_pc, pc => pc);

                        when F3_BNE =>

                            EXEC_BNE(rs1 => rs1, rs2 => rs2, imm => imm_b, reg => reg, instr_pc => instr_pc, pc => pc);

                        when F3_BLT =>

                            EXEC_BLT(rs1 => rs1, rs2 => rs2, imm => imm_b, reg => reg, instr_pc => instr_pc, pc => pc);

                        when F3_BGE =>

                            EXEC_BGE(rs1 => rs1, rs2 => rs2, imm => imm_b, reg => reg, instr_pc => instr_pc, pc => pc);

                        when F3_BLTU =>

                            EXEC_BLTU(
                                      rs1 => rs1, rs2 => rs2, imm => imm_b,
                                      reg => reg, instr_pc => instr_pc, pc => pc
                                  );

                        when F3_BGEU =>

                            EXEC_BGEU(
                                      rs1 => rs1, rs2 => rs2, imm => imm_b,
                                      reg => reg, instr_pc => instr_pc, pc => pc
                                  );

                        when others =>

                            assert FALSE
                                report "Illegal BRANCH funct3"
                                severity failure;

                    end case;

                -- Jumps
                when OPCODE_JAL =>

                    EXEC_JAL(rd => rd, imm => imm_j, instr_pc => instr_pc, pc => pc, reg => reg);

                when OPCODE_JALR =>

                    if (funct3 = F3_JALR) then
                        EXEC_JALR(rd => rd, rs1 => rs1, imm => imm_i, instr_pc => instr_pc, pc => pc, reg => reg);
                    else
                        assert FALSE
                            report "Illegal JALR funct3"
                            severity failure;
                    end if;

                -- System instructions (EBREAK is the lab stop)
                when OPCODE_SYSTEM =>

                    if (instr = INSTR_EBREAK) then
                        EXEC_EBREAK(execute => execute);
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

end architecture functional;
