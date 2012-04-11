----Main Code:-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all; 
---------------------------------------------------------
ENTITY dvi_flag IS
	PORT(
		clk50: IN STD_LOGIC; --50MHZ System Clock
        red_switch, green_switch, blue_switch: IN STD_LOGIC;
        tmds0a, tmds0b: BUFFER STD_LOGIC;   -- TMDS0+ and TMDS0-
        tmds1a, tmds1b: BUFFER STD_LOGIC;   -- TMDS1+ and TMDS1-
        tmds2a, tmds2b: BUFFER STD_LOGIC;   -- TMDS2+ and TMDS2-
        tmds_clka, tmds_clkb: OUT STD_LOGIC);   -- TMDS_clk+ and TMDS_clk-
END dvi_flag;
---------------------------------------------------------
ARCHITECTURE dvi OF dvi_flag IS
    ----Signal Declaration:------------------------------
    SIGNAL clk500: STD_LOGIC;
    SIGNAL Hsync, Vsync, Hactive, Vactive, dena: STD_LOGIC;
    SIGNAL R, G, B: STD_LOGIC_VECTOR(7 DOWNTO 0); 
    SIGNAL control0, control1, control2: STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL data0, data1, data2: STD_LOGIC_VECTOR(9 DOWNTO 0);
    ----1st compononet declartion:-----------------------
    COMPONENT image_generator IS
        PORT (
            red_switch, green_switch, blue_switch: IN STD_LOGIC;
            clk50, Hsync, Vsync, Hactive, Vactive, dena: IN STD_LOGIC;
            R, G, B: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;
    ----2ND Component Declaration------------------------
    COMPONENT control_generator IS
        PORT (
            clk50: IN STD_LOGIC;
            --clk25: BUFFER STD_LOGIC;
            clk500: BUFFER STD_LOGIC;
            Hsync: BUFFER STD_LOGIC;
            Vsync: OUT STD_LOGIC;
            Hactive: BUFFER STD_LOGIC;
            Vactive: BUFFER STD_LOGIC;
            dena: OUT STD_LOGIC);
    END COMPONENT;
    ----3rd component declaration:-----------------------
    COMPONENT tmds_encoder IS 
        PORT(
            din: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            control: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            clk50: IN STD_LOGIC;
            dena: IN STD_LOGIC;
            dout: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
    END COMPONENT;
    ----4th component declaration:-----------------------
    COMPONENT serializer IS
        PORT(
            clk500: IN STD_LOGIC;
            din: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            dout: OUT STD_LOGIC);
    END COMPONENT;
    -----------------------------------------------------
BEGIN
    control0 <= Vsync & Hsync;
    control1 <= "00";
    control2 <= "00";
    ----Image Generator----------------------------------
    image_gen: image_generator PORT MAP (
        red_switch, green_switch, blue_switch, clk50, Hsync, Vsync, Hactive, Vactive, dena, R, G, B);
    ----Control Generator--------------------------------
    control_gen: control_generator PORT MAP (
        clk50, clk500, Hsync, Vsync, Hactive, Vactive, dena);
    ----TDMS transmitter---------------------------------
    tmds0: tmds_encoder PORT MAP (B, control0, clk50, dena, data0);
    tmds1: tmds_encoder PORT MAP (G, control1, clk50, dena, data1);
    tmds2: tmds_encoder PORT MAP (R, control2, clk50, dena, data2);
    serial0: serializer PORT MAP (clk500, data0, tmds0a);
    serial1: serializer PORT MAP (clk500, data1, tmds1a);
    serial2: serializer PORT MAP (clk500, data2, tmds2a);
    tmds0b <= NOT tmds0a;
    tmds1b <= NOT tmds1a;
    tmds2b <= NOT tmds2a;
    tmds_clka <= clk50;
    tmds_clkb <= NOT clk50;
END dvi;
---------------------------------------------------------
    
