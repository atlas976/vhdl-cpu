----------------------------------------------------------------------------------
-- Engineer: Lorenz Palmarini
--
-- Create Date: 03.11.2026 16:12:46
-- Design Name: TB
-- Module Name: RAM4096x12_TEST - TB
-- Project Name: Memory Model
-- Description:  3. Testbench as own Entity/Architecture Pair
--                  1. Entity Declaration
--                  2. Architecture Body
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: - The testbench takes care, that the value of the address of each memory
--                        cell is written to the cell. I.e. Cell with address 0 gets the value 0, Cell with
--                        address 1 gets the value 1, ... The memories are written in parallel
--                      - The testbench then reads the content from each memory address - i.e.
--                        dataFromMem1 and dataFromMem2 - and makes sure, that the two
--                        memories return the same value.
--                        It is important to wait for some ns before the values from the memories
--                        stabilize in simulation and can be compared.
--                      - This testbench is a simplified version of the complete testbench from the
--                        lecture
--
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_bit.all;

entity RAM4096x12_TEST is
    -- Flexibilization of interfaces by const. and generics
    generic (
        addr_width : positive range 1 to 31 := 12;
        data_width : positive range 1 to 31 := 12
    );
    -- physical connections
    port (
        w_en         : out   bit;
        addr         : out   bit_vector(addr_width - 1 downto 0);
        dataToMem    : out   bit_vector(data_width - 1 downto 0);
        dataFromMem1 : in    bit_vector(data_width - 1 downto 0);
        dataFromMem2 : in    bit_vector(data_width - 1 downto 0)
    );
end entity RAM4096x12_TEST;

architecture TB of RAM4096x12_TEST is

begin

    -- sequential statement
    process is
    begin

        -- writing loop (through every address)
        for k in 0 to 2 ** addr_width - 1 loop

            w_en      <= '1';
            addr      <= bit_vector(to_unsigned(k, addr_width));
            dataToMem <= bit_vector(to_unsigned(k, data_width));
            wait for 5 ns;
            w_en      <= '0';
            wait for 5 ns;

        end loop;

        -- reading loop (through every address)
        for k in 0 to 2 ** addr_width - 1 loop

            addr <= bit_vector(to_unsigned(k, addr_width));
            wait for 5 ns;
            assert dataFromMem1 = dataFromMem2
                report "different values at address " & integer'image(k)
                severity error;
            assert dataFromMem1 = bit_vector(to_unsigned(k, data_width))
                report "Mem1: wrong value at address " & integer'image(k)
                severity error;
            assert dataFromMem2 = bit_vector(to_unsigned(k, data_width))
                report "Mem2: wrong value at address " & integer'image(k)
                severity error;

        end loop;

        -- put process on hold after verification
        wait;

    end process;

end architecture TB;
