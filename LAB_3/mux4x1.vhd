LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux4x1generic IS
    GENERIC (WIDTH : INTEGER := 6);
    PORT (
        in0      : IN  STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        in1      : IN  STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        in2      : IN  STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        in3      : IN  STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
        sel      : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0)
    );
END mux4x1generic;

ARCHITECTURE behavioral OF mux4x1generic IS
BEGIN

    WITH sel SELECT
        data_out <= in0 WHEN "00",
                     in1 WHEN "01",
                     in2 WHEN "10",
                     in3 WHEN OTHERS;

END behavioral;