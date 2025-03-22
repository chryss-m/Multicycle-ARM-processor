

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity mux3_1_TB is
--  Port ( );
end mux3_1_TB;

architecture Behavioral of mux3_1_TB is
    COMPONENT mux_3_to_1
    GENERIC (N: integer := 32);
    PORT(
        selection : IN std_logic_vector(1 DOWNTO 0);
        in_0      : IN std_logic_vector(N-1 DOWNTO 0);
        in_1      : IN std_logic_vector(N-1 DOWNTO 0);
        in_2      : IN std_logic_vector(N-1 DOWNTO 0);
        result    : OUT std_logic_vector(N-1 DOWNTO 0)
    );
    END COMPONENT;
    
  
    SIGNAL selection : std_logic_vector(1 DOWNTO 0);
    SIGNAL in_0      : std_logic_vector(31 DOWNTO 0);
    SIGNAL in_1      : std_logic_vector(31 DOWNTO 0);
    SIGNAL in_2      : std_logic_vector(31 DOWNTO 0);
    SIGNAL result    : std_logic_vector(31 DOWNTO 0);

begin
    uut: mux_3_to_1 
    PORT MAP (
        selection => selection,
        in_0      => in_0,
        in_1      => in_1,
        in_2      => in_2,
        result    => result
    );
    
    process
    begin
     
        selection <= "00";
        in_0 <= X"0000000A"; 
        in_1 <= X"0000000F"; 
        in_2 <= X"00000014"; 
        WAIT FOR 10 ns;
       
        selection <= "01";
        WAIT FOR 10 ns;
        
        
        selection <= "10";
        WAIT FOR 10 ns;
        
       
        selection <= "11";
        WAIT FOR 10 ns;
        wait;
    end process;
    
end Behavioral;
