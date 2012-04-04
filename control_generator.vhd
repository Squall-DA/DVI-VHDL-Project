----Control generator:--------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------
ENTITY control_generator IS
	GENERIC (
		Ha: INTEGER := 136;			--Hpulse
		Hb: INTEGER := 296;			--Hpulse+HBP
		Hc: INTEGER := 1320;			--Hpulse+HBP+Hactive
		Hd: INTEGER := 1344;			--Hpulse+HBP+Hactive+HFP
		Va: INTEGER := 6;				--Vpulse
		Vb: INTEGER := 35;			--Vpulse+VBP
		Vc: INTEGER := 803;			--Vpulse+VBP+Vactive
		Vd: INTEGER := 806);			--Vpulse+VBP+Vactive+VFP
	PORT(
		clk50: IN STD_LOGIC;				--System clock (50MHz)
		--clk25: BUFFER STD_LOGIC;		--TMDS clock (25MHz)
		clk500: BUFFER STD_LOGIC;		--Tx clock (500MHz)
		Hsync: BUFFER STD_LOGIC;		--Horizontal sync
		Vsync: OUT STD_LOGIC;				--Vertical sync
		Hactive: BUFFER STD_LOGIC;	--Active portion of Hsync
		Vactive: BUFFER STD_LOGIC;	--Active portion of Vsync
		dena: OUT STD_LOGIC);				--Display enable
END control_generator;
------------------------------------------
ARCHITECTURE control_generator OF control_generator IS
	COMPONENT our_pll IS
		PORT(
		areset: IN STD_LOGIC;
		inclk0: IN STD_LOGIC;
		c0: OUT STD_LOGIC;
		locked: OUT STD_LOGIC);
	END COMPONENT;
BEGIN
	----Generation of clk500:--------
	pll: our_pll PORT MAP ('0', clk50, clk500, OPEN);
	----Generation of clk25:---------
	
	---Option 1: From clk50
	--PROCESS (clk50)
	--BEGIN
		--IF(clk50'EVENT AND clk50 = '1') THEN
			--clk25 <= NOT clk25;
		--END IF;
	--END PROCESS;
	
	---Option 2: From clk250
	--PROCESS (clk250)
	--VARIABLE count: INTEGER RANGE 0 TO 5;
	--BEGIN
	--	IF(clk250'EVENT AND clk250='1') THEN
	--		count:= count+1;
	--		IF( count =5) THEN
	--			clk25 <= NOT clk25;
	--			count := 0;
	--		END IF;
	--	END IF;
	--END PROCESS;
	
	---Horizontal signals generation:----
	PROCESS (clk50)
		VARIABLE Hcount: INTEGER RANGE 0 TO Hd := 0;
	BEGIN
		IF(clk50'EVENT AND clk50='1') THEN
			Hcount := Hcount +1;
			IF(Hcount=Ha) THEN
				Hsync <='1';
			ELSIF(Hcount =Hb) THEN
				Hactive<= '1';
			ELSIF(Hcount =Hc) THEN
				Hactive <='0';
			ELSIF(Hcount =Hd) THEN
				Hsync <= '0';
				Hcount := 0;
			END IF;
		END IF;
	END PROCESS;
	----Vertical signals genration:-----
	PROCESS (Hsync)
		VARIABLE Vcount: INTEGER RANGE 0 TO Vd := 0;
	BEGIN
		IF (Hsync'EVENT AND Hsync ='0') THEN
			Vcount:= Vcount +1;
			IF (Vcount =Va) THEN
				Vsync <= '1';
			ELSIF(Vcount=Vb) THEN
				Vactive <= '1';
			ELSIF(Vcount =Vc) THEN
				Vactive <= '0';
			ElSIF(Vcount = Vd) THEN
				Vsync <= '0';
				Vcount :=0;
			END IF;
		END IF;
	END PROCESS;
	----Display-enable genration:------
	dena <= Hactive AND Vactive;
END control_generator;
------------------------------------------
