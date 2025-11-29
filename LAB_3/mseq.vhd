LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
LIBRARY lpm;
USE lpm.lpm_components.all; 
USE work.mseqlib.all;
ENTITY mseq IS
PORT( 
	ir			: IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
	clock, reset	: IN  STD_LOGIC ;
	z			: IN  STD_LOGIC ;
	code		: OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
	mOPs		: OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
);
END ENTITY mseq;

ARCHITECTURE arc OF mseq IS

    CONSTANT N_ADDR : INTEGER := 6;

    SIGNAL MPC_Q        : STD_LOGIC_VECTOR (N_ADDR - 1 DOWNTO 0);
    SIGNAL Next_Addr    : STD_LOGIC_VECTOR (N_ADDR - 1 DOWNTO 0);

    SIGNAL Micro_Inst   : STD_LOGIC_VECTOR (35 DOWNTO 0);

    SIGNAL MPC_Inc      : STD_LOGIC_VECTOR (N_ADDR - 1 DOWNTO 0);

    SIGNAL S_MUX : STD_LOGIC_VECTOR (1 DOWNTO 0);
    
    CONSTANT C_MAPPING_EN_BIT    : INTEGER := 33;
    CONSTANT C_COND_JUMP_BIT     : INTEGER := 34;
    CONSTANT C_SEQUENTIAL_JUMP_BIT : INTEGER := 35;
    
    CONSTANT C_JUMP_ADDR_1_MSB : INTEGER := 30;
    CONSTANT C_JUMP_ADDR_1_LSB : INTEGER := 25;
    
    CONSTANT C_JUMP_ADDR_2_MSB : INTEGER := 24;
    CONSTANT C_JUMP_ADDR_2_LSB : INTEGER := 19;
    
    SIGNAL Jump_Addr_1 : STD_LOGIC_VECTOR (N_ADDR - 1 DOWNTO 0);
    SIGNAL Jump_Addr_2 : STD_LOGIC_VECTOR (N_ADDR - 1 DOWNTO 0);
    SIGNAL IR_Map_Addr : STD_LOGIC_VECTOR (N_ADDR - 1 DOWNTO 0);

BEGIN

    Jump_Addr_1    <= Micro_Inst(C_JUMP_ADDR_1_MSB DOWNTO C_JUMP_ADDR_1_LSB);
    Jump_Addr_2    <= Micro_Inst(C_JUMP_ADDR_2_MSB DOWNTO C_JUMP_ADDR_2_LSB);

    IR_Map_Addr <= "00" & ir;

    MPC_Inc <= MPC_Q + '1'; 

    PROCESS (Micro_Inst, z)
    BEGIN
        S_MUX <= "00";

        IF Micro_Inst(C_MAPPING_EN_BIT) = '1' THEN
            S_MUX <= "11";
        
        ELSIF Micro_Inst(C_SEQUENTIAL_JUMP_BIT) = '1' THEN
            
            IF Micro_Inst(C_COND_JUMP_BIT) = '0' THEN
                S_MUX <= "01"; 
            ELSE
                S_MUX <= "10";
            END IF;
            
        ELSIF Micro_Inst(C_COND_JUMP_BIT) = '1' THEN
            IF z = '1' THEN
                S_MUX <= "01";
            ELSE
                S_MUX <= "00";
            END IF;
            
        END IF;
        
    END PROCESS;
    
    MPC_REGISTER : ENTITY work.regnbit
        GENERIC MAP (N => N_ADDR)
        PORT MAP (
            din   => Next_Addr,
            clk   => clock,      
            rst   => reset,      
            ld    => '1',
            inc   => '0',
            dout  => MPC_Q
        );

    NEXT_ADDRESS_MUX : ENTITY work.mux4x1generic
        GENERIC MAP (WIDTH => N_ADDR)
        PORT MAP (
            in0   => MPC_Inc,
            in1   => Jump_Addr_1,
            in2   => Jump_Addr_2,
            in3   => IR_Map_Addr,
            sel   => S_MUX,
            data_out => Next_Addr
        );

    MICROCODE_ROM : ENTITY work.mseq_rom
    PORT MAP (
        address  => MPC_Q,
        data     => (OTHERS => '0'),
        inclock  => clock,                
        outclock => clock,                
        wren     => '0',
        q        => Micro_Inst
    );

    code <= Micro_Inst;
    mOPs <= Micro_Inst(26 DOWNTO 0);


END ARCHITECTURE arc;