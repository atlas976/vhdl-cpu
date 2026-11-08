----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Lukas Fuchs
-- 
-- Create Date: 08.11.2026 17:13:45
-- Design Name: RAM4096x12_tle
-- Module Name: RAM4096x12_tle - Behavioral
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


entity RAM4096x12_tle is
    Generic (
        data_width : positive range 1 to 12 := 12
    );
    -- no ports here
    -- constant declarations
    constant addr_width : positive := 12;
end RAM4096x12_tle;



architecture Structural of RAM4096x12_tle is
    -- declare all connections
    signal w_en : bit := '0';
    signal addr : bit_vector (addr_width - 1 downto 0);
    signal dataToMem : bit_vector (data_width - 1 downto 0);
    signal dataFromMem1 : bit_vector (data_width - 1 downto 0);
    signal dataFromMem2 : bit_vector (data_width - 1 downto 0);
begin
    -- declare and connect all entities and the testbench with explicit architectures
    UUT1 : entity work.RAM4096x12(Bit_Implementation)
        generic map (data_width => data_width)
        port map (w_en => w_en, addr => addr, data_in => dataToMem, data_out => dataFromMem1);
        
    UUT2 : entity work.RAM4096x12(Int_Implementation)
        generic map (data_width => data_width)
        port map (w_en => w_en, addr => addr, data_in => dataToMem, data_out => dataFromMem2);

    TB : entity work.RAM4096x12_tb
        generic map (data_width => data_width)
        port map (w_en => w_en, addr => addr, dataToMem => dataToMem, dataFromMem1 => dataFromMem1, dataFromMem2 => dataFromMem2);
end Structural;
