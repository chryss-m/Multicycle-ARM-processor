

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fsm is

    port
    (
        CLK         : in std_logic;                         
        RESET       : in std_logic;                         
        op          : in std_logic_vector (1 downto 0);     
        S           : in std_logic;                         
        L           : in std_logic;                        
        Rd          : in std_logic_vector (3 downto 0);     
        NoWrite_in  : in std_logic;                         
        CondEx_in   : in std_logic;                         
        IRWrite     : out std_logic;                        
        RegWrite    : out std_logic;                       
        MAWrite     : out std_logic;                       
        MemWrite    : out std_logic;                        
        FlagsWrite  : out std_logic;                        
        PCSrc       : out std_logic;
        PCWrite     : out std_logic                        
    );

end fsm;

architecture Behavioral of fsm is
    type states is
        (S0,S1,S2a,S2b,S3,S4a,
begin


end Behavioral;
