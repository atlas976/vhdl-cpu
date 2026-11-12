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

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_bit.all;

entity RAM4096x12A is
  -- Flexibilization of interfaces by const. and generics
  generic (
    addr_width : positive range 1 to 31 := 12;
    data_width : positive range 1 to 31 := 12
  );
  -- physical connections
  port (
    w_en     : in    bit;
    addr     : in    bit_vector(addr_width - 1 downto 0);
    data_in  : in    bit_vector(data_width - 1 downto 0);
    data_out : out   bit_vector(data_width - 1 downto 0)
  );
end entity RAM4096x12A;

architecture Behavioral of RAM4096x12A is

begin

  -- sequential statement
  process (w_en, addr, data_in) is

    -- local variables (array with 2^12 = 4096 entries storing a bit_vector)

    type mem_type is array (natural range 0 to 2 ** addr_width - 1) of bit_vector(data_width - 1 downto 0);

    variable Mem      : mem_type;
    variable addr_nat : natural range 0 to 2 ** addr_width - 1;

  begin

    -- converting bit_vector address to integer address
    addr_nat := to_integer(unsigned(addr));

    -- writing process (w_en = '1')
    if (w_en = '1') then
      Mem(addr_nat) := data_in;
    end if;

    -- reading process (always)
    data_out <= Mem(addr_nat);

  end process;

end architecture Behavioral;
