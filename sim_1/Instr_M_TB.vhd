library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Instr_M_TB is
end entity Instr_M_TB;

architecture Behavioral of Instr_M_TB is

  constant addr_bits : integer := 6;  
  constant data_bits : integer := 32; 
  
  --UUT
  component Instruction_Memory
    port (
      address_input   : in std_logic_vector(addr_bits - 1 downto 0); 
      output : out std_logic_vector(data_bits - 1 downto 0) 
    );
  end component Instruction_Memory;
  
  -- UUT Signals
  signal address_tb   : std_logic_vector(addr_bits - 1 downto 0);
  signal output_tb : std_logic_vector(data_bits - 1 downto 0);
  
begin

   
    uut :  Instruction_Memory
        port map(
            address_input => address_tb,
            output => output_tb
        );
        
        
        process is
        begin
            wait for 100 ns;
            address_tb <= std_logic_vector(to_unsigned(0, addr_bits));
            wait for 10ns;
            address_tb <= std_logic_vector(to_unsigned(1, addr_bits));
            wait for 10ns;
            address_tb <= std_logic_vector(to_unsigned(2, addr_bits));
            wait for 10ns;
            address_tb <= std_logic_vector(to_unsigned(4, addr_bits));
            wait for 10ns;            
            address_tb <= std_logic_vector(to_unsigned(9, addr_bits));
            wait for 10ns;
            address_tb <= std_logic_vector(to_unsigned(11, addr_bits));
            wait for 10ns;            
            address_tb <= std_logic_vector(to_unsigned(13, addr_bits));
            wait for 10ns;
            address_tb <= std_logic_vector(to_unsigned(19, addr_bits));
            wait for 10ns;
            address_tb <= std_logic_vector(to_unsigned(22, addr_bits));
            wait for 10ns;            
            address_tb <= std_logic_vector(to_unsigned(32, addr_bits));
            wait for 10ns;
            address_tb <= std_logic_vector(to_unsigned(66, addr_bits)); -- errorrr
            wait for 10ns;
            wait; 
    end process;
end architecture Behavioral;