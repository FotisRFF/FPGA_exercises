--FOTIS STAMATAKIS--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter3 is
    port(
        clock : in  std_logic;
        rst   : in  std_logic;
        inc   : in  std_logic;
        count : out std_logic_vector(2 downto 0)
    );
end counter3;

    


architecture rtl of counter3 is
    signal cnt : std_logic_vector(2 downto 0);
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if rst = '1' then
                cnt <= "000";
            elsif inc = '1' then
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    count <= cnt;
end rtl;
