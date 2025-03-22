

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;


entity mux_2_to_1 is
    generic( N: integer :=32);
    
    Port ( selection : in STD_LOGIC;
           in_0 : in STD_LOGIC_VECTOR (N-1 downto 0);
           in_1 : in STD_LOGIC_VECTOR (N-1 downto 0);
           result : out STD_LOGIC_VECTOR (N-1 downto 0));
end mux_2_to_1;

architecture Behavioral of mux_2_to_1 is
begin
    process(in_0,in_1,selection)
    begin
        if selection='0' then 
            result<=in_0;
        elsif selection='1' then
            result<=in_1;
        else
            result<=(others=>'X');
        end if;
    end process;
end Behavioral;
