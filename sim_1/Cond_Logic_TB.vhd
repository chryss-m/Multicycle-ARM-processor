

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Cond_Logic_TB is
--  Port ( );
end Cond_Logic_TB;

architecture Behavioral of Cond_Logic_TB is

 -- COMPONENT DECLARATION
    component COND_logic
        Port ( 
            cond     : in  STD_LOGIC_VECTOR (3 downto 0);
            flags    : in  STD_LOGIC_VECTOR (3 downto 0);  
            CondEx_in : out STD_LOGIC
        );
    end component;
    
    --SIGNALS
    signal cond_tb     : STD_LOGIC_VECTOR (3 downto 0);
    signal flags_tb    : STD_LOGIC_VECTOR (3 downto 0);
    signal CondEx_in_tb : STD_LOGIC;

begin
    uut: COND_logic
        port map (
            cond     => cond_tb,
            flags    => flags_tb,
            CondEx_in => CondEx_in_tb
        );
    
    process
    begin       
        -- CASE: "EQUAL" (Z=1)
        cond_tb <= "0000"; flags_tb <= "0001"; wait for 10 ns; 
        cond_tb <= "0000"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "NOT EQUAL" (Z=0)
        cond_tb <= "0001"; flags_tb <= "0001"; wait for 10 ns;  
        cond_tb <= "0001"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "CARRY SET" (C=1)
        cond_tb <= "0010"; flags_tb <= "0010"; wait for 10 ns;  
        cond_tb <= "0010"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "CARRY CLEAR" (C=0)
        cond_tb <= "0011"; flags_tb <= "0010"; wait for 10 ns;  
        cond_tb <= "0011"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "NEGATIVE" (N=1)
        cond_tb <= "0100"; flags_tb <= "1000"; wait for 10 ns;  
        cond_tb <= "0100"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "POSITIVE/ZERO" (N=0)
        cond_tb <= "0101"; flags_tb <= "1000"; wait for 10 ns;  
        cond_tb <= "0101"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "OVERFLOW" (V=1)
        cond_tb <= "0110"; flags_tb <= "0001"; wait for 10 ns; 
        cond_tb <= "0110"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "NO OVERFLOW" (V=0)
        cond_tb <= "0111"; flags_tb <= "0001"; wait for 10 ns;  
        cond_tb <= "0111"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "UNSIGNED HIGHER" (~Z & C)
        cond_tb <= "1000"; flags_tb <= "0010"; wait for 10 ns;  
        cond_tb <= "1000"; flags_tb <= "0011"; wait for 10 ns;  
        
        -- CASE: "SIGNED GREATER/EQUAL" (~(N XOR V))
        cond_tb <= "1010"; flags_tb <= "1001"; wait for 10 ns;  
        cond_tb <= "1010"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "SIGNED LESS" (N XOR V)
        cond_tb <= "1011"; flags_tb <= "1000"; wait for 10 ns;  
        cond_tb <= "1011"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- CASE: "ALWAYS" (Unconditional)
        cond_tb <= "1110"; flags_tb <= "0000"; wait for 10 ns;  
        cond_tb <= "1111"; flags_tb <= "0000"; wait for 10 ns;  
        
        -- Τέλος Προσομοίωσης
        wait;
    end process;


end Behavioral;
