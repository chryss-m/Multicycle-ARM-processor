library ieee;
use ieee.std_logic_1164.all;

entity tb_Datapath is
end tb_Datapath;

architecture tb of tb_Datapath is

    component Datapath
        port (CLK        : in std_logic;
              RESET      : in std_logic;
              RegSrc     : in std_logic_vector (2 downto 0);
              RegWrite   : in std_logic;
              ALUControl : in std_logic_vector (3 downto 0);
              ALUSrc     : in std_logic;
              MemtoReg   : in std_logic;
              MemWrite   : in std_logic;
              MAWrite    : in std_logic;
              PCSrc      : in std_logic;
              PCWrite    : in std_logic;
              ImmSrc     : in std_logic;
              IRWrite    : in std_logic;
              FlagsWrite : in std_logic;
              PC         : out std_logic_vector (N-1 dowNto 0);
              instr      : out std_logic_vector (N-1 dowNto 0);
              Datawrite  : out std_logic_vector (N-1 dowNto 0);
              Flags      : out std_logic_vector (3 dowNto 0 );
              ALUResult  : out std_logic_vector (N-1 dowNto 0);
              res        : out std_logic_vector (N-1 dowNto 0));
    eNd compoNeNt;

    sigNal CLK        : std_logic;
    sigNal RESET      : std_logic;
    sigNal RegSrc     : std_logic_vector (2 dowNto 0);
    sigNal RegWrite   : std_logic;
    sigNal ALUCoNtrol : std_logic_vector (3 dowNto 0);
    sigNal ALUSrc     : std_logic;
    sigNal MemtoReg   : std_logic;
    sigNal MemWrite   : std_logic;
    sigNal MAWrite    : std_logic;
    sigNal PCSrc      : std_logic;
    sigNal PCWrite    : std_logic;
    sigNal ImmSrc     : std_logic;
    sigNal IRWrite    : std_logic;
    sigNal FlagsWrite : std_logic;
    sigNal PC         : std_logic_vector (N-1 dowNto 0);
    sigNal iNstr      : std_logic_vector (N-1 dowNto 0);
    sigNal Datawrite  : std_logic_vector (N-1 dowNto 0);
    sigNal Flags      : std_logic_vector (3 dowNto 0 );
    sigNal ALUResult  : std_logic_vector (N-1 dowNto 0);
    sigNal res        : std_logic_vector (N-1 dowNto 0);

    coNstaNt TbPeriod : time := 1000 Ns;
    sigNal TbClock : std_logic := '0';
    sigNal TbSimENded : std_logic := '0';

begiN

    dut : Datapath
    port map (CLK        => CLK,
              RESET      => RESET,
              RegSrc     => RegSrc,
              RegWrite   => RegWrite,
              ALUCoNtrol => ALUCoNtrol,
              ALUSrc     => ALUSrc,
              MemtoReg   => MemtoReg,
              MemWrite   => MemWrite,
              MAWrite    => MAWrite,
              PCSrc      => PCSrc,
              PCWrite    => PCWrite,
              ImmSrc     => ImmSrc,
              IRWrite    => IRWrite,
              FlagsWrite => FlagsWrite,
              PC         => PC,
              iNstr      => iNstr,
              Datawrite  => Datawrite,
              Flags      => Flags,
              ALUResult  => ALUResult,
              res        => res);

    -- Clock geNeratioN
    TbClock <= Not TbClock after TbPeriod/2 wheN TbSimENded /= '1' else '0';
    CLK <= TbClock;

    stimuli : process
    begiN
        -- Αρχικοποίηση σημάτων
        RegSrc <= (others => '0');
        RegWrite <= '0';
        ALUCoNtrol <= (others => '0');
        ALUSrc <= '0';
        MemtoReg <= '0';
        MemWrite <= '0';
        MAWrite <= '0';
        PCSrc <= '0';
        PCWrite <= '0';
        ImmSrc <= '0';
        IRWrite <= '0';
        FlagsWrite <= '0';

        -- Επαναφορά (Reset)
        RESET <= '1';
        wait for 100 Ns;
        RESET <= '0';
        wait for 100 Ns;

        -- Test Case 1: ADD
        RegWrite <= '1';
        ALUCoNtrol <= "0010"; -- ADD
        ALUSrc <= '0';
        wait for TbPeriod;

        -- Test Case 2: SUB
        ALUCoNtrol <= "0110"; -- SUB
        wait for TbPeriod;

        -- Test Case 3: LW
        MemtoReg <= '1';
        MemWrite <= '0';
        ALUSrc <= '1';
        wait for TbPeriod;

        -- Test Case 4: SW
        MemWrite <= '1';
        MemtoReg <= '0';
        wait for TbPeriod;

        -- Τερματισμός προσομοίωσης
        TbSimENded <= '1';
        wait;
    eNd process;

eNd tb;

coNfiguratioN cfg_tb_Datapath of tb_Datapath is
    for tb
    eNd for;
eNd cfg_tb_Datapath;
