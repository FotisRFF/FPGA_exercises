LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE mseqlib IS

    -- 1. MUX 4x1 Component (mux4x1generic.vhd)
    COMPONENT mux4x1generic
        GENERIC (WIDTH : INTEGER := 6);
        PORT (
            in0, in1, in2, in3 : IN  STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
            sel                : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_out           : OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0)
        );
    END COMPONENT;

    -- 2. Register N-bit Component (regnbit.vhd)
    COMPONENT regnbit
        GENERIC (n: INTEGER := 6);
        PORT( 
            din : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            clk, rst, ld : IN STD_LOGIC;
            inc : IN STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mseq_rom 
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		data		: IN STD_LOGIC_VECTOR (35 DOWNTO 0);
		inclock		: IN STD_LOGIC  := '1';
		outclock		: IN STD_LOGIC ;
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (35 DOWNTO 0)
	);
END COMPONENT;

END mseqlib;