
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity non_arch_r_reset is
    generic (N: integer:=32 );
    
    Port ( 
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (N-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (N-1 downto 0));
end non_arch_r_reset;

architecture Behavioral of non_arch_r_reset is

begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET='1' then 
                data_out<=(others=>'0');
            else
                data_out<=data_in;
            end if;
       end if;
       
    end process;


end Behavioral;

