
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;


entity incr_4_TB is
--  Port ( );
end incr_4_TB;

architecture Behavioral of incr_4_TB is

    COMPONENT incrementer_4
    GENERIC (data_bits: integer := 32);
    PORT(
        data_1   : IN std_logic_vector(data_bits-1 DOWNTO 0);
        data_2   : IN std_logic_vector(data_bits-1 DOWNTO 0);
        res_out  : OUT std_logic_vector(data_bits-1 DOWNTO 0)
    );
    END COMPONENT;
     -- Signals
    SIGNAL data_1   : std_logic_vector(31 DOWNTO 0);
    SIGNAL data_2   : std_logic_vector(31 DOWNTO 0);
    SIGNAL res_out  : std_logic_vector(31 DOWNTO 0);
    
begin
    uut: incrementer_4 
    PORT MAP( 
        data_1  => data_1,
        data_2  => data_2,
        res_out => res_out
    );
    
    process
    begin
    
          -- Test case 1: 5 + 3
        data_1 <= std_logic_vector(to_unsigned(5, 32));
        data_2 <= std_logic_vector(to_unsigned(3, 32));
        WAIT FOR 10 ns;
        
        -- Test case 2: 100 + 200
        data_1 <= std_logic_vector(to_unsigned(100, 32));
        data_2 <= std_logic_vector(to_unsigned(200, 32));
        WAIT FOR 10 ns;
        

        
        -- Test case 3: Zero + Zero
        data_1 <= (others => '0');
        data_2 <= (others => '0');
        WAIT FOR 10 ns;
        
        -- Test case 4: Large values addition
        data_1 <= std_logic_vector(to_unsigned(12345678, 32));
        data_2 <= std_logic_vector(to_unsigned(87654321, 32));
        WAIT FOR 10 ns;
        
        WAIT;
    
    end  process;
    

end Behavioral;
