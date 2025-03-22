library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ALU_TB is
--  Port ( );
end ALU_TB;

architecture Behavioral of ALU_TB is

    constant N : integer := 32;
    
    --SIGNALS FOR ALU INPUTS
    signal SrcA, SrcB, ALUResult : STD_LOGIC_VECTOR (N-1 downto 0);
    signal ALUControl : STD_LOGIC_VECTOR (3 downto 0);
    signal shamt5 : STD_LOGIC_VECTOR (4 downto 0);
    signal shift : STD_LOGIC_VECTOR (1 downto 0);
    
    --SIGNALS FOR ALU FLAGS
    signal N_flag, Z_flag, C_flag, V_flag : STD_LOGIC;
    
    --COMPONENT
    component ALU
        generic ( N: integer :=32);
        Port (
            SrcA : in STD_LOGIC_VECTOR (N-1 downto 0);
            SrcB : in STD_LOGIC_VECTOR (N-1 downto 0);
            ALUResult : out STD_LOGIC_VECTOR (N-1 downto 0);
            ALUControl: in STD_LOGIC_VECTOR (3 downto 0);
            shamt5 : in STD_LOGIC_VECTOR (4 downto 0);
            shift: in STD_LOGIC_VECTOR(1 downto 0);
            N_flag :out STD_LOGIC;
            Z_flag:out STD_LOGIC;
            C_flag: out STD_LOGIC;
            V_flag: out STD_LOGIC
        );
    end component;
        
begin
    --CONNECTION ALU-TESTBENCH SIGNALS
    UUT: ALU
        generic map ( N => 32)
        port map (
            SrcA => SrcA,
            SrcB => SrcB,
            ALUResult => ALUResult,
            ALUControl => ALUControl,
            shamt5 => shamt5,
            shift => shift,
            N_flag => N_flag,
            Z_flag => Z_flag,
            C_flag => C_flag,
            V_flag => V_flag
        );
        
     stimulus: process
     begin
        wait for 100ns;
        
        --INITIALIZATION
        SrcA<= (others=>'0');
        SrcB<= (others=>'0');
        shamt5<= (others=>'0');
        shift<= (others=>'0');
        ALUControl<= (others=>'0');
        wait for 100ns;
        
        --ADD (POSITIVE)
        SrcA <= X"00000005";  --5
        SrcB <= X"00000003";  --3
        ALUControl <= "0000";
        wait for 10 ns;
        
        --ADD (OVERFLOW-NEGATIVE)
        SrcA <= X"7FFFFFFF";  -- 2147483647 (MAX)
        SrcB <= X"00000001";  -- 1
        ALUControl <= "0000"; 
        wait for 10 ns;
        
        --SUB (NEGATIVE)
        SrcA <= X"00000003";  -- 3 
        SrcB <= X"00000005";  -- 5 
        ALUControl <= "0001"; -- 
        wait for 10 ns;
        
        --SUB (POSITIVE)
        SrcA <= X"00000007";   --7
        SrcB <= X"00000002";    --2
        ALUControl <= "0001";
        wait for 10 ns;
        
        --AND 
        SrcA <= X"FFFFFFFF";   -- 1111 1111 1111 1111 1111 1111 1111 1111
        SrcB <= X"0F0F0F0F";   -- 0000 1111 0000 1111 0000 1111 0000 1111
        ALUControl <= "0010";
        wait for 10 ns;
        
        --OR
        SrcA <= X"F0F0F0F0";  -- 1111 0000 1111 0000 1111 0000 1111 0000
        SrcB <= X"0F0F0F0F";  -- 0000 1111 0000 1111 0000 1111 0000 1111
        ALUControl <= "0011";
        wait for 10 ns;
        
        --XOR
        SrcA <= X"AAAAAAAA";   -- 1010 1010 1010 1010 1010 1010 1010 1010
        SrcB <= X"55555555";   -- 0101 0101 0101 0101 0101 0101 0101 0101
        ALUControl <= "0100";
        wait for 10 ns;
        
        --LSL
        SrcB <= X"00000001";    --1
        shamt5 <= "00010";
        shift <= "00";
        ALUControl <= "0101";    
        wait for 10 ns;
        
        --LSR
        SrcB <= X"80000000";   -- -2147483648
        shamt5 <= "00010";
        shift <= "01";
        wait for 10 ns;
        
        --ASR
        SrcB <=  X"40000000";
        shamt5 <= "00010";
        shift <= "10";
        wait for 10 ns;
        
        --ROR
        SrcB <= X"80000001";     -- -2147483647 
        shamt5 <= "00010";
        shift <= "11";
        wait for 10 ns;

        --MOV
        SrcB <= X"12345678";   -- 0001 0010 0011 0100 0101 0110 0111 1000
        ALUControl <= "0110";
        wait for 10 ns;
        
        --MVN
        SrcB <= X"0000FFFF";    --0000 0000 0000 0000 1111 1111 1111 1111
        ALUControl <= "0111";
        wait for 10 ns;
        
        wait;
        
    end process stimulus;
end Behavioral;
