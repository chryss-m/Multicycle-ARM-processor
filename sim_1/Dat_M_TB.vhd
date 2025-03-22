
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Dat_M_TB is
--  Port ( );
end Dat_M_TB;

architecture Behavioral of Dat_M_TB is
    constant N : integer := 5;   
    constant M : integer := 32;
    
    --COMPONENT DECLARATION
    component Data_Memory
        generic (N: integer; M: integer);
        Port (
            CLK    : in STD_LOGIC;
            WE     : in STD_LOGIC;
            address: in STD_LOGIC_VECTOR(N-1 downto 0);
            write  : in STD_LOGIC_VECTOR(M-1 downto 0);
            read   : out STD_LOGIC_VECTOR(M-1 downto 0)
        );
    end component;
    
      -- SIGNALS
    signal CLK_tb    : STD_LOGIC := '0';
    signal WE_tb     : STD_LOGIC := '0';
    signal address_tb : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
    signal write_tb  : STD_LOGIC_VECTOR(M-1 downto 0) := (others => '0');
    signal read_tb   : STD_LOGIC_VECTOR(M-1 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
    
begin
    uut: Data_Memory
        generic map (N => N, M => M)
        port map (
            CLK    => CLK_tb,
            WE     => WE_tb,
            address=> address_tb,
            write  => write_tb,
            read   => read_tb
        );
    
    --CLK PROCESS
    process
    begin
        while true loop
            CLK_tb <= '0';
            wait for CLK_PERIOD / 2;
            CLK_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;
    
    process
    begin
       
        wait for 20 ns;

        -- Write 32'hAAAAAAAA at address 0
        WE_tb <= '1';
        address_tb <= std_logic_vector(to_unsigned(0, N));
        write_tb <= X"AAAAAAAA";
        wait for CLK_PERIOD;

        -- Write 32'h55555555 at address 1
        address_tb <= std_logic_vector(to_unsigned(1, N));
        write_tb <= X"55555555";
        wait for CLK_PERIOD;

        -- Write 32'h12345678 at address 5
        address_tb <= std_logic_vector(to_unsigned(5, N));
        write_tb <= X"12345678";
        wait for CLK_PERIOD;

        -- Disable writing
        WE_tb <= '0';

        -- Read from address 0
        address_tb <= std_logic_vector(to_unsigned(0, N));
        wait for 10 ns;  -- Read is asynchronous

        -- Read from address 1
        address_tb <= std_logic_vector(to_unsigned(1, N));
        wait for 10 ns;

        -- Read from address 5
        address_tb <= std_logic_vector(to_unsigned(5, N));
        wait for 10 ns;

        -- Read from an uninitialized address (e.g., address 10)
        address_tb <= std_logic_vector(to_unsigned(10, N));
        wait for 10 ns;

        -- Stop simulation
        wait;
    end process;
end Behavioral;
