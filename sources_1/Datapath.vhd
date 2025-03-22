
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity Datapath is
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
           PCSrc: in std_logic_vector(1 downto 0);        --controls the source of the next PC value
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
end Datapath;

architecture structural of Datapath is

    component Register_File is
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
    end component Register_File;
    
    component Program_Counter is
        generic (  data_bits: integer:=32);
           
        Port ( 
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           write_en:in STD_LOGIC;
           data_in: in STD_LOGIC_VECTOR(data_bits-1 downto 0);
           data_out: out STD_LOGIC_VECTOR(data_bits-1 downto 0)          
          );
     end component Program_Counter;
          
     component Status_Register is
        generic (N: integer :=4);
        
        Port ( 
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           WE : in STD_LOGIC;
           sr_in:in std_logic_vector(N-1 downto 0);
           sr_out : out STD_LOGIC_VECTOR (N-1 downto 0));
           
     end component Status_Register;
    
    component ALU is
        generic ( N: integer :=32);
    
        Port ( 
           SrcA : in STD_LOGIC_VECTOR (N-1 downto 0);  --FIRST INPUT OPERAND
           SrcB : in STD_LOGIC_VECTOR (N-1 downto 0);  --SECOND INPUT OPERAND
           ALUResult : out STD_LOGIC_VECTOR (N-1 downto 0);   -- ALU RESULT
           ALUControl: in STD_LOGIC_VECTOR (3 downto 0);   --CONTROL SIGNAL FOR ALU OPERATION  
           
           shamt5 : in STD_LOGIC_VECTOR (4 downto 0);   --SHIFT AMOUNT
           shift: in STD_LOGIC_VECTOR(1 downto 0);     --TYPE OF SHIFT
           N_flag :out STD_LOGIC;      
           Z_flag:out STD_LOGIC;
           C_flag: out STD_LOGIC;
           V_flag: out STD_LOGIC       
           );
    end component ALU;
    
    component Data_Memory is
        generic (N: integer:= 5;     
             M: integer:= 32    --WORD LENGTH
             );
   
        Port ( CLK : in STD_LOGIC;
           WE  : in STD_LOGIC;
           address: in STD_LOGIC_VECTOR(N-1 downto 0);
           write: in STD_LOGIC_VECTOR(M-1 downto 0);
           read : out STD_LOGIC_VECTOR (M-1 downto 0)   
        );
    end component Data_Memory;
    
    component Instruction_Memory is
        generic(
            addr_bits: integer :=6;
            data_bits: integer :=32
        );
    
        Port(
            address_input: STD_LOGIC_VECTOR(addr_bits-1 downto 0);
            output: out STD_LOGIC_VECTOR (data_bits-1 downto 0)
        );
    
    end component Instruction_Memory;
    
    component Extender is
        generic( N: integer :=32);
    
        Port ( selection : in STD_LOGIC;     
           input : in STD_LOGIC_VECTOR (23 downto 0);
           output : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component Extender;
    
    component mux_2_to_1
        generic( N: integer :=32);
    
        Port ( 
           selection : in STD_LOGIC;
           in_0 : in STD_LOGIC_VECTOR (N-1 downto 0);
           in_1 : in STD_LOGIC_VECTOR (N-1 downto 0);
           result : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component mux_2_to_1;
    
    component incrementer_4
        generic (             
           data_bits: integer:=32
           );
           
        Port ( 
           data_1 : in STD_LOGIC_VECTOR (data_bits-1 downto 0);
           data_2 : in STD_LOGIC_VECTOR (data_bits-1 downto 0);
           res_out : out STD_LOGIC_VECTOR (data_bits-1 downto 0)
          );
    end component incrementer_4;
    
    component non_arch_r_reset is
        generic (N: integer:=32 );
    
        Port ( 
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (N-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component non_arch_r_reset;
    
    component mux_3_to_1 is
        generic( N: integer :=32);
    
        Port ( 
           selection:in std_logic_vector(1 downto 0);
           in_0 : in STD_LOGIC_VECTOR (N-1 downto 0);
           in_1 : in STD_LOGIC_VECTOR (N-1 downto 0);
           in_2 : in STD_LOGIC_VECTOR(N-1 downto 0);
           result : out STD_LOGIC_VECTOR (N-1 downto 0));
           
    end component mux_3_to_1;
    
    --SIGNALS 
    signal PC_in : std_logic_vector(N-1 downto 0);
    signal PC_out: std_logic_vector(N-1 downto 0);
    signal Instr_M_out: std_logic_vector(N-1 downto 0);
    signal IR_out: std_logic_vector(N-1 downto 0);
    signal PCPlus_4_out: std_logic_vector(N-1 downto 0);
    signal PCP4_out: std_logic_vector(N-1 downto 0);
    signal A1:std_logic_vector(3 downto 0);
    signal A2:std_logic_vector(3 downto 0);
    signal A3:std_logic_vector(3 downto 0);
    signal R15: std_logic_vector(N-1 downto 0);
    signal WD3: std_logic_vector(N-1 downto 0);
    signal RD1: std_logic_vector(N-1 downto 0);
    signal RD2: std_logic_vector(N-1 downto 0);
    signal extender_out: std_logic_vector(N-1 downto 0);
    signal A_out:  std_logic_vector(N-1 downto 0);
    signal B_out:  std_logic_vector(N-1 downto 0);
    signal I_out: std_logic_vector(N-1 downto 0);
    signal ALUSrcB_out: std_logic_vector(N-1 downto 0);
    signal ALU_out: std_logic_vector(N-1 downto 0);
    signal ALU_flags: std_logic_vector(3 downto 0);
    signal SR_out: std_logic_vector(3 downto 0);
    signal MA_out: std_logic_vector(N-1 downto 0);
    signal WD_out:std_logic_vector(N-1 downto 0);
    signal DataM_out: std_logic_vector(N-1 downto 0);
    signal RD_out: std_logic_vector(N-1 downto 0);
    signal S_out: std_logic_vector(N-1 downto 0);
    signal mux_MEMTOREG_out: std_logic_vector(N-1 downto 0);
    
    
    
    
begin
    --COMPONENT INSTANTIATION
    
    PC_REG : Program_Counter
    generic map(data_bits =>N)
    port map(
        CLK=>CLK,
        RESET=>RESET,
        write_en=>PCWrite,
        data_in=>PC_in,
        data_out=>PC_out
        );
        
        
    IM : Instruction_Memory
    generic map(data_bits=>N, addr_bits=>6)
    port map(
        address_input => PC_out(7 downto 2),
        output => Instr_M_out
        );
    
    PCPlus4: incrementer_4
    generic map(data_bits=>N)
    port map(
        data_1=> PC_out,
        data_2=> "00000000000000000000000000000100",
        res_out=> PCPlus_4_out
        );
        
    
    IR_reg: Program_Counter
    generic map(data_bits=>N)
    port map(
        CLK=>CLK,
        RESET=>RESET,
        write_en=>IRWrite,
        data_in=>Instr_M_out,
        data_out=>IR_out
        );
        
    PCP4: non_arch_r_reset
    generic map(N=>N)
    port map(
        CLK=>CLK,
        RESET=>RESET,
        data_in=> PCPlus_4_out,
        data_out=> PCP4_out
        );
        
    PCPlus8: incrementer_4
    generic map(data_bits=>N)
    port map(
       data_1=> "00000000000000000000000000000100",
       data_2=> PCP4_out,
       res_out=> R15
       );
        
     A1_mux: mux_2_to_1
     generic map(N=>4)
     port map(
        selection=>RegSrc(0),
        in_0=>IR_out(19 downto 16),
        in_1=>"1111",
        result=>A1
        );
       
     A2_mux: mux_2_to_1
     generic map(N=>4)
     port map(
        selection=>RegSrc(1),
        in_0=>IR_out(3 downto 0),
        in_1=>IR_out(15 downto 12),
        result=>A2
        ); 
     
     A3_mux: mux_2_to_1
     generic map(N=>4)
     port map(
        selection=>RegSrc(2),
        in_0=>IR_out(15 downto 12),
        in_1=>"1110",
        result=>A3
        );
     
     WD3_mux: mux_2_to_1
     generic map(N=>N)
     port map(
        selection=>RegSrc(2),
        in_0=>mux_MEMTOREG_out,
        in_1=>PCP4_out,
        result=>WD3
        );
     
     Extend: Extender
     port map(
        selection=> ImmSrc,
        input=> IR_out(23 downto 0),
        output=> extender_out
        );
        
     Register_A: non_arch_r_reset
     generic map(N=>N)
     port map(
        CLK=>CLK,
        RESET=>RESET,
        data_in=>RD1,
        data_out=> A_out
        );
        
     Register_B: non_arch_r_reset
     generic map(N=>N)
     port map(
        CLK=>CLK,
        RESET=>RESET,
        data_in=>RD2,
        data_out=> B_out
        );
     
     Register_I: non_arch_r_reset
     generic map(N=>N)
     port map(
        CLK=>CLK,
        RESET=>RESET,
        data_in=>extender_out,
        data_out=> I_out
        );
        
     RF: Register_File
     generic map(data_bits=>N, addr_bits=>4)
     port map(
        CLK=>CLK,
        write_en=> RegWrite,
        read_addr1=>A1,
        read_addr2=>A2,
        write_address=>A3,
        reg_special=>R15,
        data_in=>WD3,
        data_out_1=>RD1,
        data_out_2=>RD2
        );
        
     ALUSrc_mux: mux_2_to_1
     generic map( N=>N)
     port map(
        selection=>ALUSrc,
        in_0=> B_out,
        in_1=>I_out,
        result=>ALUSrcB_out
        );
        
     ALU_UNIT:ALU
     generic map(N=>N)
     port map(
        SrcA=>A_out,
        SrcB=>ALUSrcB_out,
        ALUResult=>ALU_out,
        ALUControl=>ALUControl,
        shamt5=>IR_out(11 downto 7),
        shift=>IR_out(6 downto 5),
        N_flag=>ALU_flags(3),
        Z_flag=>ALU_flags(2),
        C_flag=>ALU_flags(1),
        V_flag=>ALU_flags(0)
        );
        
     SR: Status_Register
     generic map(N=>4)
     port map(
        CLK=>CLK,
        RESET=>RESET,
        WE=>FlagsWrite,
        sr_in=>ALU_flags,
        sr_out=>SR_out
        );
        
     MA_Reg: Program_Counter
     generic map(data_bits=>32)
     port map(
        CLK=>CLK,
        RESET=>RESET,
        write_en=>MAWrite,
        data_in=>ALU_out,
        data_out=>MA_out
        );
        
     WD_Reg: non_arch_r_reset
     generic map(N=>N)
     port map(
        CLK=>CLK,
        RESET=>RESET,
        data_in=>B_out,
        data_out=> WD_out
        );   
      
      Data_Mem: Data_Memory
      generic map( M=>N,N=>5)
      port map(
        CLK=>CLK,
        WE=>MemWrite,
        address=>MA_out(6 downto 2),
        write=>WD_out,
        read=>DataM_out
        );
        
     S_Reg: non_arch_r_reset
     generic map(N=>N)
     port map(
        CLK=>CLK,
        RESET=>RESET,
        data_in=>ALU_out,
        data_out=> S_out
        );
     
     RD_Reg: non_arch_r_reset
     generic map(N=>N)
     port map(
        CLK=>CLK,
        RESET=>RESET,
        data_in=>DataM_out,
        data_out=> RD_out
        ); 
     
     Men_Reg_mux: mux_2_to_1
     generic map(N=>N)
     port map(
        selection=>MemtoReg,
        in_0=>S_out,
        in_1=>RD_out,
        result=> mux_MEMTOREG_out
        );
     
     PC_mux: mux_3_to_1
     generic map(N=>N)
     port map(
        selection=>PCSrc,
        in_0=>PCP4_out,
        in_1=>ALU_out,
        in_2=>mux_MEMTOREG_out,
        result=> PC_in
        );
        
     --OUTPUT
     res<=mux_MEMTOREG_out;
     PC<=PC_out;
     instr <=Instr_M_out;
     Datawrite<=B_out;
     Flags<=SR_out;
     ALUResult<=ALU_out;
    
end structural;
