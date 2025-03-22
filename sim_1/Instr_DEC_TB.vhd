library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Instr_DEC_TB is
--  Port ( );
end Instr_DEC_TB;

architecture Behavioral of Instr_DEC_TB is
     
    component instr_dec
        Port ( 
           op         : in  STD_LOGIC_VECTOR (1 downto 0); -- Opcode
           funct      : in  STD_LOGIC_VECTOR (5 downto 0);
           shift      : in  STD_LOGIC_VECTOR (1 downto 0);
           shamt5     : in  STD_LOGIC_VECTOR (4 downto 0);
           RegSrc     : out STD_LOGIC_VECTOR (2 downto 0);
           ImmSrc     : out STD_LOGIC;
           ALUSrc     : out STD_LOGIC;
           ALUControl : out STD_LOGIC_VECTOR(3 downto 0);
           MemtoReg   : out STD_LOGIC;
           NoWrite_in : out STD_LOGIC
        );
    end component;
    
     
    signal op_tb         : STD_LOGIC_VECTOR (1 downto 0);
    signal funct_tb      : STD_LOGIC_VECTOR (5 downto 0);
    signal shift_tb      : STD_LOGIC_VECTOR (1 downto 0);
    signal shamt5_tb     : STD_LOGIC_VECTOR (4 downto 0);
    signal RegSrc_tb     : STD_LOGIC_VECTOR (2 downto 0);
    signal ImmSrc_tb     : STD_LOGIC;
    signal ALUSrc_tb     : STD_LOGIC;
    signal ALUControl_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal MemtoReg_tb   : STD_LOGIC;
    signal NoWrite_in_tb : STD_LOGIC;

begin
    uut: instr_dec
        port map (
            op         => op_tb,
            funct      => funct_tb,
            shift      => shift_tb,
            shamt5     => shamt5_tb,
            RegSrc     => RegSrc_tb,
            ImmSrc     => ImmSrc_tb,
            ALUSrc     => ALUSrc_tb,
            ALUControl => ALUControl_tb,
            MemtoReg   => MemtoReg_tb,
            NoWrite_in => NoWrite_in_tb
        );
    process
    begin
        wait for 100 ns;

        op_tb <= "00";
        funct_tb <= (others => '0');
        shamt5_tb <= (others => '0');
        shift_tb <= (others => '0');
        wait for 100 ns;
        
        --add -im
        op_tb     <= "00";
        funct_tb  <= "101000";         
        wait for 10 ns;
        
        --sub -reg
        op_tb     <= "00";
        funct_tb  <= "000100";         
        wait for 10 ns;
        
        --and -reg
        op_tb     <= "00";
        funct_tb  <= "000001";         
        wait for 10 ns;
        
        --or -imm
        op_tb     <= "00";
        funct_tb  <= "111001";         
        wait for 10 ns;
        
        --xor -imm
        op_tb     <= "00";
        funct_tb  <= "100010";         
        wait for 10 ns;
        
        --cmp --reg
        op_tb     <= "00";
        funct_tb  <= "010101";         
        wait for 10 ns;
        
        --mov -imm
        op_tb     <= "00";
        funct_tb  <= "111010";         
        wait for 10 ns;      
        
        --mvn --reg
        op_tb     <= "00";
        funct_tb  <= "011110";         
        wait for 10 ns;  
        
        --lsl 
        op_tb <= "00";
        funct_tb <= "011011";  
        shamt5_tb <= "00001";
        shift_tb <= "00"; 
        wait for 10 ns;  
        
        --lsr
        op_tb <= "00";
        funct_tb <= "011010";  
        shamt5_tb <= "00001";
        shift_tb <= "01"; 
        wait for 10 ns; 
        
        --ror
        op_tb <= "00";
        funct_tb <= "011011";  
        shamt5_tb <= "00001";
        shift_tb <= "11"; 
        wait for 10 ns; 
        
        --ldr -imm+
        op_tb<="01";
        funct_tb<="011001";
        wait for 10ns;
        
        --str -imm-
        op_tb<="01";
        funct_tb<="010000";
        wait for 10ns;
        
        --b
        op_tb<="10";
        funct_tb<="101111";
        wait for 10ns;
        
        --bl
        op_tb<="10";
        funct_tb<="110000";
        wait for 10ns;
        
        wait;
    end process;
    
end Behavioral;
