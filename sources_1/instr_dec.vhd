

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_dec is

    Port ( 
           op : in STD_LOGIC_VECTOR (1 downto 0);     --opcode
           funct : in STD_LOGIC_VECTOR (5 downto 0);
           shift : in STD_LOGIC_VECTOR (1 downto 0);     --shift type
           shamt5 : in STD_LOGIC_VECTOR (4 downto 0);     
           RegSrc : out STD_LOGIC_VECTOR (2 downto 0);
           ImmSrc: out std_logic;
           ALUSrc: out std_logic;
           ALUControl: out std_logic_vector(3 downto 0);
           MemtoReg: out std_logic;
           NoWrite_in :out std_logic
           );
end instr_dec;

architecture Behavioral of instr_dec is
begin 

    RegSrc_process: process (op,funct)
    begin
        case op is
            when "00" =>                    --DATA PROCESSING
                case funct(5 downto 1) is 
                    when "11010" =>
                        RegSrc<="XX0";
                    when "01010" =>
                        RegSrc<="X00";  
                    when others=>
                        case funct(5) is 
                            when '0'=>
                                case funct(4 downto 1) is 
                                    when "1101" =>      --LSL,LSR,ASR,ROR,MOV
                                        RegSrc<="00X";
                                    when "1111" =>      --MVN
                                        RegSrc<="00X";
                                    when others=>
                                        RegSrc<="000";
                                end case;
                     
                            when '1'=>
                                case funct(4 downto 1) is
                                    when "1101" =>      --LSL,LSR,ASR,ROR,MOV
                                        RegSrc<="0XX";
                                    when "1111" =>      --MVN
                                        RegSrc<="0XX";
                                    when others=>
                                        RegSrc<="0X0";
                                end case;
                            when others=>
                                RegSrc<=(others=>'0');
                        end case;                           
                end case;
                                            
            when "01"=>
                case funct(0) is
                    when '0' =>     --STR
                        RegSrc<="X10";
                    
                    when '1' =>    --LDR
                        RegSrc<="0X0";
                    when others=>
                        RegSrc<=(others=>'0');                       
                end case;
               
            when "10" =>
                case funct(4) is
                    when '0' => --B
                        RegSrc<="XX1";
                    when '1' =>   --BL
                        RegSrc<="1X1";
                    when others =>
                        RegSrc<=(others=>'0');
                    
                end case;
            when others =>
                RegSrc<=(others=>'0');            
        end case;
    end process RegSrc_process;

    ALUSrc_process: process(op,funct)
    begin
        case op is
            when "00"=>
                case funct(5) is 
                    when '1' =>
                        ALUSrc<= '1';
                    when '0' =>
                        ALUSrc<='0';
                    when others =>
                        ALUSrc<='X';                       
                end case;
            when "01" =>
                ALUSrc<= '1';
            when "10"=>
                ALUSrc<= '1';
            when others =>
                ALUSrc<= '0';         
        end case;   
    end process ALUSrc_process;
    
    ImmSrc_process : process(op, funct)
    begin 
        case op is 
            when "00" =>
                case funct(5) is 
                    when '1'=>
                        ImmSrc<='0';
                    when '0' =>
                        ImmSrc<='X';
                    when others =>
                        ImmSrc<='X';
                end case;
            when "01" =>
                ImmSrc<='0';
            when "10" =>
                ImmSrc<='1';
            when others =>
                ImmSrc<='0';
        end case;
    end process ImmSrc_process;
    
    ALUControl_process : process(op, funct,shift,shamt5)
    begin 
        case op is
            when "00"=>
                case funct(4 downto 1) is
                    when "0100" =>
                        ALUControl<="0000";
                    when "0010" =>
                        ALUControl<="0001";
                    when "0000" =>
                        ALUControl<="0010";
                    when "1100" =>
                        ALUControl<="0011";
                    when "0001" =>
                        ALUControl<="0100";
                    when "1010" =>
                        ALUControl<="0001";
                    when "1111" =>
                        ALUControl<="0111";
                    when others=>
                        case funct(5 downto 1) is
                            when "01101" =>
                                case shift is
                                    when "00" =>
                                        case shamt5 is
                                            when "00000" =>
                                                ALUControl<="0110";
                                            when others =>
                                                ALUControl<="0101";                                            
                                        end case;
                                    when "01" =>
                                        ALUControl<="0101";
                                    when "10" =>
                                        ALUControl<="0101";                                 
                                    when "11"=>
                                         ALUControl<="0101"; 
                                    when others=>
                                        ALUControl<="XXXX";                              
                                end case;
                            when "11101" =>
                                ALUControl<="0110";
                            when others =>
                                ALUControl <= "XXXX";
                        end case;               
                         
                end case;
            when "01"=>
                case funct(3) is
                    when '1' =>
                        ALUControl<="0000";
                    when '0' =>
                        ALUControl<="0001";
                    when others =>
                        ALUControl<="XXXX";
                end case;
            when "10"=>
                ALUControl<="0000";
            when others =>
                ALUControl<="XXXX";
        end case;
    end process ALUControl_process;
    
    MemtoReg_process : process (op, funct)
    begin
        case op is
            when "00" =>
                case funct(4 downto 1) is
                    when "1010" =>  
                        MemtoReg<='X';
                    when others =>
                        MemtoReg<='0';
                end case;
            when "01" =>
                case funct(0) is
                    when '1'=>
                        MemtoReg<='1';
                    when '0'=>
                        MemtoReg<='X';
                    when others =>
                        MemtoReg<='0';
                end case;
            when "10"=>
                MemtoReg<='X';
            when others=>
                MemtoReg<='X';
        end case;
    end process MemtoReg_process;
    
    NoWrite_in_process : process (op, funct)
    begin
        case op is
            when "00" =>
                case funct(4 downto 1) is
                    when "1010" =>  
                        NoWrite_in <= '1';  
                     when others =>
                        NoWrite_in <= '0';  
                end case;
            when others =>
                NoWrite_in <= '0';  
        end case ;
    end process NoWrite_in_process;
    
end Behavioral;
