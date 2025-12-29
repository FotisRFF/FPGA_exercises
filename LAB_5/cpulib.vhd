library ieee;
use ieee.std_logic_1164.all;

package cpulib is


component alus
        port (
            rbus, acload, zload, andop, orop, notop, xorop, aczero, acinc, plus, minus, drbus  : in std_logic;
            alus : out std_logic_vector(6 downto 0)
        );
end component;

		
	 
component extRAM
        port (
            address : in std_logic_vector(7 downto 0);
            clock   : in std_logic;
            data    : in std_logic_vector(7 downto 0);
            wren    : in std_logic;
            q       : out std_logic_vector(7 downto 0)
        );
end component;

	 
	 
	 
component control_unit
        port (
            clock, reset : in std_logic;
            IR           : in std_logic_vector(7 downto 0);
            Z            : in std_logic;
            mOP          : out std_logic_vector(26 downto 0)
        );
    end component;

	 
	 
component data_bus
        port (
            AC_in, DR_in, R_in, TR_in, Mem_in : in std_logic_vector(7 downto 0);
            PC_in                             : in std_logic_vector(15 downto 0);
            sel                               : in std_logic_vector(6 downto 0); 
            bus_out                           : out std_logic_vector(7 downto 0)
        );
end component;

end cpulib;




