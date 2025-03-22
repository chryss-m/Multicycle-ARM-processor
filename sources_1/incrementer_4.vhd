
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity incrementer_4 is
    generic (             
           data_bits: integer:=32
           );
           
    Port ( 
           data_1 : in STD_LOGIC_VECTOR (data_bits-1 downto 0);
           data_2 : in STD_LOGIC_VECTOR (data_bits-1 downto 0);
           res_out : out STD_LOGIC_VECTOR (data_bits-1 downto 0)
          );
end incrementer_4;

architecture dataflow of incrementer_4 is
    
begin
    
        res_out <= std_logic_vector(unsigned(data_1) + unsigned(data_2));
    
end architecture dataflow;