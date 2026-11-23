----------------------------------------------------------------------------------
-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

library std;
    use std.textio.all;

library work;
    use work.defs_pack.all;
    use work.mnemonic_pack.all;
    use work.constants_pack.all;

library ieee;
    use ieee.numeric_bit.all;

----------------------------------------------------------------------------------

-- Implementation: ---------------------------------------------------------------

package tracer_pack is

    procedure print_header (
        file f : text
    );

    procedure print_pc (
        l  : inout line;
        pc : natural
    );

    procedure print_cmd (
        l            : inout line;
        constant cmd : mnemonic_type;
        r1           : BusDataType;
        r2           : BusDataType;
        imm          : integer
    );

    procedure print_result (
        l      : inout line;
        file f : text;
        rd     : BusDataType
    );

    function int_to_hex (
        int : integer;
        width : natural
    ) return string;

end package tracer_pack;

package body tracer_pack is

    procedure print_header (
        file f : text
    ) is

        variable l : line;

    begin

        write(l, string'("PC  | Cmd    | R1  | R2  | Imm   | RD  "));
        writeline(f, l);
        write(l, string'("---------------------------------------"));
        writeline(f, l);

    end procedure print_header;

    procedure print_pc (
        l  : inout line;
        pc : natural
    ) is

    begin

        write(l, string'(int_to_hex(pc / instr_bytes, 3) & " | "));

    end procedure print_pc;

    procedure print_cmd (
        l            : inout line;
        constant cmd : mnemonic_type;
        r1           : BusDataType;
        r2           : BusDataType;
        imm          : integer
    ) is

        variable rs1, rs2 : string(1 to 8);

    begin

        rs1 := to_hex_string(r1);
        rs2 := to_hex_string(r2);
        write(l, string'(parse_mnemonic(cmd) & " | " & rs1(6 to 8) & " | ") & rs2(1 to 3) & " | " & int_to_hex(imm, 5) & " | ");

    end procedure print_cmd;

    procedure print_result (
        l      : inout line;
        file f : text;
        rd     : BusDataType
    ) is

        variable rd1 : string(1 to 8);

    begin

        rd1 := to_hex_string(rd);
        write(l, string'(rd1(6 to 8) & " "));
        writeline(f, l);

    end procedure print_result;

    -- Move to defs_pack

    function int_to_hex (
        int : integer;
        width : natural
    ) return string is

        variable hex : string(1 to width);
        variable v   : natural;

    begin

        v := int mod 16 ** width;

        if (width = 1) then

            case (int) is

                when 0 =>

                    return "0";

                when 1 =>

                    return "1";

                when 2 =>

                    return "2";

                when 3 =>

                    return "3";

                when 4 =>

                    return "4";

                when 5 =>

                    return "5";

                when 6 =>

                    return "6";

                when 7 =>

                    return "7";

                when 8 =>

                    return "8";

                when 9 =>

                    return "9";

                when 10 =>

                    return "A";

                when 11 =>

                    return "B";

                when 12 =>

                    return "C";

                when 13 =>

                    return "D";

                when 14 =>

                    return "E";

                when 15 =>

                    return "F";

                when others =>

                    return "0";

            end case;

        else
            hex := int_to_hex(v / 16, width - 1) & int_to_hex(v mod 16, 1);
        end if;

        return hex;

    end function int_to_hex;

end package body tracer_pack;

