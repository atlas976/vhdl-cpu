
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
