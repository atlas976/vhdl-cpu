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


library IEEE;
use IEEE.numeric_bit.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM4096x12_tb is

    -- define testbench current address and data width
    Generic (
        data_width : positive range 1 to 12 := 12
    );
    
    -- port declarations
    Port ( 
        w_en : out bit;
        addr : out bit_vector (12 - 1 downto 0);
        dataToMem : out bit_vector (data_width - 1 downto 0);
        dataFromMem1 : in bit_vector (data_width - 1 downto 0);
        dataFromMem2 : in bit_vector (data_width - 1 downto 0)
    );
    -- const declaration
    constant mem_size : positive := 4096;
    constant addr_width : positive := 12;
end RAM4096x12_tb;



architecture Behavioral of RAM4096x12_tb is
    -- no components or internal signals
begin

    -- here is assumed that the testbench has to write all registers first
    -- before reading them. otherwise this could be done much easier.
    process
        variable dataFromMem1_C : natural := 0;
        variable dataFromMem2_C : natural := 0;
        
    begin
        w_en <= '0';
        wait for 1ns;
        
        -- write all registers
        for i in 0 to mem_size - 1 loop
            addr <= bit_vector(ieee.numeric_bit.to_unsigned(i, addr_width));
            dataToMem <= bit_vector(ieee.numeric_bit.to_unsigned(i, data_width));
            w_en <= '1';
                
            -- update signals
            wait for 1ns;
            w_en <= '0';
            wait for 1ns;
        end loop;
            
        -- wait until every write is totally done!
        wait for 10ns;
        
        -- read all registers and assert if they have the same values.
        for i in 0 to mem_size - 1 loop
            addr <= bit_vector(ieee.numeric_bit.to_unsigned(i, addr_width));
            wait for 1ns;
            dataFromMem1_C := to_integer(unsigned(dataFromMem1));
            dataFromMem2_C := to_integer(unsigned(dataFromMem2));
            assert dataFromMem2_C = dataFromMem1_C
                report "Memory mismatch at adress " &integer'image(i)
                severity error;
            -- mod is needed here otherwise the generic data_width could
            -- falsify this assertion.
            assert dataFromMem1_C = i mod (2**data_width)
                report "Memory error at address " & integer'image(i)
                    & " | Expected: " & integer'image(i mod (2**data_width))
                    & " | Actual: " & integer'image(dataFromMem1_C)
                severity error;
        end loop;
            
        -- all test done, remain here if no errors where detected.
        report "Memory test completed" severity note;
        wait;
    end process;

end Behavioral;









