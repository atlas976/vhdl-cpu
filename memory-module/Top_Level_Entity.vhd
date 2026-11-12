----------------------------------------------------------------------------------
-- Engineer: Lorenz Palmarini
--
-- Create Date: 03.11.2026 16:12:46
-- Design Name: RAM4096x12_TOP
-- Module Name: RAM4096x12_TOP - Structural
-- Project Name: Memory Model
-- Description:  4. Top Level Entity Instantiating and Connecting the 3 Models
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

library ieee;
  use ieee.std_logic_1164.all;

entity RAM4096x12_TOP is
  -- Flexibilization of interfaces by const. and generics
  generic (
    addr_width : positive range 1 to 31 := 12;
    data_width : positive range 1 to 31 := 12
  );
end entity RAM4096x12_TOP;

-- structural design, "wire up" existing components

architecture Structural of RAM4096x12_TOP is

  -- declare components (list of "building blocks" for structural design)
  component RAM4096x12_TEST is
    generic (
      addr_width : positive range 1 to 31;
      data_width : positive range 1 to 31
    );
    port (
      w_en         : out   bit;
      addr         : out   bit_vector(addr_width - 1 downto 0);
      dataToMem    : out   bit_vector(data_width - 1 downto 0);
      dataFromMem1 : in    bit_vector(data_width - 1 downto 0);
      dataFromMem2 : in    bit_vector(data_width - 1 downto 0)
    );
  end component RAM4096x12_TEST;

  component RAM4096x12 is
    generic (
      addr_width : positive range 1 to 31;
      data_width : positive range 1 to 31
    );
    port (
      w_en     : in    bit;
      addr     : in    bit_vector(addr_width - 1 downto 0);
      data_in  : in    bit_vector(data_width - 1 downto 0);
      data_out : out   bit_vector(data_width - 1 downto 0)
    );
  end component RAM4096x12;

  component RAM4096x12A is
    generic (
      addr_width : positive range 1 to 31;
      data_width : positive range 1 to 31
    );
    port (
      w_en     : in    bit;
      addr     : in    bit_vector(addr_width - 1 downto 0);
      data_in  : in    bit_vector(data_width - 1 downto 0);
      data_out : out   bit_vector(data_width - 1 downto 0)
    );
  end component RAM4096x12A;

  -- signals ("wires" to connect components)
  signal w_en         : bit;
  signal addr         : bit_vector(addr_width - 1 downto 0);
  signal dataToMem    : bit_vector(data_width - 1 downto 0);
  signal dataFromMem1 : bit_vector(data_width - 1 downto 0);
  signal dataFromMem2 : bit_vector(data_width - 1 downto 0);

-- start of actual structural design ("building")

begin

  -- instantiation: connect ports of components with signals (port => signal)
  TB : component RAM4096x12_TEST
    generic map (
      addr_width => addr_width,
      data_width => data_width
    )
    port map (
      w_en         => w_en,
      addr         => addr,
      dataToMem    => dataToMem,
      dataFromMem1 => dataFromMem1,
      dataFromMem2 => dataFromMem2
    );

  UUT1 : component RAM4096x12
    generic map (
      addr_width => addr_width,
      data_width => data_width
    )
    port map (
      w_en     => w_en,
      addr     => addr,
      data_in  => dataToMem,
      data_out => dataFromMem1
    );

  UUT2 : component RAM4096x12A
    generic map (
      addr_width => addr_width,
      data_width => data_width
    )
    port map (
      w_en     => w_en,
      addr     => addr,
      data_in  => dataToMem,
      data_out => dataFromMem2
    );

end architecture Structural;

-- configuration: explicit link to architecture (1 entity can have x architectures)
configuration RAM4096x12_TOP_Conf of RAM4096x12_TOP is
  for Structural

    for TB : RAM4096x12_TEST
      use entity work.RAM4096x12_TEST(TB);
    end for;

    for UUT1 : RAM4096x12
      use entity work.RAM4096x12(Behavioral);
    end for;

    for UUT2 : RAM4096x12A
      use entity work.RAM4096x12A(Behavioral);
    end for;

  end for;
end configuration RAM4096x12_TOP_Conf;
