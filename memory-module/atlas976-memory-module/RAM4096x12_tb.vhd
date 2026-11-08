----------------------------------------------------------------------------------
-- Company:
-- Engineer: Lukas Fuchs
--
-- Create Date: 08.11.2026 17:13:45
-- Design Name: RAM4096x12_tb
-- Module Name: RAM4096x12_tb - Behavioral
-- Project Name: memory-module

-- Description: implementation of memory module testbench
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

entity ram4096x12_tb is
    -- define testbench current address and data width
    generic (
        data_width : positive range 1 to 12 := 12
    );

    -- port declarations
    port (
        w_en         : out   bit;
        addr         : out   bit_vector (12 - 1 downto 0);
        datatomem    : out   bit_vector (data_width - 1 downto 0);
        datafrommem1 : in    bit_vector (data_width - 1 downto 0);
        datafrommem2 : in    bit_vector (data_width - 1 downto 0)
    );
    -- const declaration
    constant mem_size : positive   := 4096;
    constant addr_width : positive := 12;
end entity ram4096x12_tb;

architecture behavioral of ram4096x12_tb is

-- no components or internal signals

begin

    -- here is assumed that the testbench has to write all registers first
    -- before reading them. otherwise this could be done much easier.
    process is

        variable datafrommem1_c : natural := 0;
        variable datafrommem2_c : natural := 0;

    begin

        w_en <= '0';
        wait for 1 ns;

        -- write all registers
        for i in 0 to mem_size - 1 loop

            addr      <= bit_vector(ieee.numeric_bit.to_unsigned(i, addr_width));
            datatomem <= bit_vector(ieee.numeric_bit.to_unsigned(i, data_width));
            w_en      <= '1';

            -- update signals
            wait for 1 ns;
            w_en <= '0';
            wait for 1 ns;

        end loop;

        -- wait until every write is totally done!
        wait for 10 ns;

        -- read all registers and assert if they have the same values.
        for i in 0 to mem_size - 1 loop

            addr           <= bit_vector(ieee.numeric_bit.to_unsigned(i, addr_width));
            wait for 1 ns;
            datafrommem1_c := to_integer(unsigned(datafrommem1));
            datafrommem2_c := to_integer(unsigned(datafrommem2));
            assert datafrommem2_c = datafrommem1_c
                report "Memory mismatch at adress " & integer'image(i)
                severity error;
            -- mod is needed here otherwise the generic data_width could
            -- falsify this assertion.
            assert datafrommem1_c = i mod (2 ** data_width)
                report "Memory error at address " & integer'image(i)
                       & " | Expected: " & integer'image(i mod (2 ** data_width))
                       & " | Actual: " & integer'image(datafrommem1_c)
                severity error;

        end loop;

        -- all test done, remain here if no errors where detected.
        report "Memory test completed"
            severity note;
        wait;

    end process;

end architecture behavioral;









