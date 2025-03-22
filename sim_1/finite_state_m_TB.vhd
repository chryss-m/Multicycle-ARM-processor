library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity finite_state_m_TB is
end finite_state_m_TB;

architecture testbench of finite_state_m_TB is

    -- Σήματα για το FSM
    signal CLK         : std_logic := '0';
    signal RESET       : std_logic := '0';
    signal op          : std_logic_vector(1 downto 0) := "00";
    signal S           : std_logic := '0';
    signal B_BL_in     : std_logic := '0';
    signal Rd          : std_logic_vector(3 downto 0) := "0000";
    signal NoWrite_in  : std_logic := '0';
    signal CondEx_in   : std_logic := '0';
    
    
    signal IRWrite     : std_logic;
    signal RegWrite    : std_logic;
    signal MAWrite     : std_logic;
    signal MemWrite    : std_logic;
    signal FlagsWrite  : std_logic;
    signal PCSrc       : std_logic_vector(1 downto 0);
    signal PCWrite     : std_logic;

    
    constant CLK_PERIOD : time := 10 ns;

begin

    
    uut: entity work.FSM
        port map (
            CLK        => CLK,
            RESET      => RESET,
            op         => op,
            S          => S,
            B_BL_in    => B_BL_in,
            Rd         => Rd,
            NoWrite_in => NoWrite_in,
            CondEx_in  => CondEx_in,
            IRWrite    => IRWrite,
            RegWrite   => RegWrite,
            MAWrite    => MAWrite,
            MemWrite   => MemWrite,
            FlagsWrite => FlagsWrite,
            PCSrc      => PCSrc,
            PCWrite    => PCWrite
        );

   
    process
    begin
        while now < 200 ns loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    
    process
    begin
        
        RESET <= '1';
        wait for 2 * CLK_PERIOD;
        RESET <= '0';
        wait for CLK_PERIOD;

        -- 1:  Data Processing (no CMP)
        op <= "00"; NoWrite_in <= '0'; CondEx_in <= '1'; S <= '0'; Rd <= "0001";
        wait for CLK_PERIOD;

        -- 2: ΕCMP
        NoWrite_in <= '1';
        wait for CLK_PERIOD;

        -- 3: LDR
        op <= "01"; S <= '1';
        wait for CLK_PERIOD;

        -- 4:  STR
        S <= '0';
        wait for CLK_PERIOD;

        --  5:  B
        op <= "10"; B_BL_in <= '0';
        wait for CLK_PERIOD;

        --  6:  BL
        B_BL_in <= '1';
        wait for CLK_PERIOD;

        
        wait;
    end process;

end testbench;
