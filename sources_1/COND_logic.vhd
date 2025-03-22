
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity COND_logic is
    Port ( 
           cond : in STD_LOGIC_VECTOR (3 downto 0);
           flags : in STD_LOGIC_VECTOR (3 downto 0);  --order: N,Z,C,V
           CondEx_in : out STD_LOGIC
           );
           
end COND_logic;

architecture Behavioral of COND_logic is

begin
    process(cond,flags)
    begin
        case cond is
            when "0000" =>                          --EQUAL
                CondEx_in<=flags(2);
                
            when "0001" =>                          --NOT EQUAL
                CondEx_in<=not flags(2);
            when "0010" =>                          --CARRY SET
                CondEx_in<=flags(1);
            when "0011" =>                          --CARRY CLEAR
                CondEx_in<=not flags(1);
            when "0100" =>                          --NEGATIVE
                CondEx_in<=flags(3);
            when "0101" =>                          --POSITIVE/ZERO
                CondEx_in<=not flags(3);
            when "0110" =>                          --OVERFLOW
                CondEx_in<=flags(0);    
            when "0111" =>                          --NO OVERFLOW
                CondEx_in<=not flags(0);    
            when "1000" =>                          --UNSIGNED HIGHER
                CondEx_in<= (not flags(2)) and flags(1);
            when "1001" =>                          --UNSIGNED LOWER/SAME
                CondEx_in<=flags(2) or (not flags(1));
            when "1010" =>                          --SIGNED GREATER/EQUAL
                CondEx_in<=not(flags(3) xor flags(0));
            when "1011" =>                          --SIGNED LESS
                CondEx_in<=flags(3) xor flags(0);
            when "1100" =>                          --SIGNED GREATER
                CondEx_in<=(not flags(2)) and (not (flags(3) xor flags(0)));
            when "1101" =>                          --SIGNED LESS/EQUAL
                CondEx_in<= flags(2) or (flags(3) xor flags(0));
            when "1110" =>                          --ALWAYS/UNCONDIOTIONAL
                CondEx_in<='1'; 
            when "1111" =>                          --FOR UNCONDITIONAL INSTRUCTIONS
                CondEx_in<='1';
            when others =>
                CondEx_in<='0';
            end case;
                                    
                
    end process;


end Behavioral;
