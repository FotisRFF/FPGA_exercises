--FOTIS STAMATAKIS-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.hardwiredlib.all;

entity hardwired is
    port(
        ir    : in  std_logic_vector(3 downto 0);
        clock : in  std_logic;
        reset : in  std_logic;
        Z     : in  std_logic;
        mOPs  : out std_logic_vector(26 downto 0) 
    );
end hardwired;

architecture arc of hardwired is
    


    component instruction_decoder 
        port(
            Din  : in  std_logic_vector(3 downto 0);
            Dout : out std_logic_vector(15 downto 0)
        );
    end component;

    component state_decoder
        port(
            Din  : in  std_logic_vector(2 downto 0);
            Dout : out std_logic_vector(7 downto 0)
        );
    end component;

    component counter3
        port(
            clock : in  std_logic;
            rst   : in  std_logic;
            inc   : in  std_logic;
            count : out std_logic_vector(2 downto 0)
        );
    end component;
    
	 
	 signal IR_reg    : std_logic_vector(3 downto 0);
    signal instr_out : std_logic_vector(15 downto 0); 
    signal state_out : std_logic_vector(7 downto 0);  
    signal count     : std_logic_vector(2 downto 0);  
    signal inc, clr  : std_logic;
    signal mOPs_int  : std_logic_vector(26 downto 0);
    signal NOP, LDAC, STAC, MVAC, MOVR, JUMP, JMPZ, JPNZ, ADD, SUB, INAC, CLAC, IAND, IOR, IXOR, INOT : std_logic;
    signal FETCH1, FETCH2, FETCH3, NOP1 : std_logic;
    signal LDAC1, LDAC2, LDAC3, LDAC4, LDAC5 : std_logic;
    signal STAC1, STAC2, STAC3, STAC4, STAC5 : std_logic;
    signal MVAC1, MOVR1 : std_logic;
    signal JUMP1, JUMP2, JUMP3 : std_logic;
    signal JMPZY1, JMPZY2, JMPZY3, JMPZN1, JMPZN2 : std_logic;
    signal JPNZY1, JPNZY2, JPNZY3, JPNZN1, JPNZN2 : std_logic;
    signal ADD1, SUB1, INAC1, CLAC1, AND1, OR1, XOR1, NOT1 : std_logic;
    signal any_last_state : std_logic;

    alias t0 is state_out(0);
    alias t1 is state_out(1);
    alias t2 is state_out(2);
    alias t3 is state_out(3);
    alias t4 is state_out(4);
    alias t5 is state_out(5);
    alias t6 is state_out(6);
    alias t7 is state_out(7);

	 
begin
    
	 
	 	 process(clock)
    begin
        if rising_edge(clock) then
            if mOPs_int(IR_LOAD) = '1' then
                IR_reg <= ir; 
            end if;
        end if;
    end process;
    
	 
		U_Counter : counter3
				port map ( clock => clock, rst => clr, inc => inc, count => count );
        
		U_StateDecoder : state_decoder
				port map ( Din => count, Dout => state_out );
				
		U_InstructionDecoder : instruction_decoder
				port map ( Din => IR_reg, Dout => instr_out );
		  

    NOP  <= instr_out(0);  LDAC <= instr_out(1);  STAC <= instr_out(2);  MVAC <= instr_out(3);
    MOVR <= instr_out(4);  JUMP <= instr_out(5);  JMPZ <= instr_out(6);  JPNZ <= instr_out(7);
    ADD  <= instr_out(8);  SUB  <= instr_out(9);  INAC <= instr_out(10); CLAC <= instr_out(11);
    IAND <= instr_out(12); IOR  <= instr_out(13); IXOR <= instr_out(14); INOT <= instr_out(15);
    FETCH1 <= t0; FETCH2 <= t1; FETCH3 <= t2; 
    NOP1   <= NOP and t3;
    LDAC1  <= LDAC and t3; LDAC2 <= LDAC and t4; LDAC3 <= LDAC and t5; LDAC4 <= LDAC and t6; LDAC5 <= LDAC and t7;
    STAC1  <= STAC and t3; STAC2 <= STAC and t4; STAC3 <= STAC and t5; STAC4 <= STAC and t6; STAC5 <= STAC and t7;
    MVAC1  <= MVAC and t3; MOVR1 <= MOVR and t3;
    JUMP1  <= JUMP and t3; JUMP2 <= JUMP and t4; JUMP3 <= JUMP and t5;
    JMPZY1 <= JMPZ and Z and t3; JMPZY2 <= JMPZ and Z and t4; JMPZY3 <= JMPZ and Z and t5;
    JMPZN1 <= JMPZ and (not Z) and t3; JMPZN2 <= JMPZ and (not Z) and t4;
    JPNZY1 <= JPNZ and (not Z) and t3; JPNZY2 <= JPNZ and (not Z) and t4; JPNZY3 <= JPNZ and (not Z) and t5;
    JPNZN1 <= JPNZ and Z and t3; JPNZN2 <= JPNZ and Z and t4;
    ADD1   <= ADD and t3; SUB1 <= SUB and t3; INAC1 <= INAC and t3; CLAC1 <= CLAC and t3;
    AND1   <= IAND and t3; OR1 <= IOR and t3; XOR1 <= IXOR and t3; NOT1 <= INOT and t3;
	 any_last_state <= NOP1 or LDAC5 or STAC5 or MVAC1 or MOVR1 or JUMP3 or JMPZN2 or JMPZY3 or JPNZN2 or JPNZY3 or ADD1 or SUB1 or INAC1 or CLAC1 or AND1 or OR1 or XOR1 or NOT1;
    clr <= reset or any_last_state;
    inc <= not any_last_state;

process(FETCH1, FETCH2, FETCH3, LDAC1, LDAC2, LDAC3, LDAC4, LDAC5,
            STAC1, STAC2, STAC3, STAC4, STAC5, MVAC1, MOVR1, JUMP1, JUMP2, JUMP3,
            JMPZY1, JMPZY2, JMPZY3, JMPZN1, JMPZN2, JPNZY1, JPNZY2, JPNZY3, JPNZN1, JPNZN2,
            ADD1, SUB1, INAC1, CLAC1, AND1, OR1, XOR1, NOT1) 
    begin
        mOPs_int <= (others => '0');
        mOPs_int(AR_LOAD)  <= FETCH1 or FETCH3 or LDAC3 or STAC3; 
        mOPs_int(AR_INC)   <= LDAC1 or STAC1 or JMPZY1 or JPNZY1;
        mOPs_int(PC_LOAD)  <= JUMP3 or JMPZY3 or JPNZY3;
        mOPs_int(PC_INC)   <= FETCH2 or LDAC1 or LDAC2 or STAC1 or STAC2 or JMPZN1 or JMPZN2 or JPNZN1 or JPNZN2;
        mOPs_int(DR_LOAD)  <= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1 or STAC2 or STAC4 or JUMP1 or JUMP2 or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2;
        mOPs_int(TR_LOAD)  <= LDAC2 or STAC2 or JUMP2 or JMPZY2 or JPNZY2;
        mOPs_int(IR_LOAD)  <= FETCH3;
        mOPs_int(R_LOAD)   <= MVAC1;
        mOPs_int(AC_LOAD)  <= LDAC5 or MOVR1 or ADD1 or SUB1 or INAC1 or CLAC1 or AND1 or OR1 or XOR1 or NOT1;
        mOPs_int(Z_LOAD)   <= mOPs_int(AC_LOAD); 
        mOPs_int(READ_OP)  <= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1 or STAC2 or JUMP1 or JUMP2 or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2;
        mOPs_int(WRITE_OP) <= STAC5;
        mOPs_int(MEM_BUS)  <= mOPs_int(READ_OP); 
        mOPs_int(BUS_MEM)  <= STAC5;
        mOPs_int(PC_BUS)   <= FETCH1 or FETCH3;
        mOPs_int(DR_BUS)   <= LDAC2 or LDAC3 or LDAC5 or STAC2 or STAC3 or STAC5 or JUMP2 or JUMP3 or JMPZY2 or JMPZY3 or JPNZY2 or JPNZY3;
        mOPs_int(TR_BUS)   <= LDAC3 or STAC3 or JUMP3 or JMPZY3 or JPNZY3;
        mOPs_int(R_BUS)    <= MOVR1 or ADD1 or SUB1 or AND1 or OR1 or XOR1;
        mOPs_int(AC_BUS)   <= STAC4 or MVAC1;
        mOPs_int(AND_OP)   <= AND1; 
        mOPs_int(OR_OP)    <= OR1; 
        mOPs_int(XOR_OP)   <= XOR1; 
        mOPs_int(NOT_OP)   <= NOT1; 
        mOPs_int(AC_INC)   <= INAC1; 
        mOPs_int(AC_ZERO)  <= CLAC1; 
        mOPs_int(PLUS_OP)  <= ADD1; 
        mOPs_int(MINUS_OP) <= SUB1; 
    end process;

    mOPs <= mOPs_int;

end arc;