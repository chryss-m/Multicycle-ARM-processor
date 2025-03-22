
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Program_Counter is
    generic (  
           data_bits: integer:=32
           );
    Port ( 
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           write_en:in STD_LOGIC;
           data_in: in STD_LOGIC_VECTOR(data_bits-1 downto 0);
           data_out: out STD_LOGIC_VECTOR(data_bits-1 downto 0)          
          );
end Program_Counter;


architecture Behavioral of Program_Counter is

begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET='1' then
                data_out<=(others=>'0');
            elsif write_en='1' then
                data_out<=data_in;
            end if;
        end if;   
    end process;
end Behavioral;
