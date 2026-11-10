----------------------------------------------------------------------------------
-- Engineer: Lorenz Palmarini
-- 
-- Create Date: 03.11.2026 16:12:46
-- Design Name: UUT1
-- Module Name: RAM4096x12 - Behavioral
-- Project Name: Memory Model
-- Description:  1. Memory Model with 12-dimensional Index
--                  1. Entity Declaration
--                  2. Architecture Body
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


entity RAM4096x12 is

-- Flexibilization of interfaces by const. and generics
    generic (addr_width : positive range 1 to 31 := 12; 
             data_width : positive := 12);
             
-- physical connections
    Port  (w_en : in bit;
           addr : in bit_vector(addr_width-1 downto 0);
           data_in : in bit_vector(data_width-1 downto 0);
           data_out : out bit_vector(data_width-1 downto 0));
           
end RAM4096x12;


architecture Behavioral of RAM4096x12 is
begin

-- sequential statement
    process(w_en, addr, data_in) --trigger: w_en, addr, data_in 
    
-- local variable
        type mem_type is array (bit,bit,bit,bit,bit,bit,
                                bit,bit,bit,bit,bit,bit) of bit_vector( data_width-1 downto 0 ); --12-D Matrix (2^12=4096 fields storing a bit_vector)
        variable Mem : mem_type;
        
    begin
    
-- writing process (w_en = '1')
        if w_en = '1' then
            Mem(addr(11),addr(10),addr(9),
                addr(8),addr(7),addr(6),
                addr(5),addr(4),addr(3),
                addr(2),addr(1),addr(0)) := data_in; --immediate assignment (:=), 12-D Matrix access with 12 single coords. for every dimension
        end if;
        
-- reading process (always)
        data_out <= Mem(addr(11),addr(10),addr(9),
                      addr(8),addr(7),addr(6),
                      addr(5),addr(4),addr(3),
                      addr(2),addr(1),addr(0)); --delayed assignment (<=) at the end of current simulation delta cycle
    end process;
end Behavioral;
