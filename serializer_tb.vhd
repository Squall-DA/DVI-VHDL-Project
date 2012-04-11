-----Testbench file:----------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
------------------------------------------------------------------------
ENTITY serializer_tb IS
END ENTITY;
------------------------------------------------------------------------
ARCHITECTURE testbench OF serializer_tb IS
    SIGNAL clk500_tb: STD_LOGIC :='0';
    SIGNAL din_tb: STD_LOGIC_VECTOR(9 DOWNTO 0) :="0000000000";
	SIGNAL dout_tb: STD_LOGIC;
    COMPONENT serializer IS
        PORT(
            clk500: IN STD_LOGIC;
            din: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            dout: OUT STD_LOGIC);
    END COMPONENT;
BEGIN
    serial0: serializer PORT MAP (clk500_tb, din_tb, dout_tb);

    PROCESS
    BEGIN
        WAIT FOR 2ns;
        clk500_tb <= NOT clk500_tb;
    END PROCESS;

    PROCESS 
    VARIABLE temp: UNSIGNED(9 DOWNTO 0) :="0000000000";
    BEGIN
        WAIT FOR 40ns;
        temp := temp + "0000000001";
        din_tb <= CONV_STD_LOGIC_VECTOR(temp,10);
    END PROCESS;
END ARCHITECTURE;
