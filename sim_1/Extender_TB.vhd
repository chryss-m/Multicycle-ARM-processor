
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Extender_TB is
--  Port ( );
end Extender_TB;

architecture Behavioral of Extender_TB is

    COMPONENT Extender
    GENERIC (N: integer := 32);
    PORT(
        selection : IN std_logic;
        input     : IN std_logic_vector(23 DOWNTO 0);
        output    : OUT std_logic_vector(N-1 DOWNTO 0)
    );
    END COMPONENT;
    
    -- Signals
    SIGNAL selection : std_logic;
    SIGNAL input     : std_logic_vector(23 DOWNTO 0);
    SIGNAL output    : std_logic_vector(31 DOWNTO 0);

begin
    uut: Extender 
    PORT MAP (
        selection => selection,
        input     => input,
        output    => output
    );
    
    process
    begin
    
      -- Test case 1
        selection <= '0';
        input     <= "000000000000000000001111"; 
        WAIT FOR 10 ns;
        
      
        
        -- Test case 2
        selection <= '1';
        input     <= "111111111111111111111110";
        WAIT FOR 10 ns;
       
        WAIT;  
    
    end process;


end Behavioral;
