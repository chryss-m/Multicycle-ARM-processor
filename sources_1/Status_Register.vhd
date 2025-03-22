
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Status_Register is
    generic (N: integer :=32);
    Port ( 
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           WE : in STD_LOGIC;
           sr_in:in std_logic_vector(N-1 downto 0);
           sr_out : out STD_LOGIC_VECTOR (N-1 downto 0));
end Status_Register;

architecture Behavioral of Status_Register is
    
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET='1' then
                sr_out <= (others => '0');
             elsif WE='1'  then
                sr_out<=sr_in;
             end if;
        end if;
    end process; 

    
end Behavioral;
