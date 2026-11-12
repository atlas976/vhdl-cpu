----------------------------------------------------------------------------------
-- Company:
-- Engineer: Lukas Fuchs
--
-- Create Date: 08.11.2026 17:13:45
-- Design Name: RAM4096x12
-- Module Name: RAM4096x12 - Int_Implementation - Bit_Implementation
-- Project Name: memory-module

-- Description: Implementation and declaration of memory module
--
-- Dependencies: IEEE.numeric_bit.all
--
-- Additional Comments: for vhdl lecture coursework
----------------------------------------------------------------------------------

library ieee;
    use ieee.numeric_bit.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

----------------------------------------------------------------------------------

entity ram4096x12 is
    -- define the current address and data width
    generic (
        data_width : positive range 1 to 12 := 12
    );
    -- port declarations
    port (
        w_en     : in    bit;
        addr     : in    bit_vector (12 - 1 downto 0);
        data_in  : in    bit_vector (data_width - 1 downto 0);
        data_out : out   bit_vector (data_width - 1 downto 0)
    );
    -- const declarations
    constant addr_width : positive := 12;
end entity ram4096x12;

architecture int_implementation of ram4096x12 is

-- no components or internal signals

begin

    -- behavioral description of the integer/natural memory behavior.
    process (w_en, addr, data_in) is

        -- declare memory for this module

        type mem_type_int is array
            (natural range 0 to 2 ** addr_width - 1)
            of
            bit_vector (data_width - 1 downto 0);

        -- declare memory and natural address
        variable mem      : mem_type_int;
        variable addr_nat : natural;

    begin

        -- actual memory logic
        addr_nat := to_integer(UNSIGNED(addr));

        if (w_en = '1') then
            mem(addr_nat) := data_in;
        end if;

        data_out <= mem(addr_nat);

    end process;

end architecture int_implementation;

architecture bit_implementation of ram4096x12 is

-- no components or internal signals

begin

    -- behavioral description of the bit memory behavior.
    process (w_en, addr, data_in) is

        -- declare memory for this module

        type mem_type_bit is array
            (bit, bit, bit, bit,
             bit, bit, bit, bit,
             bit, bit, bit, bit)
            of
            bit_vector (data_width - 1 downto 0);

        -- declare memory and natural address
        variable mem : mem_type_bit;

    begin

        -- actual memory logic
        if (w_en = '1') then
            mem(addr(11),addr(10),addr(9),addr(8),
            addr(7),addr(6),addr(5),addr(4),
            addr(3),addr(2),addr(1),addr(0)) := data_in;
        end if;

        data_out <= mem(addr(11), addr(10), addr(9), addr(8),
                        addr(7), addr(6), addr(5), addr(4),
                        addr(3), addr(2), addr(1), addr(0));

    end process;

end architecture bit_implementation;
