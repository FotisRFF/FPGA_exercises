library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
    port (
        clock, reset : in std_logic;
        IR           : in std_logic_vector(7 downto 0); 
        Z            : in std_logic;                    
        mOP          : out std_logic_vector(26 downto 0) 
    );
end control_unit;

architecture arc of control_unit is
    
    type state_type is (S_FETCH_1, S_FETCH_2, S_FETCH_3, S_EXECUTE);
    signal current_state : state_type;
begin

    process(clock, reset)
    begin
        if reset = '1' then
            current_state <= S_FETCH_1;
            mOP <= (others => '0');
        elsif rising_edge(clock) then
            mOP <= (others => '0'); 

            case current_state is
                
                when S_FETCH_1 =>
                    mOP(20) <= '1';
                    current_state <= S_FETCH_2;

                
                when S_FETCH_2 =>
                    mOP(17) <= '1'; 
                    mOP(21) <= '1'; 
                    mOP(25) <= '1'; 
                    current_state <= S_FETCH_3;

                
                when S_FETCH_3 =>
                    case IR is
                        when "00000001" => 
                            mOP(17) <= '1'; 
                            mOP(22) <= '1'; 
                            current_state <= S_EXECUTE;
                        
                        when "00001010" => 
                            mOP(1) <= '1'; 
                            mOP(8) <= '1'; 
                            current_state <= S_FETCH_1;

                        when others => 
                            current_state <= S_FETCH_1;
                    end case;

                when S_EXECUTE =>
                   
                    if IR = "00000001" then
                        mOP(1) <= '1';  
                        mOP(11) <= '1'; 
                    end if;
                    current_state <= S_FETCH_1;
            end case;
        end if;
    end process;
end arc;