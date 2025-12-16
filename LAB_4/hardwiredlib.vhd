--FOTIS STAMATAKIS--
library ieee;
use ieee.std_logic_1164.all;
  
package hardwiredlib is

    constant INOP_IDX  : integer := 0;
    constant ILDAC_IDX : integer := 1;
    constant ISTAC_IDX : integer := 2;
	 constant IMVAC_IDX : integer := 3;  
    constant IMOVR_IDX : integer := 4;  
    constant IJUMP_IDX : integer := 5;  
    constant IJMPZ_IDX : integer := 6; 
    constant IJPNZ_IDX : integer := 7;  
    constant IADD_IDX  : integer := 8; 
    constant ISUB_IDX  : integer := 9;  
    constant IINAC_IDX : integer := 10;
    constant ICLAC_IDX : integer := 11; 
    constant IAND_IDX  : integer := 12; 
    constant IOR_IDX   : integer := 13; 
    constant IXOR_IDX  : integer := 14; 
    constant INOT_IDX  : integer := 15; 


    constant AR_LOAD : integer := 0;
    constant AR_INC  : integer := 1;
    constant PC_LOAD : integer := 2;
    constant PC_INC  : integer := 3;
    constant DR_LOAD : integer := 4;
    constant TR_LOAD : integer := 5;
    constant IR_LOAD : integer := 6;
    constant R_LOAD  : integer := 7;
    constant AC_LOAD : integer := 8;
    constant Z_LOAD  : integer := 9;
    constant READ_OP : integer := 10;
    constant WRITE_OP: integer := 11;
    constant MEM_BUS : integer := 12;
    constant BUS_MEM : integer := 13;
    constant PC_BUS  : integer := 14;
    constant DR_BUS  : integer := 15;
    constant TR_BUS  : integer := 16;
    constant R_BUS   : integer := 17;
    constant AC_BUS  : integer := 18;
    constant AND_OP  : integer := 19;
    constant OR_OP   : integer := 20;
    constant XOR_OP  : integer := 21;
    constant NOT_OP  : integer := 22;
    constant AC_INC  : integer := 23;
    constant AC_ZERO : integer := 24;
    constant PLUS_OP : integer := 25;
    constant MINUS_OP: integer := 26;

end package hardwiredlib;

package body hardwiredlib is
end package body hardwiredlib;

