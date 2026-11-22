----------------------------------------------------------------------------------
-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------
library ieee;
    use ieee.numeric_bit.all;
----------------------------------------------------------------------------------

-- Implementation: ---------------------------------------------------------------
entity riscv is
end entity riscv;

use work.constants_pack.all;
--!!! add other packages here later.

architecture functional of riscv is
begin
    process
    
        --!!! add range later here
    
        variable Memory  : mem_type := init_memory_empty;
        variable Reg     : reg_type := (others => (others => '0'));
        variable Instr   : instr_type := (others => '0');
        variable OP      : opcode_type := (others => '0');
        variable rd, rs1, rs2, shamt : reg_addr_type := (others => '0');
        variable funct3  : funct3_type := (others => '0');
        variable funct7  : funct7_type := (others => '0');
        variable imm_i, imm_s, imm_b, imm_j : integer := 0;
        variable imm_u   : data_type := (others => '0');
        variable PC, instr_pc : natural := 0;
        variable Zero, Carry, Negative, Overflow : boolean := FALSE;
        variable execute : boolean := TRUE;
    begin
        while execute loop
            -- Fetch: PC is a BYTE address, Memory has 32-bit words.
            instr_pc := PC;
            Instr := Memory(PC / INSTR_BYTES);
            OP := Instr(6 downto 0);
            rd := Instr(11 downto 7);
            rs1 := Instr(19 downto 15);
            rs2 := Instr(24 downto 20);
            funct3 := Instr(14 downto 12);
            funct7 := Instr(31 downto 25);
            imm_i := to_integer(signed(Instr(31 downto 20)));
            imm_s := to_integer(signed(Instr(31 downto 25) & Instr(11 downto 7)));
            imm_b := to_integer(signed(Instr(31) & Instr(7) & Instr(30 downto 25) & Instr(11 downto 8) & '0')); 
            imm_u := Instr(31 downto 12) & X"000";
            imm_j := to_integer(signed(Instr(31) & Instr(19 downto 12) & Instr(20) & Instr(30 downto 21) & '0')); 
            shamt := Instr(24 downto 20);
            PC := PC + INSTR_BYTES;

            -- Decode and execute
            case OP is
                -- Loads (I-Type)
                when OPCODE_LOAD =>
                    case funct3 is
                        when F3_LB =>
                            EXEC_LB(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Memory => Memory);
                        when F3_LH =>
                            EXEC_LH(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Memory => Memory);
                        when F3_LW =>
                            EXEC_LW(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Memory => Memory);
                        when F3_LBU =>
                            EXEC_LBU(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Memory => Memory);
                        when F3_LHU =>
                            EXEC_LHU(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Memory => Memory);
                        when others =>
                            assert FALSE report "Illegal LOAD funct3" severity failure;
                    end case;

                -- Stores (S-Type)
                when OPCODE_STORE =>
                    case funct3 is
                        when F3_SB =>
                            EXEC_SB(RS1 => rs1, RS2 => rs2, IMM => imm_s, Reg => Reg, Memory => Memory);
                        when F3_SH =>
                            EXEC_SH(RS1 => rs1, RS2 => rs2, IMM => imm_s, Reg => Reg, Memory => Memory);
                        when F3_SW =>
                            EXEC_SW(RS1 => rs1, RS2 => rs2, IMM => imm_s, Reg => Reg, Memory => Memory);
                        when others =>
                            assert FALSE report "Illegal STORE funct3" severity failure;
                    end case;

                -- Register-register operations (R-Type)
                when OPCODE_OP =>
                    case funct3 is
                        when F3_ADD_SUB =>
                            case funct7 is
                                when F7_BASE =>
                                    EXEC_ADD(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                                when F7_SUB_SRA =>
                                    EXEC_SUB(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                                when others =>
                                    assert FALSE report "Illegal ADD/SUB funct7" severity failure;
                            end case;
                        when F3_SRL_SRA =>
                            case funct7 is
                                when F7_BASE =>
                                    EXEC_SRL(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                                when F7_SUB_SRA =>
                                    EXEC_SRA(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                                when others =>
                                    assert FALSE report "Illegal SRL/SRA funct7" severity failure;
                            end case;
                        when F3_SLL =>
                            if funct7 = F7_BASE then
                                EXEC_SLL(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            else
                                assert FALSE report "Illegal SLL funct7" severity failure;
                            end if;
                        when F3_SLT =>
                            if funct7 = F7_BASE then
                                EXEC_SLT(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            else
                                assert FALSE report "Illegal SLT funct7" severity failure;
                            end if;
                        when F3_SLTU =>
                            if funct7 = F7_BASE then
                                EXEC_SLTU(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            else
                                assert FALSE report "Illegal SLTU funct7" severity failure;
                            end if;
                        when F3_XOR =>
                            if funct7 = F7_BASE then
                                EXEC_XOR(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            else
                                assert FALSE report "Illegal XOR funct7" severity failure;
                            end if;
                        when F3_OR =>
                            if funct7 = F7_BASE then
                                EXEC_OR(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            else
                                assert FALSE report "Illegal OR funct7" severity failure;
                            end if;
                        when F3_AND =>
                            if funct7 = F7_BASE then
                                EXEC_AND(RD => rd, RS1 => rs1, RS2 => rs2, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            else
                                assert FALSE report "Illegal AND funct7" severity failure;
                            end if;
                        when others =>
                            assert FALSE report "Illegal OP funct3" severity failure;
                    end case;

                -- Register-immediate operations (I-Type)
                when OPCODE_OP_IMM =>
                    if Instr = INSTR_NOP then
                        null;  -- NOP is ADDI x0, x0, 0
                    else
                        case funct3 is
                            when F3_ADDI =>
                                EXEC_ADDI(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            when F3_SLTI =>
                                EXEC_SLTI(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            when F3_SLTIU =>
                                EXEC_SLTIU(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            when F3_XORI =>
                                EXEC_XORI(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            when F3_ORI =>
                                EXEC_ORI(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            when F3_ANDI =>
                                EXEC_ANDI(RD => rd, RS1 => rs1, IMM => imm_i, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                            when F3_SLLI =>
                                if funct7 = F7_BASE then
                                    EXEC_SLLI(RD => rd, RS1 => rs1, SHAMT => shamt, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                                else
                                    assert FALSE report "Illegal SLLI funct7" severity failure;
                                end if;
                            when F3_SRLI_SRAI =>
                                case funct7 is
                                    when F7_BASE =>
                                        EXEC_SRLI(RD => rd, RS1 => rs1, SHAMT => shamt, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                                    when F7_SUB_SRA =>
                                        EXEC_SRAI(RD => rd, RS1 => rs1, SHAMT => shamt, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);
                                    when others =>
                                        assert FALSE report "Illegal SRLI/SRAI funct7" severity failure;
                                end case;
                            when others =>
                                assert FALSE report "Illegal OP-IMM funct3" severity failure;
                        end case;
                    end if;

                -- Special operations (U-Type)
                when OPCODE_LUI =>
                    EXEC_LUI(RD => rd, IMM => imm_u, Reg => Reg);
                when OPCODE_AUIPC =>
                    EXEC_AUIPC(RD => rd, IMM => imm_u, Reg => Reg, Instr_PC => instr_pc);

                -- Branches (B-Type)
                when OPCODE_BRANCH =>
                    case funct3 is
                        when F3_BEQ =>
                            EXEC_BEQ(RS1 => rs1, RS2 => rs2, IMM => imm_b, Reg => Reg, Instr_PC => instr_pc, PC => PC);
                        when F3_BNE =>
                            EXEC_BNE(RS1 => rs1, RS2 => rs2, IMM => imm_b, Reg => Reg, Instr_PC => instr_pc, PC => PC);
                        when F3_BLT =>
                            EXEC_BLT(RS1 => rs1, RS2 => rs2, IMM => imm_b, Reg => Reg, Instr_PC => instr_pc, PC => PC);
                        when F3_BGE =>
                            EXEC_BGE(RS1 => rs1, RS2 => rs2, IMM => imm_b, Reg => Reg, Instr_PC => instr_pc, PC => PC);
                        when F3_BLTU =>
                            EXEC_BLTU(RS1 => rs1, RS2 => rs2, IMM => imm_b, Reg => Reg, Instr_PC => instr_pc, PC => PC);
                        when F3_BGEU =>
                            EXEC_BGEU(RS1 => rs1, RS2 => rs2, IMM => imm_b, Reg => Reg, Instr_PC => instr_pc, PC => PC);
                        when others =>
                            assert FALSE report "Illegal BRANCH funct3" severity failure;
                    end case;

                -- Jumps
                when OPCODE_JAL =>
                    EXEC_JAL(RD => rd, IMM => imm_j, Instr_PC => instr_pc, PC => PC, Reg => Reg);
                when OPCODE_JALR =>
                    if funct3 = F3_JALR then
                        EXEC_JALR(RD => rd, RS1 => rs1, IMM => imm_i, Instr_PC => instr_pc, PC => PC, Reg => Reg);
                    else
                        assert FALSE report "Illegal JALR funct3" severity failure;
                    end if;

                -- System instructions (EBREAK is the lab stop)
                when OPCODE_SYSTEM =>
                    if Instr = INSTR_EBREAK then
                        EXEC_EBREAK(EXECUTE => execute);
                    else
                        assert FALSE report "Illegal SYSTEM instruction" severity failure;
                    end if;

                when others =>
                    assert FALSE report "Illegal opcode" severity failure;
            end case;
        end loop;
        wait;
    end process;
end architecture functional;

