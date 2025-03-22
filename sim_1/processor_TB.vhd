

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity processor_TB is
--  Port ( );
end processor_TB;

architecture Behavioral of processor_TB is
    constant N : integer := 32;
    
    component Processor is
    PORT
    (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        PC : out STD_LOGIC_VECTOR (5 downto 0);
        instr : out STD_LOGIC_VECTOR (N-1 downto 0);
        ALUResult : out STD_LOGIC_VECTOR (N-1 downto 0);
        Datawrite : out STD_LOGIC_VECTOR (N-1 downto 0);
        Result : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
    end component Processor;
    
    --UUT
    signal CLK_tb         : std_logic;
    signal RESET_tb       : std_logic;
    signal PC_tb          : std_logic_vector (5 downto 0);
    signal instr_tb       : std_logic_vector (N-1 downto 0);
    signal ALUResult_tb   : std_logic_vector (N-1 downto 0);
    signal Datawrite_tb   : std_logic_vector (N-1 downto 0);
    signal Result_tb      : std_logic_vector (N-1 downto 0);
    
    constant CLK_PERIOD: time :=10ns;
    
begin
    uut: Processor  
       port map
            (
                CLK       => CLK_tb,
                RESET     => RESET_tb, 
                PC        => PC_tb,
                instr     => instr_tb,
                ALUResult => ALUResult_tb,
                Datawrite => Datawrite_tb,
                Result    => Result_tb
            );
    
     --CLK PROCESS
     process is
     begin
        CLK_tb<='1';
        wait for CLK_PERIOD/2;
        CLK_tb<='0';
        wait for CLK_PERIOD/2;
      end process;
      
      --stimulus
      process
      begin
        RESET_tb <= '1';
        wait for 100 ns;
        RESET_tb <= '0';
        wait;
      end process ;


end Behavioral;
