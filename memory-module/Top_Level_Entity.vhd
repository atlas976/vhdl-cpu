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
--                  3. Configuration
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

entity ram4096x12_top is
    -- Flexibilization of interfaces by const. and generics
    generic (
        addr_width : positive range 1 to 31 := 12;
        data_width : positive range 1 to 31 := 12
    );
end entity ram4096x12_top;

-- structural design, "wire up" existing components

architecture structural of ram4096x12_top is

    -- declare components (list of "building blocks" for structural design)
    component ram4096x12_test is
        generic (
            addr_width : positive range 1 to 31;
            data_width : positive range 1 to 31
        );
        port (
            w_en         : out   bit;
            addr         : out   bit_vector(addr_width - 1 downto 0);
            datatomem    : out   bit_vector(data_width - 1 downto 0);
            datafrommem1 : in    bit_vector(data_width - 1 downto 0);
            datafrommem2 : in    bit_vector(data_width - 1 downto 0)
        );
    end component ram4096x12_test;

    component ram4096x12 is
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
    end component ram4096x12;

    component ram4096x12a is
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
    end component ram4096x12a;

    -- signals ("wires" to connect components)
    signal w_en         : bit;
    signal addr         : bit_vector(addr_width - 1 downto 0);
    signal datatomem    : bit_vector(data_width - 1 downto 0);
    signal datafrommem1 : bit_vector(data_width - 1 downto 0);
    signal datafrommem2 : bit_vector(data_width - 1 downto 0);

-- start of actual structural design ("building")

begin

    -- instantiation: connect ports of components with signals (port => signal)
    tb : component ram4096x12_test
        generic map (
            addr_width => addr_width,
            data_width => data_width
        )
        port map (
            w_en         => w_en,
            addr         => addr,
            datatomem    => datatomem,
            datafrommem1 => datafrommem1,
            datafrommem2 => datafrommem2
        );

    uut1 : component ram4096x12
        generic map (
            addr_width => addr_width,
            data_width => data_width
        )
        port map (
            w_en     => w_en,
            addr     => addr,
            data_in  => datatomem,
            data_out => datafrommem1
        );

    uut2 : component ram4096x12a
        generic map (
            addr_width => addr_width,
            data_width => data_width
        )
        port map (
            w_en     => w_en,
            addr     => addr,
            data_in  => datatomem,
            data_out => datafrommem2
        );

end architecture structural;

-- configuration: explicit link to architecture
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
