library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Instruction_Memory is
    -- ��� ����������� ����� ��� �� testbench
end tb_Instruction_Memory;

architecture behavior of tb_Instruction_Memory is

    -- ��������� �� ������� �� ��� �������� Instruction_Memory
    component Instruction_Memory
        generic(
            addr_bits: integer := 6;
            data_bits: integer := 32
        );
        Port(
            address_input: in STD_LOGIC_VECTOR(addr_bits-1 downto 0);
            output: out STD_LOGIC_VECTOR (data_bits-1 downto 0)
        );
    end component;

    -- ������ ��� �� input/output ��� Instruction_Memory
    signal address_input : STD_LOGIC_VECTOR(5 downto 0);
    signal output : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- ��������� ��� �������� Instruction_Memory �� �� ������ ��� testbench
    uut: Instruction_Memory
        generic map (
            addr_bits => 6,
            data_bits => 32
        )
        port map (
            address_input => address_input,
            output => output
        );

    -- ��������� ��� �� ��������� ��� Instruction_Memory
    process
    begin
        -- ������������� �� ��������� ������� ��� ���������� ��� �����
        address_input <= "000000"; -- ��������� 0 (����� ������)
        wait for 10 ns;
        assert (output = X"E1A0100F") report "Test failed for address 000000" severity error;

        address_input <= "000001"; -- ��������� 1
        wait for 10 ns;
        assert (output = X"E3A01005") report "Test failed for address 000001" severity error;

        address_input <= "000010"; -- ��������� 2
        wait for 10 ns;
        assert (output = X"E1A01001") report "Test failed for address 000010" severity error;

        -- ������� �� ���������� ����� ����������� ��� �� �������� ����� �������

        address_input <= "111111"; -- ��������� 63 (��������� ������)
        wait for 10 ns;
        assert (output = X"00000000") report "Test failed for address 111111" severity error;

        -- ����� ��� ����
        wait;
    end process;

end behavior;
