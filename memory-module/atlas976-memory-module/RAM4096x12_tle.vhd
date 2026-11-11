
library ieee;
    use ieee.numeric_bit.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity ram4096x12_tle is
    generic (
        data_width : positive range 1 to 12 := 12
    );
    -- no ports here
    -- constant declarations
    constant addr_width : positive := 12;
end entity ram4096x12_tle;

architecture structural of ram4096x12_tle is

    -- declare all connections
    signal w_en         : bit := '0';
    signal addr         : bit_vector (addr_width - 1 downto 0);
    signal datatomem    : bit_vector (data_width - 1 downto 0);
    signal datafrommem1 : bit_vector (data_width - 1 downto 0);
    signal datafrommem2 : bit_vector (data_width - 1 downto 0);

begin

    -- declare and connect all entities and the testbench with explicit architectures
    uut1 : entity work.ram4096x12(bit_implementation)
        generic map (
            data_width => data_width
        )
        port map (
            w_en     => w_en,
            addr     => addr,
            data_in  => datatomem,
            data_out => datafrommem1
        );

    uut2 : entity work.ram4096x12(int_implementation)
        generic map (
            data_width => data_width
        )
        port map (
            w_en     => w_en,
            addr     => addr,
            data_in  => datatomem,
            data_out => datafrommem2
        );

    tb : entity work.ram4096x12_tb
        generic map (
            data_width => data_width
        )
        port map (
            w_en         => w_en,
            addr         => addr,
            datatomem    => datatomem,
            datafrommem1 => datafrommem1,
            datafrommem2 => datafrommem2
        );

end architecture structural;

configuration config of ram4096x12_tle is
    for structural
    end for;
end config;
