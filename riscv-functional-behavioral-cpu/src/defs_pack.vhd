----------------------------------------------------------------------------------
-- Engineers: Lukas Fuchs, Aurel Schneider, Lorenz Palmarini, Felix Weißleder
----------------------------------------------------------------------------------

-- Libraries: --------------------------------------------------------------------

----------------------------------------------------------------------------------

-- Implementation: ---------------------------------------------------------------
package defs_pack is

    constant busdatasize : integer := 32;

    constant regaddrsize : integer := 5;

    subtype func3type is bit_vector(2 downto 0);

    subtype func7type is bit_vector(6 downto 0);

    subtype optype is bit_vector(6 downto 0);

    subtype reg_type is bit_vector(regaddrsize - 1 downto 0);

    subtype busdatatype is bit_vector(busdatasize - 1 downto 0);

end package defs_pack;

package body defs_pack is

end package body defs_pack;
