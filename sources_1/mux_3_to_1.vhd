
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity mux_3_to_1 is
    generic( N: integer :=32);
    
    Port ( selection:in std_logic_vector(1 downto 0);
           in_0 : in STD_LOGIC_VECTOR (N-1 downto 0);
           in_1 : in STD_LOGIC_VECTOR (N-1 downto 0);
           in_2 : in STD_LOGIC_VECTOR(N-1 downto 0);
           result : out STD_LOGIC_VECTOR (N-1 downto 0));
end mux_3_to_1;

architecture Behavioral of mux_3_to_1 is

begin
    process(in_0,in_1, in_2,selection)
    begin
        case selection is
            when "00" =>
                result<=in_0;
            when "11" =>
                result<=in_1;
            when "10" =>
                result<=in_2;
            when others=>
                result<=(others=>'X');
        end case;
    end process;
end Behavioral;
