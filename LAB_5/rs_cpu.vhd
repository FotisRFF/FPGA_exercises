library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.cpulib.all; 

entity rs_cpu is
    port (
        ARdata, PCdata  : buffer std_logic_vector(15 downto 0); 
        DRdata, ACdata  : buffer std_logic_vector(7 downto 0);  
        IRdata, TRdata  : buffer std_logic_vector(7 downto 0);  
        RRdata         : buffer std_logic_vector(7 downto 0);  
        ZRdata         : buffer std_logic;                     
        clock, reset    : in std_logic;                         
        mOP            : buffer std_logic_vector(26 downto 0); 
        addressBus     : buffer std_logic_vector(15 downto 0); 
        dataBus        : buffer std_logic_vector(7 downto 0)   
    );
end rs_cpu;



architecture arc of rs_cpu is
    signal alu_ctrl_signals : std_logic_vector(6 downto 0);
    signal memory_out       : std_logic_vector(7 downto 0);
begin
 
		CONTROL: control_unit port map (
        clock => clock,
        reset => reset,
        IR    => IRdata,
        Z     => ZRdata,
        mOP   => mOP
    );
    ALU_CONTROL_UNIT: alus port map (
        rbus   => mOP(0),  -- rbus
        acload => mOP(1),  -- acload
        zload  => mOP(2),  -- zload
        andop  => mOP(3),  -- andop
        orop   => mOP(4),  -- orop
        notop  => mOP(5),  -- notop
        xorop  => mOP(6),  -- xorop
        aczero => mOP(7),  -- aczero
        acinc  => mOP(8),  -- acinc
        plus   => mOP(9),  -- plus
        minus  => mOP(10), -- minus
        drbus  => mOP(11), -- drbus
        alus   => alu_ctrl_signals
    );

    RAM_INST: extRAM port map (
        address => ARdata(7 downto 0), 
        clock   => clock,
        data    => dataBus,
        wren    => mOP(12), 
        q       => memory_out
    );


    dataBus <= ACdata     when mOP(13) = '1' else (others => 'Z');
    dataBus <= DRdata     when mOP(14) = '1' else (others => 'Z');
    dataBus <= RRdata     when mOP(15) = '1' else (others => 'Z');
    dataBus <= TRdata     when mOP(16) = '1' else (others => 'Z');
    dataBus <= memory_out when mOP(17) = '1' else (others => 'Z');
    dataBus <= PCdata(7 downto 0)  when mOP(18) = '1' else (others => 'Z');
    dataBus <= PCdata(15 downto 8) when mOP(19) = '1' else (others => 'Z');
    addressBus <= ARdata;


    process(clock, reset)
    begin
        if reset = '1' then
            ARdata <= (others => '0');
            PCdata <= (others => '0');
            DRdata <= (others => '0');
            ACdata <= (others => '0');
            IRdata <= (others => '0');
            TRdata <= (others => '0');
            RRdata <= (others => '0');
            ZRdata <= '0';
				
elsif rising_edge(clock) then
            if mOP(20) = '1' then ARdata <= PCdata; end if;      -- AR <- PC
            if mOP(21) = '1' then IRdata <= dataBus; end if;     -- IR <- Bus
            if mOP(22) = '1' then DRdata <= dataBus; end if;     -- DR <- Bus
            if mOP(23) = '1' then PCdata(7 downto 0) <= dataBus; end if;  -- PC Low byte
            if mOP(24) = '1' then PCdata(15 downto 8) <= dataBus; end if; -- PC High byte
            if mOP(25) = '1' then PCdata <= PCdata + 1; end if;           -- epomenh entolh
            if mOP(26) = '1' then TRdata <= dataBus; end if; 
				
				
				
            if mOP(1) = '1' then -- acload
                case alu_ctrl_signals is
                    when "1000000" => ACdata <= ACdata and DRdata;
                    when "1100000" => ACdata <= ACdata or DRdata;
                    when "1110000" => ACdata <= not ACdata;
                    when "1010000" => ACdata <= ACdata xor DRdata;
                    when "0000000" => ACdata <= (others => '0');
                    when "0001001" => ACdata <= ACdata + 1;
                    when "0000101" => ACdata <= ACdata + DRdata;
                    when "0000111" => ACdata <= ACdata - DRdata;
                    when "0000100" => ACdata <= RRdata;
                    when others    => null;
                end case;
            end if;

            if mOP(2) = '1' then -- zload
                if ACdata = "00000000" then ZRdata <= '1';
                else ZRdata <= '0';
                end if;
            end if;
        end if;
    end process;

end arc;