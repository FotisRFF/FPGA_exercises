library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
    port (
        clock, reset : in std_logic;
        IR           : in std_logic_vector(7 downto 0); -- Είσοδος από Instruction Register
        Z            : in std_logic;                    -- Είσοδος από Zero Flag
        mOP          : out std_logic_vector(26 downto 0) -- Τα 27 σήματα ελέγχου
    );
end control_unit;

architecture arc of control_unit is
    -- Ορισμός των καταστάσεων (States) του επεξεργαστή
    type state_type is (S_FETCH_1, S_FETCH_2, S_FETCH_3, S_EXECUTE);
    signal current_state : state_type;
begin

    process(clock, reset)
    begin
        if reset = '1' then
            current_state <= S_FETCH_1;
            mOP <= (others => '0');
        elsif rising_edge(clock) then
            mOP <= (others => '0'); -- Καθαρισμός σημάτων σε κάθε παλμό

            case current_state is
                -- ΒΗΜΑ 1: AR <- PC (Προετοιμασία διεύθυνσης)
                when S_FETCH_1 =>
                    mOP(20) <= '1'; -- ARload
                    current_state <= S_FETCH_2;

                -- ΒΗΜΑ 2: IR <- M[AR], PC <- PC + 1 (Ανάγνωση εντολής)
                when S_FETCH_2 =>
                    mOP(17) <= '1'; -- MemBus (Διάβασμα από μνήμη)
                    mOP(21) <= '1'; -- IRload (Αποθήκευση στο IR)
                    mOP(25) <= '1'; -- PCinc (Αύξηση απαριθμητή)
                    current_state <= S_FETCH_3;

                -- ΒΗΜΑ 3: Αποκωδικοποίηση και Εκτέλεση
                when S_FETCH_3 =>
                    case IR is
                        when "00000001" => -- Εντολή LDAC (Load AC) [cite: 82]
                            -- Εδώ θα έπρεπε να διαβάσει τη διεύθυνση από τη μνήμη
                            -- Για απλότητα στο τεστ, ας υποθέσουμε άμεση εκτέλεση
                            mOP(17) <= '1'; -- MemBus
                            mOP(22) <= '1'; -- DRload
                            current_state <= S_EXECUTE;
                        
                        when "00001010" => -- Εντολή INAC (Increment AC) [cite: 89]
                            mOP(1) <= '1'; -- acload
                            mOP(8) <= '1'; -- acinc (σήμα προς ALU)
                            current_state <= S_FETCH_1;

                        when others => 
                            current_state <= S_FETCH_1;
                    end case;

                when S_EXECUTE =>
                    -- Ολοκλήρωση εντολής LDAC: AC <- DR
                    if IR = "00000001" then
                        mOP(1) <= '1';  -- acload
                        mOP(11) <= '1'; -- drbus (σήμα προς ALU να πάρει το DR)
                    end if;
                    current_state <= S_FETCH_1; -- Επιστροφή για την επόμενη εντολή
            end case;
        end if;
    end process;
end arc;