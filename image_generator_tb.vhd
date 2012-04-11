-----Testbench file:----------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------------------------------
ENTITY image_generator_tb IS
	GENERIC (
		Ha: INTEGER := 136;			    --Hpulse
		Hb: INTEGER := 296;			    --Hpulse+HBP
		Hc: INTEGER := 1320;		    --Hpulse+HBP+Hactive
		Hd: INTEGER := 1344;		    --Hpulse+HBP+Hactive+HFP
		Va: INTEGER := 6;			    --Vpulse
		Vb: INTEGER := 35;			    --Vpulse+VBP
		Vc: INTEGER := 803;			    --Vpulse+VBP+Vactive
		Vd: INTEGER := 806);		    --Vpulse+VBP+Vactive+VFP
END ENTITY;
------------------------------------------------------------------------
ARCHITECTURE testbench OF image_generator_tb IS
    SIGNAL red_switch_tb, green_switch_tb, blue_switch_tb: STD_LOGIC :='0';
    SIGNAL clk50_tb, Hsync_tb, Vsync_tb, Hactive_tb, Vactive_tb, dena_tb: STD_LOGIC :='0';
    SIGNAL R_tb, G_tb, B_tb: STD_LOGIC_VECTOR(7 DOWNTO 0);
    COMPONENT image_generator IS
        PORT (
            red_switch, green_switch, blue_switch: IN STD_LOGIC;
            clk50, Hsync, Vsync, Hactive, Vactive, dena: IN STD_LOGIC;
            R, G, B: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;
BEGIN
    image_gen: image_generator PORT MAP (
        red_switch_tb, green_switch_tb, blue_switch_tb, clk50_tb, Hsync_tb, Vsync_tb, Hactive_tb, Vactive_tb, dena_tb, R_tb, G_tb, B_tb);
    PROCESS
    BEGIN
        WAIT FOR 10ns;
        clk50_tb <= NOT clk50_tb;
    END PROCESS;
    
    --PROCESS 
	---Horizontal signals generation:----
	PROCESS (clk50_tb)
		VARIABLE Hcount: INTEGER RANGE 0 TO Hd := 0;
	BEGIN
		IF(clk50_tb'EVENT AND clk50_tb='1') THEN
			Hcount := Hcount +1;
			IF(Hcount=Ha) THEN
				Hsync_tb <='1';
			ELSIF(Hcount =Hb) THEN
				Hactive_tb<= '1';
			ELSIF(Hcount =Hc) THEN
				Hactive_tb <='0';
			ELSIF(Hcount =Hd) THEN
				Hsync_tb <= '0';
				Hcount := 0;
			END IF;
		END IF;
	END PROCESS;
	----Vertical signals genration:-----
	PROCESS (Hsync_tb)
		VARIABLE Vcount: INTEGER RANGE 0 TO Vd := 0;
	BEGIN
		IF (Hsync_tb'EVENT AND Hsync_tb ='0') THEN
			Vcount:= Vcount +1;
			IF (Vcount =Va) THEN
				Vsync_tb <= '1';
			ELSIF(Vcount=Vb) THEN
				Vactive_tb <= '1';
			ELSIF(Vcount =Vc) THEN
				Vactive_tb <= '0';
			ElSIF(Vcount = Vd) THEN
				Vsync_tb <= '0';
				Vcount :=0;
			END IF;
		END IF;
	END PROCESS;
	----Display-enable genration:------
	dena_tb <= Hactive_tb AND Vactive_tb;


    
    PROCESS
    BEGIN
        WAIT FOR 60000ns;
        red_switch_tb <= '1';
        green_switch_tb <= '0';
        blue_switch_tb <= '0';
        WAIT FOR 30000ns;
        red_switch_tb <= '0';
        green_switch_tb <= '1';
        blue_switch_tb <= '0';
        WAIT FOR 30000ns;
        red_switch_tb <= '1';
        green_switch_tb <= '1';
        blue_switch_tb <= '0';
        WAIT FOR 30000ns;
        red_switch_tb <= '0';
        green_switch_tb <= '0';
        blue_switch_tb <= '1';
        WAIT FOR 30000ns;
        red_switch_tb <= '1';
        green_switch_tb <= '0';
        blue_switch_tb <= '1';
        WAIT FOR 30000ns;
        red_switch_tb <= '0';
        green_switch_tb <= '1';
        blue_switch_tb <= '1';
        WAIT FOR 30000ns;
        red_switch_tb <= '1';
        green_switch_tb <= '1';
        blue_switch_tb <= '1';
    END PROCESS;
END ARCHITECTURE;
