
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    generic ( N: integer :=32);
    
    Port ( SrcA : in STD_LOGIC_VECTOR (N-1 downto 0);  --FIRST INPUT OPERAND
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
end ALU;

architecture Behavioral of ALU is
begin

    --PROCESS FOR ALU OPERATIONS
    process (SrcA,SrcB, shamt5,shift, ALUControl)
        variable temp_A : signed (N+1 downto 0);    --EXTEND A INPUT FOR ARITHMETIC 
        variable temp_B : signed (N+1 downto 0);    --EXTEND B INPUT FOR ARITHMETIC 
        variable temp_RES : signed (N+1 downto 0);   --TEMPORARY RESULT
        
        variable temp_AND_XOR_OR: std_logic_vector (N-1 downto 0);  --TEMPORARY RESULT FOR LOGIC OPERATIONS
        
        begin
            --INITIALIZATION 
            temp_A := (others => '0');
            temp_B := (others => '0');
            temp_RES := (others => '0');
            temp_AND_XOR_OR := (others => '0');    
            ALUResult <= (others => '0');
            N_flag <= '0';
            Z_flag<= '0'; 
            C_flag <= '0';
            V_flag <= '0';
            
            
            --ALU OPERATION SELECTION 
            case ALUControl is
                
                --ADD
                when "0000" =>
                    temp_A:= signed('0' & SrcA(N-1) & SrcA);
                    temp_B:= signed('0' & SrcB(N-1) & SrcB);
                    temp_RES:= temp_A + temp_B;
                    ALUResult<= std_logic_vector(temp_RES (N-1 downto 0));
                    
                    --FLAGS
                    V_flag<= std_logic(temp_RES(N) xor temp_RES(N-1));
                    C_flag<= std_logic(temp_RES(N + 1));                    
                    
                    if (temp_RES(N-1 downto 0)= 0) then
                        Z_flag<='1';
                    else
                        Z_flag<='0';
                    end if;
                    
                    if (temp_RES(N-1)='1') then
                        N_flag<='1';
                    else 
                        N_flag<='0';
                    end if;
                    
                --SUB    
                when "0001" =>
                    temp_A:= signed('0' & SrcA(N-1) & SrcA);
                    temp_B:= signed('0' & not SrcB(N-1) & not SrcB)+1; --TWO'S COMPLEMENT
                    temp_RES:= temp_A + temp_B;    
                    ALUResult<= std_logic_vector(temp_RES (N-1 downto 0));
                    
                    --FLAGS
                    V_flag<= std_logic(temp_RES(N) xor temp_RES(N-1));
                    C_flag<= std_logic(temp_RES(N + 1));                    
                    
                    if (temp_RES(N-1 downto 0)= 0) then
                        Z_flag<='1';
                    else
                        Z_flag<='0';
                    end if;
                    
                    if (temp_RES(N-1)='1') then
                        N_flag<='1';
                    else 
                        N_flag<='0';
                    end if;
                    
                --AND
                when "0010" =>
                    temp_AND_XOR_OR := SrcA and SrcB;
                    ALUResult<= std_logic_vector(temp_AND_XOR_OR);
                    V_flag <= '0';
                    C_flag <= '0';
                    
                    --FLAGS
                    if (signed (temp_AND_XOR_OR)=0) then 
                        Z_flag<='1';
                    else 
                        Z_flag <='0'; 
                    end if;
                    
                    if (temp_AND_XOR_OR(N-1)='1') then 
                        N_flag<='1';
                    else 
                        N_flag<='0';
                    end if;
                    
                --OR
                when "0011" =>
                    temp_AND_XOR_OR := SrcA or SrcB;
                    ALUResult<= std_logic_vector(temp_AND_XOR_OR);
                    --FLAGS
                    V_flag <= '0';
                    C_flag <= '0';
                    
                    
                    if (signed (temp_AND_XOR_OR)=0) then 
                        Z_flag<='1';
                    else 
                        Z_flag <='0'; 
                    end if;
                    
                    if (temp_AND_XOR_OR(N-1)='1') then 
                        N_flag<='1';
                    else 
                        N_flag<='0';
                    end if;
                
                --XOR
                when "0100" =>
                    temp_AND_XOR_OR := SrcA xor SrcB;
                    ALUResult<= std_logic_vector(temp_AND_XOR_OR);
                    
                    --FLAGS
                    V_flag <= '0';
                    C_flag <= '0';
                    
                    if (signed (temp_AND_XOR_OR)=0) then 
                        Z_flag<='1';
                    else 
                        Z_flag <='0'; 
                    end if;
                    
                    if (temp_AND_XOR_OR(N-1)='1') then 
                        N_flag<='1';
                    else 
                        N_flag<='0';
                    end if;
                
               --SHIFT 
               when "0101" =>
                    case shift is
                        -- LSL (Logical Shift Left)
                        when "00" =>
                              ALUResult <= std_logic_vector(shift_left(unsigned(SrcB), to_integer(unsigned(shamt5))));
                
                        -- LSR (Logical Shift Right)
                        when "01" =>
                            ALUResult <= std_logic_vector(shift_right(unsigned(SrcB), to_integer(unsigned(shamt5))));
                
                        -- ASR (Arithmetic Shift Right)
                        when "10" =>
                            ALUResult <= std_logic_vector(shift_right(signed(SrcB), to_integer(unsigned(shamt5))));
                
                        -- ROR (Rotate Right)
                         when "11" =>
                            ALUResult <= std_logic_vector(rotate_right(unsigned(SrcB), to_integer(unsigned(shamt5))));
                
                        when others =>
                            ALUResult <= (others => '0');
                        end case;
               --MOV         
               when "0110" =>
                    ALUResult<=SrcB;   
        
               --MVN (NOT OPERATION)    
               when "0111" =>
                    ALUResult<= not SrcB;
               when others =>
                    ALUResult<=(others=>'0');
       
                                  
            end case;
            
    end process;
end Behavioral;

