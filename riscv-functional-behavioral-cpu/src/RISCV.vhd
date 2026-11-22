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

architecture functional of riscv is

begin
    process
    
    variable memory : mem_type := init_memory_empty; -- declare memory and initalise it
    
    variable reg : reg_type; -- declare registers and initialise them
    
    
    variable instr : data_type; -- declare instruction and initialise it
    variable OP : opcode_type; -- declare opcode and initialise it
    variable X, Y, Z : reg_addr_type; -- declare registers and initialise them
    variable PC : addr_type := 0; -- declare and init program counter
    variable Zero, Carry, Negative, Overflow : Boolean := FALSE; -- declare and init flags
    
    
    variable execute : Boolean := TRUE; -- boolean used to start/stop the program
begin
    while execute loop
        -- cmd fetch
        Instr := Memory(PC);
        OP := Instr / (2**reg_addr_width)**3;
        X := (Instr / (2**reg_addr_width)**2) mod 2**reg_addr_width;
        Y := (Instr / 2**reg_addr_width) mod 2**reg_addr_width;
        Z := Instr mod 2**reg_addr_width;
        PC := INC(PC);

        -- cmd decode
        case OP is
            -- load operations
            when opcode_lb | opcode_lbu | opcode_lh | opcode_lhu | opcode_lw =>
                case OP is
                    when opcode_lb =>
                        EXEC_LB(X => X, Y => Y, Z => Z, Reg => Reg, Memory => Memory);

                    when opcode_lbu =>
                        EXEC_LBU(X => X, Y => Y, Z => Z, Reg => Reg, Memory => Memory);

                    when opcode_lh =>
                        EXEC_LH(X => X, Y => Y, Z => Z, Reg => Reg, Memory => Memory);

                    when opcode_lhu =>
                        EXEC_LHU(X => X, Y => Y, Z => Z, Reg => Reg, Memory => Memory);

                    when opcode_lw =>
                        EXEC_LW(X => X, Y => Y, Z => Z, Reg => Reg, Memory => Memory);

                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- store operations
            when opcode_sb | opcode_sh | opcode_sw =>
                case OP is
                    when opcode_sb =>
                        EXEC_SB(X => X, Y => Y, Z => Z, Reg => Reg, Memory => Memory);

                    when opcode_sh =>
                        EXEC_SH(X => X, Y => Y, Z => Z, Reg => Reg, Memory => Memory);

                    when opcode_sw =>
                        EXEC_SW(X => X, Y => Y, Z => Z, Reg => Reg, Memory => Memory);

                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- arithmetic operations
            when opcode_add | opcode_addi | opcode_sub =>
                case OP is
                    when opcode_add =>
                        EXEC_ADD(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_addi =>
                        EXEC_ADDI(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_sub =>
                        EXEC_SUB(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- special operations
            when opcode_lui | opcode_auipc =>
                case OP is
                    when opcode_lui =>
                        EXEC_LUI(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when opcode_auipc =>
                        EXEC_AUIPC(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- logical operations
            when opcode_xor | opcode_xori | opcode_or | opcode_ori | opcode_and | opcode_andi =>
                case OP is
                    when opcode_xor =>
                        EXEC_XOR(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_xori =>
                        EXEC_XORI(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_or =>
                        EXEC_OR(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_ori =>
                        EXEC_ORI(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_and =>
                        EXEC_AND(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_andi =>
                        EXEC_ANDI(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- shift operations
            when opcode_sll | opcode_slli | opcode_srl | opcode_srli | opcode_sra | opcode_srai =>
                case OP is
                    when opcode_sll =>
                        EXEC_SLL(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_slli =>
                        EXEC_SLLI(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_srl =>
                        EXEC_SRL(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_srli =>
                        EXEC_SRLI(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_sra =>
                        EXEC_SRA(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_srai =>
                        EXEC_SRAI(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- compare operations
            when opcode_slt | opcode_sltu | opcode_slti | opcode_sltiu =>
                case OP is
                    when opcode_slt =>
                        EXEC_SLT(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_sltu =>
                        EXEC_SLTU(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_slti =>
                        EXEC_SLTI(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when opcode_sltiu =>
                        EXEC_SLTIU(X => X, Y => Y, Z => Z, Reg => Reg, Zero => Zero, Carry => Carry, Negative => Negative, Overflow => Overflow);

                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- branch operations
            when opcode_beq | opcode_bne | opcode_blt | opcode_bge | opcode_bltu | opcode_bgeu =>
                case OP is
                    when opcode_beq =>
                        EXEC_BEQ(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when opcode_bne =>
                        EXEC_BNE(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when opcode_blt =>
                        EXEC_BLT(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when opcode_bge =>
                        EXEC_BGE(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when opcode_bltu =>
                        EXEC_BLTU(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when opcode_bgeu =>
                        EXEC_BGEU(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- jump operations
            when opcode_jal | opcode_jalr =>
                case OP is
                    when opcode_jal =>
                        EXEC_JAL(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when opcode_jalr =>
                        EXEC_JALR(X => X, Y => Y, Z => Z, Reg => Reg, PC => PC);

                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- environment operations
            when opcode_stop | opcode_nop | opcode_ecall | opcode_ebreak =>
                case OP is
                    when opcode_nop =>
                        null;
                    when opcode_ebreak =>
                        EXEC_EBREAK(EXECUTE => execute);
                    when others =>
                        assert FALSE report "Illegal Operation" severity error;
                end case;

            -- illegal operations
            when others =>
                assert FALSE report "Illegal Operation" severity error;
        end case;
    end loop;
    wait;
end process;

end architecture functional;
