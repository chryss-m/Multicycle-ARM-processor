
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux2_1_TB is
--  Port ( );
end mux2_1_TB;

architecture Behavioral of mux2_1_TB is

  COMPONENT mux_2_to_1
    GENERIC (N: integer := 32);
    PORT(
        selection : IN std_logic;
        in_0      : IN std_logic_vector(N-1 DOWNTO 0);
        in_1      : IN std_logic_vector(N-1 DOWNTO 0);
        result    : OUT std_logic_vector(N-1 DOWNTO 0)
    );
    END COMPONENT;
    
   
    SIGNAL selection : std_logic;
    SIGNAL in_0      : std_logic_vector(31 DOWNTO 0);
    SIGNAL in_1      : std_logic_vector(31 DOWNTO 0);
    SIGNAL result    : std_logic_vector(31 DOWNTO 0);
    
begin
        uut: mux_2_to_1
        PORT MAP (
        selection => selection,
        in_0      => in_0,
        in_1      => in_1,
        result    => result
    );
    process
    begin
        
        selection <= '0';
        in_0 <= X"0000000A"; -- 10 in hex
        in_1 <= X"0000000F"; -- 15 in hex
        WAIT FOR 10 ns;
        
        
        selection <= '1';
        WAIT FOR 10 ns;
        
        
        selection <= '0';
        in_0 <= X"12345678";
        in_1 <= X"87654321";
        WAIT FOR 10 ns;
        
        
        selection <= '1';
        WAIT FOR 10 ns;
        
        WAIT;    end process;
    

end Behavioral;
