----------------------------------------------------------------------------------
-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

library ieee;
    use ieee.numeric_bit.all;
----------------------------------------------------------------------------------

-- Implementation: ---------------------------------------------------------------

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
    constant mem_size : positive range 1 to 4096 := 4096;
    constant addr_width : positive range 1 to 12 := 12;
end entity ram4096x12_tb;

architecture behavioral of ram4096x12_tb is

-- no components or internal signals

begin

    process is

        variable datafrommem1_c : natural range 0 to mem_size := 0;
        variable datafrommem2_c : natural range 0 to mem_size := 0;

    begin

        w_en <= '0';
        wait for 1 ns;

        -- write all registers
        for i in 0 to mem_size - 1 loop

            addr      <= bit_vector(to_unsigned(i, addr_width));
            datatomem <= bit_vector(to_unsigned(i, data_width));
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

            addr           <= bit_vector(to_unsigned(i, addr_width));
            wait for 1 ns;
            datafrommem1_c := to_integer(unsigned(datafrommem1));
            datafrommem2_c := to_integer(unsigned(datafrommem2));
            assert datafrommem2_c = datafrommem1_c
                report "Memory mismatch at adress " & integer'image(i)
                severity error;
            -- mod is needed here otherwise the generic data_width could
            -- falsify this assertion or would have to be constant.
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









