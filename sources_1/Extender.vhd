

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Extender is
    generic( N: integer :=32);
    
    Port ( selection : in STD_LOGIC;     --ImmSrc
           input : in STD_LOGIC_VECTOR (23 downto 0);
           output : out STD_LOGIC_VECTOR (N-1 downto 0));
end Extender;

architecture Behavioral of Extender is

begin
    process (input, selection)
    begin
        case selection is
            when '0' =>
                -- 12 bit to 32bit - zeros extension 
                output<= std_logic_vector(resize (unsigned(input(11 downto 0)),N));
            when '1' =>
                output<=std_logic_vector(resize(signed(input)*4,N));
            when others =>
                output<= (others=>'0');
        end case;    
    
    end process;
end Behavioral;
