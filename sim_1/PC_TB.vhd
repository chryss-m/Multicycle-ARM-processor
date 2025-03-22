library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity PC_TB is
--  Port ( );
end PC_TB;

architecture Behavioral of PC_TB is

     constant data_bits : integer := 32;
     
     component Program_Counter is
     port(
            CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           write_en:in STD_LOGIC;
           data_in: in STD_LOGIC_VECTOR(data_bits-1 downto 0);
           data_out: out STD_LOGIC_VECTOR(data_bits-1 downto 0)          
          );
     end component;
     
     
     --SIGNALS
    signal CLK_tb      : std_logic; 
    signal RESET_tb    : std_logic;  
    signal write_en_tb       : std_logic; 
    signal data_in_tb  : std_logic_vector(data_bits-1 downto 0); 
    signal data_out_tb : std_logic_vector(data_bits-1 downto 0);
    
    constant CLK_period: time :=10ns;
    
begin
    uut : Program_Counter
    port map(
        CLK=>CLK_tb,
        RESET => RESET_tb,
        write_en=>  write_en_tb,
        data_in=>data_in_tb,
        data_out=>data_out_tb
        );
        
        process is
        begin
            CLK_tb<='0';
            wait for CLK_period/2;
            CLK_tb<='1';
            wait for CLK_period/2;
            
        end process;
        
        process
        begin
            wait for 100ns;
            
            RESET_tb <= '1';
            wait for 20 ns;
            RESET_tb <= '0';
            
            write_en_tb <= '1';
            data_in_tb <= x"00000010"; 
            wait for 10 ns;
           
   

            write_en_tb <= '0';
            data_in_tb <= x"00000020";
            wait for 10 ns;
            
            write_en_tb <= '1';
            data_in_tb <= x"00000030";
            wait for 10 ns;
            wait;
        
        end process;
end Behavioral;
