
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Instruction_Memory is
    generic(
        addr_bits: integer :=6;
        data_bits: integer :=32
        );
    
    Port(
        address_input: STD_LOGIC_VECTOR(addr_bits-1 downto 0);
        output: out STD_LOGIC_VECTOR (data_bits-1 downto 0)
        );
        
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
    type instruction_memory is array (0 to 2**addr_bits-1) of std_logic_vector (data_bits-1 downto 0);
    
    -- 64 words
    constant ROM : instruction_memory := (
        X"E3A00001", X"E3A01002", X"E1A03001", X"E3A04005",
        X"E0805001", X"E0446000", X"E0057004", X"E3858005",
        X"E2249003", X"E1510003", X"03A0100F", X"E1E0A001",
        X"E1A0B08A", X"E1A0C16B", X"E0986009", X"E050D001",
        X"E15D0005", X"0AFFFFFF", X"E0801000", X"EA000000",
        X"E0811000", X"E3E09004", X"E2898002", X"E3590000", 
        X"12439002", X"E5813000", X"E5910001", X"EBFFFFE3", 
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000"  );

    

begin
    output<=ROM (TO_INTEGER(unsigned(address_input)));

end Behavioral;
