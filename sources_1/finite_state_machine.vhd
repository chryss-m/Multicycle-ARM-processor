library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    port
    (
        CLK         : in std_logic;                         
        RESET       : in std_logic;                        
        op          : in std_logic_vector (1 downto 0);     
        S           : in std_logic;                         
        B_BL_in     : in std_logic;                         -- B or BL
        Rd          : in std_logic_vector (3 downto 0);    
        NoWrite_in  : in std_logic;                         
        CondEx_in   : in std_logic;                        
        IRWrite     : out std_logic;                       
        RegWrite    : out std_logic;                        
        MAWrite     : out std_logic;                        
        MemWrite    : out std_logic;                       
        FlagsWrite  : out std_logic;                        
        PCSrc       : out std_logic_vector (1 downto 0);    
        PCWrite     : out std_logic                        
    );
end entity FSM;

architecture Behavioral of FSM is

   type FSM_states is
        (S0,S1,S2a,S2b,S3,S4a,S4b,S4c,S4d,S4e,S4f,S4g,S4h,S4i);
    
   signal current_state, next_state : FSM_states;
    
   begin 
   
   process(CLK)
   begin
      if rising_edge(CLK) then
            if RESET = '1' then
                current_state <= S0;
            else
                current_state <= next_state;
            end if;
      end if;
   end process;
   
   NEXT_STATE_LOGIC :process(current_state, op, S,B_BL_in, Rd, NoWrite_in, CondEx_in) 
   begin
        IRWrite    <= '0';
        RegWrite   <= '0';
        MAWrite    <= '0';
        MemWrite   <= '0';
        FlagsWrite <= '0';
        PCSrc      <= "00";
        PCWrite    <= '0';     
        next_state <= S0;  
        
        case current_state is
            when S0 =>
                IRWrite<='1'; 
                next_state<=S1;
            when S1 =>
                if CondEX_in ='0' then 
                    next_state<=S4c;      --end    
                elsif CondEX_in ='1' and op="01" then    --LDR/STR
                    next_state <= S2a;
                elsif CondEX_in ='1' and op="00" then    
                    if NoWrite_in = '0' then  
                        next_state <= S2b;  -- Data Processing (NO CMP)
                    else  
                        next_state <= S4g;  -- CMP
                    end if;
                elsif CondEX_in ='1' and op="10" then 
                    if B_BL_in='0' then      --B
                        next_state<= S4h;
                    else
                        next_state<= S4i;   --BL
                   end if;
                end if;
            when S2a =>             --MEMORY INSTRUCTIONS
                MAWrite<='1';
                if S='1' then 
                    next_state<=S3;  --LDR
                elsif S='0' then 
                    next_state<=S4d; --STR
                else
                    next_state<=current_state;
                end if;
                
            when S2b =>
                if S = '0' then
                    if unsigned(Rd) /= "1111" then  
                        next_state <= S4a;
                    else  
                        next_state <= S4b;
                    end if;
                elsif S='1' then  
                    if unsigned(Rd) /= "1111" then  
                        next_state <= S4e;
                    else  
                        next_state <= S4f;
                    end if;
                else
                    next_state<=current_state;
                end if; 
                                
            when S3 => 
                if unsigned(Rd) /= "1111" then  
                    next_state <= S4a;
                elsif unsigned(Rd)= "1111" then
                    next_state <= S4b;
                else 
                    next_state<=current_state;   
                end if; 
                
            when S4a =>
                RegWrite <= '1';
                PCWrite  <= '1';
                next_state <= S0;     
                
            when S4b =>
                PCSrc   <= "10";
                PCWrite <= '1';
                next_state <= S0;
                
            when S4c =>
                PCWrite  <= '1';
                next_state <= S0;
                
            when S4d =>
                MemWrite <= '1';
                PCWrite  <= '1';
                next_state <= S0;  
                
            when S4e =>
                RegWrite   <= '1';
                FlagsWrite <= '1';
                PCWrite    <= '1';
                next_state <= S0;
                
            when S4f =>
                FlagsWrite <= '1';
                PCSrc      <= "10";
                PCWrite    <= '1';
                next_state <= S0;
                
            when S4g =>
                FlagsWrite <= '1';
                PCWrite    <= '1';
                next_state <= S0;
                
            when S4h =>
                PCSrc   <= "11";
                PCWrite <= '1';
                next_state <= S0;
                
            when S4i =>
                RegWrite <= '1';
                PCSrc    <= "11";
                PCWrite  <= '1';
                next_state <= S0;
                
            when others =>
                next_state<=S0;
        end case;
   
   end process NEXT_STATE_LOGIC;

end architecture Behavioral;

