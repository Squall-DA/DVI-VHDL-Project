----TMDS---------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-----------------------------------------------------------
ENTITY tmds_encoder IS
	PORT(
		din: IN STD_LOGIC_VECTOR(7 DOWNTO 0);		--pixel data
		control: IN STD_LOGIC_VECTOR(1 DOWNTO 0);--control data
		clk50: IN STD_LOGIC;										--clock
		dena: IN STD_LOGIC;											--display enable
		dout: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));	--output data
END tmds_encoder;
-----------------------------------------------------------
ARCHITECTURE tmds_encoder OF tmds_encoder IS
	SIGNAL x: STD_LOGIC_VECTOR(8 DOWNTO 0);		--internal vector
	SIGNAL onesX: INTEGER RANGE 0 TO 8;				--# of '1's in x
	SIGNAL onesD: INTEGER RANGE 0 TO 8;				--# of '1's in din
	SIGNAL disp: INTEGER RANGE -16 TO 15;			--disparity
BEGIN
	----Computes number of '1's in din:----------------------
	PROCESS (din)
		VARIABLE counterD: INTEGER RANGE 0 TO 8;
	BEGIN
		counterD := 0;
		FOR i IN 0 TO 7 LOOP
			IF(din(i)= '1') THEN
				counterD := counterD + 1;
			END IF;
		END LOOP;
		onesD <= counterD;
	END PROCESS;
	-----Produces the internal vector x:----------------------
	PROCESS (din, onesD)
	BEGIN
		x(0) <= din(0);
		IF (onesD>4 OR (onesD=4 AND din(0) = '0')) THEN
			x(1) <= din (1) XNOR x(0);
			x(2) <= din (2) XNOR x(1);
			x(3) <= din (3) XNOR x(2);
			x(4) <= din (4) XNOR x(3);
			x(5) <= din (5) XNOR x(4);
			x(6) <= din (6) XNOR x(5);
			x(7) <= din (7) XNOR x(6);
			x(8) <= '0';
		ELSE
			x(1) <= din (1) XOR x(0);
			x(2) <= din (2) XOR x(1);
			x(3) <= din (3) XOR x(2);
			x(4) <= din (4) XOR x(3);
			x(5) <= din (5) XOR x(4);
			x(6) <= din (6) XOR x(5);
			x(7) <= din (7) XOR x(6);
			x(8) <= '1';
		END IF;
	END PROCESS;
	-----Computes the number of '1's in x:---------------------
	PROCESS (x)
		VARIABLE counterX: INTEGER RANGE 0 TO 8;
	BEGIN
		counterX := 0;
		FOR i IN 0 TO 7 LOOP
			IF (x(i) = '1') THEN
				counterX := counterX +1;
			END IF;
		END LOOP;
		onesX <= counterX;
	END PROCESS;
	-----Produces output vector and new disparity:--------------
    PROCESS (disp, x, onesX, dena, control, clk50)
        VARIABLE disp_new: INTEGER RANGE -31 TO 31;
    BEGIN
        IF (dena='1') THEN
            dout(8) <= x(8);
            IF (disp=0 OR onesX=4) THEN
                dout(9) <= NOT x(8);
                IF (x(8)='0') THEN
                    dout(7 DOWNTO 0) <= NOT x(7 DOWNTO 0);
                    disp_new := disp - 2*onesX + 8;
                ELSE
                    dout(7 DOWNTO 0) <= x(7 DOWNTO 0);
                    disp_new := disp + 2*onesX - 8;
                END IF;
            ELSE
                IF ((disp>0 AND onesX>4) OR (disp<0 AND onesX<4)) THEN
                    dout(9) <= '1';
                    dout(7 DOWNTO 0) <= NOT x(7 DOWNTO 0);
                    IF (X(8)='0') THEN
                        disp_new :=disp - 2*onesX + 8;
                    ELSE
                        disp_new := disp - 2*onesX + 10;
                    END IF;
                ELSE
                    dout(9) <= '0';
                    dout(7 DOWNTO 0) <= x(7 DOWNTO 0);
                    IF (X(8)='0') THEN
                        disp_new :=disp + 2*onesX - 10;
                    ELSE
                        disp_new := disp + 2*onesX - 8;
                    END IF;
                END IF;
            END IF;
        ELSE
            disp_new := 0;
            IF (control="00") THEN
                dout <= "1101010100";
            ELSIF (control="01") THEN
                dout <= "0010101011";
            ELSIF (control="10") THEN
                dout <= "0101010100";
            ELSE 
                dout <= "1010101011";
            END IF;
        END IF;
        IF (clk50'EVENT AND clk50='1') THEN
            disp <= disp_new;
        END IF;
    END PROCESS;
END tmds_encoder;
----------------------------------------------------------------------
                    

