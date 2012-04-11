-----Testbench file:----------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
------------------------------------------------------------------------
ENTITY tmds_encoder_tb IS
END ENTITY;
------------------------------------------------------------------------
ARCHITECTURE testbench OF tmds_encoder_tb IS
	SIGNAL din_tb: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";	--pixel data
    SIGNAL temp: UNSIGNED(7 DOWNTO 0) := "00000000";	        --temp pixel data
	SIGNAL control_tb: STD_LOGIC_VECTOR(1 DOWNTO 0) :="00";     --control data
	SIGNAL temp2: unsigned(1 DOWNTO 0) :="00";                  --temp control data
	SIGNAL clk50_tb: STD_LOGIC :='0';					        --clock
	SIGNAL dena_tb: STD_LOGIC :='1';							--display enable
    SIGNAL dout_tb: STD_LOGIC_VECTOR(9 DOWNTO 0);	            --output data
    COMPONENT tmds_encoder IS 
        PORT(
            din: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            control: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            clk50: IN STD_LOGIC;
            dena: IN STD_LOGIC;
            dout: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
    END COMPONENT;
BEGIN
    tmds0: tmds_encoder PORT MAP (din_tb, control_tb, clk50_tb, dena_tb, dout_tb);
    PROCESS
    BEGIN
        WAIT FOR 10ns;
        clk50_tb <= NOT clk50_tb;
    END PROCESS;

    PROCESS 
    BEGIN
        WAIT FOR 80ns;
        temp <= temp + "00000001";
        din_tb <= CONV_STD_LOGIC_VECTOR(temp,8);
    END PROCESS;

    PROCESS
    BEGIN
        WAIT FOR 40ns;
        temp2 <= temp2 + "01";
        control_tb <= CONV_STD_LOGIC_VECTOR(temp2,2);
    END PROCESS;

    PROCESS
    BEGIN
        WAIT FOR 20600ns;
        dena_tb <='0';
    END PROCESS;

END ARCHITECTURE;
