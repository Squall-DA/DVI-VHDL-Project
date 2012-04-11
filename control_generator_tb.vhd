-----Testbench file:----------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------------------------------
ENTITY control_generator_tb IS
END ENTITY;
------------------------------------------------------------------------
ARCHITECTURE testbench OF control_generator_tb IS
    SIGNAL clk50_tb: STD_LOGIC :='0';   --System clock (50MHz)
	SIGNAL clk500_tb: STD_LOGIC;		--Tx clock (500MHz)
	SIGNAL Hsync_tb: STD_LOGIC;		    --Horizontal sync
	SIGNAL Vsync_tb: STD_LOGIC;			--Vertical sync
	SIGNAL Hactive_tb: STD_LOGIC;	    --Active portion of Hsync
	SIGNAL Vactive_tb: STD_LOGIC;	    --Active portion of Vsync
	SIGNAL dena_tb: STD_LOGIC;			--Display enable
    COMPONENT control_generator IS
        PORT (
            clk50: IN STD_LOGIC;
            clk500: BUFFER STD_LOGIC;
            Hsync: BUFFER STD_LOGIC;
            Vsync: OUT STD_LOGIC;
            Hactive: BUFFER STD_LOGIC;
            Vactive: BUFFER STD_LOGIC;
            dena: OUT STD_LOGIC);
    END COMPONENT;
BEGIN
    control_gen: control_generator PORT MAP (
        clk50_tb, clk500_tb, Hsync_tb, Vsync_tb, Hactive_tb, Vactive_tb, dena_tb);
    PROCESS
    BEGIN
        WAIT FOR 10ns;
        clk50_tb <= NOT clk50_tb;
    END PROCESS;
END ARCHITECTURE;
