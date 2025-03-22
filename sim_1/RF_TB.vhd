library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RF_TB is
--port();
end RF_TB;

architecture behavior of RF_TB is

    constant addr_bits : integer := 4;  
    constant data_bits: integer := 32; 
    
    --componentn declaration for register_file
    component Register_File
       
        Port ( 
            CLK : in STD_LOGIC;
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
       
        port map (
            CLK => CLK,
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
        wait for 100ns;
        
        
        --INITIALIZATION
        write_en <= '0';
        reg_special <= X"AAAAAAAA"; 
        data_in <= (others => '0');
        write_address <= (others => '0');
        read_addr1 <= (others => '0');
        read_addr2 <= (others => '0');
        wait for 100 ns; 
        
        -- 1)WRITE TO REGISTER 1 
        write_en <= '1';
        data_in <= X"12345678";
        write_address <= "0001"; 
        wait for CLK_PERIOD; 
        
        --2)READ REGISTER 1
        write_en <= '0'; 
        read_addr1 <= "0001"; 
        wait for CLK_PERIOD;

       
        -- 3)READ ANOTHER REGISTER
        read_addr1 <= "0100"; 
        wait for CLK_PERIOD;

        
        -- 4) WRITE TO REGISTER 2 AND 3 AT TEH SAME PERIOD
        write_en <= '1';
        write_address <= "0011";
        data_in <= X"DEADBEEF";
        wait for CLK_PERIOD;

        write_address <= "0010";
        data_in <= X"CAFEBABE";
        wait for CLK_PERIOD;

        --5)READ BOTH 2, 3
        write_en <= '0';
        read_addr1 <= "0011";
        read_addr2 <= "0010";
        wait for CLK_PERIOD ;
        
        -- 6) TRY WRITE DATA WITH WE=0
        write_en <= '0';
        write_address <= "0101";
        data_in <= X"FFFFFFFF";
        wait for CLK_PERIOD;

        read_addr1 <= "0101";
        wait for CLK_PERIOD;
        
        
        --7)READ R15
        read_addr1<="1111";
        wait for CLK_PERIOD;
        
        --8)TRY WRITE DATA IN R15
        write_en <= '1';
        write_address <= "1111";
        data_in <= X"55555555";
        wait for CLK_PERIOD;

        read_addr1 <= "1111";
        wait for CLK_PERIOD;

        write_en <= '0';
        wait for CLK_PERIOD;
        
        
        -- END SIMULATION 
        wait for 50 ns;
        report "Testbench completed successfully." severity note;
        wait;
    end process;

end behavior;
