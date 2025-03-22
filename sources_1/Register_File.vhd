
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Register_File is
    generic (
           addr_bits: integer :=4;    --number of bits for the address
           data_bits: integer:=32     --number of bits for the data
           );
    
    Port ( 
           CLK : in STD_LOGIC;
           read_addr1: in STD_LOGIC_VECTOR(addr_bits-1 downto 0);       --address for the first read operation
           read_addr2: in STD_LOGIC_VECTOR(addr_bits-1 downto 0);       --address for the second read operation 
           
           write_en:in STD_LOGIC;                                       --enable signal 
           data_in: in STD_LOGIC_VECTOR(data_bits-1 downto 0);          --input for the write operation 
           write_address: in STD_LOGIC_VECTOR(addr_bits-1 downto 0);    --address for the writ operation 
           reg_special: in STD_LOGIC_VECTOR(data_bits-1 downto 0);      --R15 - program counter 
           data_out_1: out STD_LOGIC_VECTOR(data_bits-1 downto 0);      --first read data out
           data_out_2: out STD_LOGIC_VECTOR(data_bits-1 downto 0)       --second read data out 
    );
end Register_File;

architecture Behavioral of Register_File is
    
    type register_array is array (0 to 2**addr_bits-2) of STD_LOGIC_VECTOR(data_bits-1 downto 0);  --the array includes 15 elements 
    signal registers :register_array ; --physical storage for registers

begin
    --READ DATA PROCESS 
    process(read_addr1, read_addr2,reg_special)
    begin
   
        --First read address -if addr=1111 output the R15 value
        if read_addr1="1111" then
            data_out_1<=reg_special;
        else
            data_out_1<=registers(TO_INTEGER(unsigned(read_addr1))); --else output the value from the register array
        end if;    
        
        if read_addr2="1111" then
            data_out_2<=reg_special;
        else
            data_out_2<=registers(TO_INTEGER(unsigned(read_addr2)));
        end if;
    end process;
    
    --WRITE DATA PROCESS    
    process(CLK)
    begin
        if rising_edge(clk) then
        ---if the write enable is on and the address is not 1111 write tne data into the register array of the speciofic address
            if write_en = '1' and write_address /= "1111" then   
                registers(to_integer(unsigned(write_address))) <= data_in;
            end if;
        end if;
    end process;
end Behavioral;
