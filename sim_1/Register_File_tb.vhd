library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File_tb is
--port();
end Register_File_tb;

architecture behavior of Register_File_tb is

    --componentn declaration for register_file
    component Register_File
        generic (
            addr_bits: integer := 4;
            data_bits: integer := 32
        );
        Port ( 
            CLK : in STD_LOGIC;
            RESET: in STD_LOGIC;
            read_addr1: in STD_LOGIC_VECTOR(addr_bits-1 downto 0);
            read_addr2: in STD_LOGIC_VECTOR(addr_bits-1 downto 0);
            write_en: in STD_LOGIC;
            data_in: in STD_LOGIC_VECTOR(data_bits-1 downto 0);
            write_address: in STD_LOGIC_VECTOR(addr_bits-1 downto 0);
            reg_special: in STD_LOGIC_VECTOR(data_bits-1 downto 0);
            data_out_1: out STD_LOGIC_VECTOR(data_bits-1 downto 0);
            data_out_2: out STD_LOGIC_VECTOR(data_bits-1 downto 0)
        );
    end component;

    -- Testbench signals
    signal CLK : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal read_addr1 : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
    signal read_addr2 : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
    signal write_en : STD_LOGIC := '0';
    signal data_in : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal write_address : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
    signal reg_special : STD_LOGIC_VECTOR(31 downto 0) := X"DEADBEEF";
    signal data_out_1 : STD_LOGIC_VECTOR(31 downto 0) ;
    signal data_out_2 : STD_LOGIC_VECTOR(31 downto 0) ;

    constant CLK_PERIOD :time :=10ns;

begin
    
     uut: Register_File
        generic map (
            addr_bits => 4,
            data_bits => 32
        )
        port map (
            CLK => CLK,
            RESET => RESET,
            read_addr1 => read_addr1,
            read_addr2 => read_addr2,
            write_en => write_en,
            data_in => data_in,
            write_address => write_address,
            reg_special => reg_special,
            data_out_1 => data_out_1,
            data_out_2 => data_out_2
        );

    -- Clock process
    CLK_PROCESS : process
    begin
        CLK <= '0';
        wait for  CLK_PERIOD / 2;
        CLK <= '1';
        wait for  CLK_PERIOD / 2;
    end process;

    -- Stimulus process
    process
    begin 
        wait for 2*CLK_PERIOD;
        
    -- WRITE TO REGISTER 1 AND READ IT
        write_en <= '1';
        data_in <= X"12345678";
        write_address <= "0001"; 
        wait for CLK_PERIOD; 
        
        write_en <= '0'; 
        read_addr1 <= "0001"; 
        wait for CLK_PERIOD;

        assert data_out_1 = X"12345678"
        report "Test case 1 failed: Data mismatch at register 1" severity error;

        -- READ R15
        read_addr1 <= "1111"; 
        wait for CLK_PERIOD;

        assert data_out_1 = X"DEADBEEF"
        report "Test case 2 failed: Special register mismatch" severity error;

        --WRITE TO REGISTER 2 AND READ BOTH
        write_en <= '1';
        data_in <= X"87654321";
        write_address <= "0010"; 
        wait for CLK_PERIOD;

        write_en <= '0';
        read_addr1 <= "0001"; 
        read_addr2 <= "0010"; 
        wait for CLK_PERIOD;

        assert data_out_1 = X"12345678" and data_out_2 = X"87654321"
        report "Test case 3 failed: Simultaneous reads mismatch" severity error;

        -- End simulation
        wait for 50 ns;
        report "Testbench completed successfully." severity note;
        wait;
    end process;

end behavior;
