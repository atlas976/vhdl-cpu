----------------------------------------------------------------------------------
-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

library std;
    use std.textio.all;

library work;
    use work.defs_pack.all;
    use work.mnemonic_pack.all;
    use work.inst_encoding_pack.all;
    use work.constants_pack.all;

----------------------------------------------------------------------------------

-- Implementation: ---------------------------------------------------------------

package mem_pack is

    impure function init_memory (
        filename : string
    ) return mem_type;

    function init_memory_empty return mem_type;

    function to_mem_entry (
        mnemonic     : mnemonic_type;
        r1           : reg_type;
        r2           : reg_type;
        r3           : reg_type;
        imm          : integer;
        mnemonic_set : boolean;
        r1_set       : boolean;
        r2_set       : boolean;
        r3_set       : boolean;
        imm_set      : boolean
    ) return mem_data;

end package mem_pack;

package body mem_pack is

    impure function init_memory (
        filename : string
    ) return mem_type is

        file     f            : text open read_mode is filename;
        variable l            : line;
        variable mem          : mem_type;
        variable success      : boolean;
        variable i            : addr_type := 0;
        variable imm          : integer;
        variable imm_set      : boolean;
        variable r1           : reg_type;
        variable r2           : reg_type;
        variable r3           : reg_type;
        variable r1_set       : boolean;
        variable r2_set       : boolean;
        variable r3_set       : boolean;
        variable mnemonic     : mnemonic_type;
        variable mnemonic_set : boolean;
        variable v            : string(1 to 50);

    begin

        line_loop : loop

            exit when endfile(f);
            readline(f, l);
            success := TRUE;

            word_loop : while success loop

                read(l, v(1), success);
                next word_loop when not success;
                next word_loop when v(1) = ' ';

                if (v(1) = '@') then
                    read(l, v(1 to 5), success);
                    i := to_addr_type(v(1 to 5));
                    next line_loop;
                elsif (v(1) = '#') then
                    read(l, v(1 to 5), success);
                    imm     := to_imm(v(1 to 5));
                    imm_set := TRUE;
                elsif (v(1) = 'x') then
                    read(l, v(1 to 2), success);
                    if (r1_set) then
                        if (r2_set) then
                            r3     := to_reg_type(v(1 to 2));
                            r3_set := TRUE;
                        else
                            r2     := to_reg_type(v(1 to 2));
                            r2_set := TRUE;
                        end if;
                    else
                        r1     := to_reg_type(v(1 to 2));
                        r1_set := TRUE;
                    end if;
                else
                    read(l, v(2 to 6), success);
                    mnemonic     := to_mnemonic(v(1 to 6));
                    mnemonic_set := TRUE;
                end if;

            end loop;
            if mnemonic_set then 
                mem(i)       := to_mem_entry(mnemonic, r1, r2, r3, imm, mnemonic_set, r1_set, r2_set, r3_set, imm_set);
                exit line_loop when i = 2 ** MemoryAddrSize - 1;
                i            := i + 1;
                r1_set       := FALSE;
                r2_set       := FALSE;
                r3_set       := FALSE;
                mnemonic_set := FALSE;
                imm_set      := FALSE;
            end if;
        end loop;

        return mem;

    end function init_memory;

    function init_memory_empty return mem_type is

        variable mem : mem_type;
        variable i   : addr_type := 0;

    begin

        init_loop : loop

            mem(i) := (others => '0');
            exit init_loop when i = 2 ** MemoryAddrSize - 1;
            i      := i + 1;

        end loop;

        return mem;

    end function init_memory_empty;

    function to_mem_entry (
        mnemonic     : mnemonic_type;
        r1           : reg_type;
        r2           : reg_type;
        r3           : reg_type;
        imm          : integer;
        mnemonic_set : boolean;
        r1_set       : boolean;
        r2_set       : boolean;
        r3_set       : boolean;
        imm_set      : boolean
    ) return mem_data is

        variable entry : mem_data := (others => '0');

    begin

        if (mnemonic_set) then

            case (mnemonic) is

                when LB_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := lb_code(r1, r2, imm);
                    end if;

                when LBU_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := lbu_code(r1, r2, imm);
                    end if;

                when LH_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := lh_code(r1, r2, imm);
                    end if;

                when LHU_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := lhu_code(r1, r2, imm);
                    end if;

                when LW_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := lw_code(r1, r2, imm);
                    end if;

                when SB_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := sb_code(r1, r2, imm);
                    end if;

                when SH_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := sh_code(r1, r2, imm);
                    end if;

                when SW_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := sw_code(r1, r2, imm);
                    end if;

                when ADD_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := add_code(r1, r2, r3);
                    end if;

                when SUB_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := sub_code(r1, r2, r3);
                    end if;

                when ADDI_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := addi_code(r1, r2, imm);
                    end if;

                when LUI_mnemonic =>

                    if (r1_set and imm_set) then
                        entry := lui_code(r1, imm);
                    end if;

                when AUIPC_mnemonic =>

                    if (r1_set and imm_set) then
                        entry := auipc_code(r1, imm);
                    end if;

                when XOR_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := xor_code(r1, r2, r3);
                    end if;

                when OR_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := or_code(r1, r2, r3);
                    end if;

                when AND_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := and_code(r1, r2, r3);
                    end if;

                when XORI_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := xori_code(r1, r2, imm);
                    end if;

                when ORI_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := ori_code(r1, r2, imm);
                    end if;

                when ANDI_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := andi_code(r1, r2, imm);
                    end if;

                when SLL_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := sll_code(r1, r2, r3);
                    end if;

                when SRL_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := srl_code(r1, r2, r3);
                    end if;

                when SRA_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := sra_code(r1, r2, r3);
                    end if;

                when SLT_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := slt_code(r1, r2, r3);
                    end if;

                when SLTU_mnemonic =>

                    if (r1_set and r2_set and r3_set) then
                        entry := sltu_code(r1, r2, r3);
                    end if;

                when SLLI_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := slli_code(r1, r2, imm);
                    end if;

                when SRLI_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := srli_code(r1, r2, imm);
                    end if;

                when SLTI_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := slti_code(r1, r2, imm);
                    end if;

                when SLTIU_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := sltiu_code(r1, r2, imm);
                    end if;

                when SRAI_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := srai_code(r1, r2, imm);
                    end if;

                when BEQ_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := beq_code(r1, r2, imm);
                    end if;

                when BNE_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := bne_code(r1, r2, imm);
                    end if;

                when BLT_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := blt_code(r1, r2, imm);
                    end if;

                when BGE_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := bge_code(r1, r2, imm);
                    end if;

                when BLTU_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := bltu_code(r1, r2, imm);
                    end if;

                when BGEU_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := bgeu_code(r1, r2, imm);
                    end if;

                when JAL_mnemonic =>

                    if (r1_set and imm_set) then
                        entry := jal_code(r1, imm);
                    end if;

                when JALR_mnemonic =>

                    if (r1_set and imm_set and r2_set) then
                        entry := jalr_code(r1, r2, imm);
                    end if;

                when EBREAK_mnemonic =>

                    entry := ebreak_code;

                when others =>

            end case;

        end if;

        return entry;

    end function to_mem_entry;

end package body mem_pack;
