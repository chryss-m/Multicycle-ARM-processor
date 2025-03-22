
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;



entity Processor is
    generic( N: integer:= 32);
    
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           PC : out STD_LOGIC_VECTOR (5 downto 0);
           instr : out STD_LOGIC_VECTOR (N-1 downto 0);
           ALUResult : out STD_LOGIC_VECTOR (N-1 downto 0);
           Datawrite : out STD_LOGIC_VECTOR (N-1 downto 0);
           Result : out STD_LOGIC_VECTOR (N-1 downto 0));
end Processor;

architecture Structural of Processor is
    component Datapath is
          generic ( N: INTEGER:= 32);
    
          Port ( 
               CLK : in std_logic;
               RESET : in std_logic;
               RegSrc: in std_logic_vector(2 downto 0);         --selects the source register addresses for the register file
               RegWrite: in std_logic;                          --enables writing data to the register file
               ALUControl: in std_logic_vector(3 downto 0);     --defines the alu opration 
               ALUSrc: in std_logic;                            --selects the seond operand (register or imm value)
               MemtoReg: in std_logic;                          --form where the data to be written in a register comes from   (memory or alu )
               MemWrite: in std_logic;                          --enables writing data to memory
               MAWrite: in std_logic;                           --enables writing to the memory address register
               PCSrc: in std_logic_vector (1 downto 0);         --controls the source of the next PC value
               PCWrite: in std_logic;                           --enables writing to the program counter
               ImmSrc: in std_logic;                            --determines the format of an immediate value
               IRWrite: in std_logic;                           --enables loading a new instruction into the instruction register
               FlagsWrite: in std_logic;                        --enables updating the status flags
                              
               PC: out std_logic_vector(N-1 downto 0);          --holds the address of the current instruction 
               instr :out std_logic_vector(N-1 downto 0);       --holds the current instruction 
               Datawrite:out std_logic_vector(N-1 downto 0);    --data tio be written to memory 
               Flags:out std_logic_vector(3 downto 0 );         --status flags conditrions after alu operations
               ALUResult:out std_logic_vector(N-1 downto 0);    --alu's output
               res: out std_logic_vector(N-1 downto 0)          --general purpose output
               
              );
      end component DataPath;
      
      component Control_Unit is
          generic ( N: integer:= 32);
          port(
               CLK         : in std_logic;
               RESET       : in std_logic;
               IR          : in std_logic_vector(N-1 downto 0);
               SR          : in std_logic_vector(3 downto 0);       
               RegSrc      : out STD_LOGIC_VECTOR (2 downto 0);
               ImmSrc      : out std_logic;
               ALUSrc      : out std_logic;
               ALUControl  : out std_logic_vector(3 downto 0);
               MemtoReg    : out std_logic;
                
               IRWrite     : out std_logic;
               RegWrite    : out std_logic;
               MAWrite     : out std_logic;
               MemWrite    : out std_logic;
               FlagsWrite  : out std_logic;
               PCSrc       : out std_logic_vector (1 downto 0);  
               PCWrite     : out std_logic  
                );
      end component Control_Unit;
      
      signal RegSrc_cu_out :std_logic_vector(2 downto 0);
      signal ImmSrc_cu_out : std_logic;
      signal ALUSrc_cu_out :std_logic;
      signal ALUControl_cu_out: std_logic_vector(3 downto 0);
      signal MemtoReg_cu_out :std_logic;
      signal IRWrite_cu_out :std_logic;
      signal RegWrite_cu_out :std_logic;
      signal MAWrite_cu_out : std_logic;
      signal MemWrite_cu_out : std_logic;
      signal FlagsWrite_cu_out: std_logic;
      signal PCSrc_cu_out: std_logic_vector(1 downto 0);
      signal PCWrite_cu_out: std_logic;
      signal PC_dat_out : std_logic_vector (N-1 downto 0);
      signal instr_dat_out: std_logic_vector(N-1 downto 0);
      signal Datawrite_dat_out: std_logic_vector(N-1 downto 0);
      signal Flags_dat_out: std_logic_vector(3 downto 0);
      signal ALUResult_dat_out: std_logic_vector(N-1 downto 0);
      signal res_dat_out: std_logic_vector(N-1 downto 0);
    
    begin
        datapatah: Datapath
        generic map( N => N)
        port map(
            CLK=> CLK,
            RESET=>RESET,
            RegSrc=> RegSrc_cu_out,
            ALUSrc=> ALUSrc_cu_out,
            ALUControl=> ALUControl_cu_out,
            RegWrite => RegWrite_cu_out,
            MemtoReg=> MemtoReg_cu_out,
            MemWrite=> MemWrite_cu_out,
            MAWrite=> MAWrite_cu_out,
            PCSrc=> PCSrc_cu_out,
            PCWrite=> PCWrite_cu_out,
            ImmSrc=> ImmSrc_cu_out,
            IRWrite=> IRWrite_cu_out,
            FlagsWrite=> FlagsWrite_cu_out,
            PC=> PC_dat_out,
            instr=> instr_dat_out,
            Datawrite=>Datawrite_dat_out,
            Flags=> Flags_dat_out,
            ALUResult => ALUResult_dat_out,
            res=> res_dat_out         
        );
        
        CU: Control_Unit
        generic map(N=>N)
        port map(
            CLK=>CLK,
            RESET=>RESET,
            IR=> instr_dat_out,
            SR=> Flags_dat_out,
            RegSrc=> RegSrc_cu_out,
            ALUSrc=> ALUSrc_cu_out,
            ALUControl=> ALUControl_cu_out,
            RegWrite => RegWrite_cu_out,
            MemtoReg=> MemtoReg_cu_out,
            MemWrite=> MemWrite_cu_out,
            MAWrite=> MAWrite_cu_out,
            PCSrc=> PCSrc_cu_out,
            PCWrite=> PCWrite_cu_out,
            ImmSrc=> ImmSrc_cu_out,
            IRWrite=> IRWrite_cu_out,
            FlagsWrite=> FlagsWrite_cu_out
        );
        PC<=PC_dat_out(5 downto 0);
        instr<=instr_dat_out;
        ALUResult<=ALUResult_dat_out;
        Datawrite<=Datawrite_dat_out;
        Result<=res_dat_out;
        


end Structural;
