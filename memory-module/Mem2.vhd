----------------------------------------------------------------------------------
-- Engineer: Lorenz Palmarini
-- 
-- Create Date: 03.11.2026 16:12:46
-- Design Name: UUT2
-- Module Name: RAM4096x12A - Behavioral
-- Project Name: Memory Model
-- Description:  2. Memory Model with Integer Index
--                  1. Entity Declaration same as 1.a. - need not be re-modeled!
--                  2. Architecture Body (IEEE.numeric_bit.to_integer) shall be used
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;  --package needed for bit_vektor to integer & 'unsigned' type cast


entity RAM4096x12A is

-- Flexibilization of interfaces by const. and generics
    generic (addr_width : positive range 1 to 31 := 12; 
             data_width : positive := 12);
             
-- physical connections          
    Port ( w_en : in bit;
           addr : in bit_vector(addr_width-1 downto 0);
           data_in : in bit_vector(data_width-1 downto 0);
           data_out : out bit_vector(data_width-1 downto 0));
           
end RAM4096x12A;


architecture Behavioral of RAM4096x12A is
begin

-- sequential statement
    process(w_en, addr, data_in) --trigger: w_en, addr, data_in 
    
-- local variables
        type mem_type is array (natural range 0 to 2**addr_width-1) of bit_vector(data_width-1 downto 0); --array with 2^12=4096 entries storing a bit_vector
        variable Mem : mem_type;
        variable addr_nat : natural;
        
        
    begin
    
    -- converting bit_vector address to integer address
        addr_nat := TO_INTEGER(UNSIGNED(addr));
        
    -- writing process (w_en = '1')
        if w_en = '1' then
            Mem(addr_nat) := data_in; --immediate assignment (:=) Integer Index
        end if;
        
   -- reading process (always)
        data_out <= Mem(addr_nat); --delayed assignment (<=) at the end of current simulation delta cycle
        
    end process;
end Behavioral;

