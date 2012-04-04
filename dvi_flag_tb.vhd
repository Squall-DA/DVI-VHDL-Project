-----Testbench file:----------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------------------------------
ENTITY dvi_flag_tb IS
END ENTITY;
------------------------------------------------------------------------
ARCHITECTURE testbench OF dvi_flag_tb IS
    SIGNAL clk50_tb: STD_LOGIC := '0'; --50MHZ System Clock
    SIGNAL red_switch_tb, green_switch_tb, blue_switch_tb: STD_LOGIC := '0';
    SIGNAL tmds0a_tb, tmds0b_tb: STD_LOGIC :='0';   -- TMDS0+ and TMDS0-
    SIGNAL tmds1a_tb, tmds1b_tb: STD_LOGIC :='0';   -- TMDS1+ and TMDS1-
    SIGNAL tmds2a_tb, tmds2b_tb: STD_LOGIC :='0';   -- TMDS2+ and TMDS2-
    SIGNAL tmds_clka_tb, tmds_clkb_tb: STD_LOGIC;   -- TMDS_clk+ and TMDS_clk-
    SIGNAL clk500_tb: STD_LOGIC;
    COMPONENT dvi_flag IS
        PORT(
		    clk50: IN STD_LOGIC; --50MHZ System Clock
            red_switch, green_switch, blue_switch: IN STD_LOGIC;
            tmds0a, tmds0b: BUFFER STD_LOGIC;   -- TMDS0+ and TMDS0-
            tmds1a, tmds1b: BUFFER STD_LOGIC;   -- TMDS1+ and TMDS1-
            tmds2a, tmds2b: BUFFER STD_LOGIC;   -- TMDS2+ and TMDS2-
            tmds_clka, tmds_clkb: OUT STD_LOGIC;
            clk500_out: OUT STD_LOGIC);   -- TMDS_clk+ and TMDS_clk-
    END COMPONENT;
BEGIN
    --DUT instantiation:------
    dut: dvi_flag PORT MAP (clk50_tb, red_switch_tb, green_switch_tb, blue_switch_tb, tmds0a_tb, tmds0b_tb, tmds1a_tb, tmds1b_tb, tmds2a_tb, tmds2b_tb, tmds_clka_tb, tmds_clkb_tb, clk500_tb);
    PROCESS
    BEGIN
        WAIT FOR 10ns;
        clk50_tb <= NOT clk50_tb;
    END PROCESS;
    
    PROCESS
    BEGIN
        WAIT FOR 20ms;
        red_switch_tb <= '1';
        blue_switch_tb <= '0';
        green_switch_tb <= '0';
        WAIT FOR 20ms;
        red_switch_tb <= '0';
        blue_switch_tb <= '1';
        green_switch_tb <= '0';
        WAIT FOR 20ms;
        red_switch_tb <= '1';
        blue_switch_tb <= '1';
        green_switch_tb <= '0';
        WAIT FOR 20ms;
        red_switch_tb <= '0';
        blue_switch_tb <= '0';
        green_switch_tb <= '1';
        WAIT FOR 20ms;
        red_switch_tb <= '1';
        blue_switch_tb <= '0';
        green_switch_tb <= '1';
        WAIT FOR 20ms;
        red_switch_tb <= '0';
        blue_switch_tb <= '1';
        green_switch_tb <= '1';
        WAIT FOR 20ms;
        red_switch_tb <= '1';
        blue_switch_tb <= '1';
        green_switch_tb <= '1';
    END PROCESS;
END ARCHITECTURE;
