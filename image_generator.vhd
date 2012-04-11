-----Image generator:------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
---------------------------------------------------------------
ENTITY image_generator IS
    PORT (
        red_switch, green_switch, blue_switch: IN STD_LOGIC;
        clk50, Hsync, Vsync, Hactive, Vactive, dena: IN STD_LOGIC;
        R, G, B: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END image_generator;
---------------------------------------------------------------
ARCHITECTURE image_generator OF image_generator IS
BEGIN
    PROCESS (clk50, Hsync, dena)
        VARIABLE x: INTEGER RANGE 0 TO 1024;
        VARIABLE y: INTEGER RANGE 0 TO 768;
        VARIABLE red: STD_LOGIC;
        VARIABLE green: STD_LOGIC;
        VARIABLE blue: STD_LOGIC;
    BEGIN
        --Count columns:--------------
        IF (clk50'EVENT AND clk50='1') THEN
            IF (Hactive='1') THEN x := x + 1;
            ELSE x := 0;
            END IF;
        END IF;
        --Count lines:----------------
        IF (Hsync'EVENT AND Hsync='1') THEN
            IF (Vactive='1') THEN y := y + 1;
            ELSE y := 0;
            END IF;
        END IF;
        --Generate the image:---------
        IF (dena='1') THEN
            red := '0';
            green := '0';
            blue := '0';
            ----Blue Control-------------
            IF ((x<=409 AND y<=286) OR (x>409 AND ((y>40 AND y<=81) OR (y>122 AND y<=163) OR(y>204 AND y<=245))) OR 
            (y>286 AND y<=327) OR (y>368 AND y<=409) OR (y>450 AND y<=491)) THEN
                IF(blue_switch='1') THEN
                   blue  := '1';
                END IF;
            END IF;
            ----Green Control----------------
            IF ((x>409 AND ((y>40 AND y<=81) OR (y>122 AND y<=163) OR (y>204 AND y<=245))) OR 
            (y>286 AND y<=327) OR (y>368 AND y<=409) OR (y>450 AND y<=491)) THEN
                IF(green_switch='1') THEN
                    green := '1';
                END IF;
            END IF;
            ----Red Control-----------------
            IF ((x>409 AND y>286)) THEN
                IF(red_switch='1') THEN
                    red := '1';
                END IF;
            END IF;
            ----50 Stars--------------------
            IF((((x-34)**2+(y-29)**2)<=256) OR (((x-102)**2+(y-29)**2)<=256) OR (((x-170)**2+(y-29)**2)<=256) OR (((x-238)**2+(y-29)**2)<=256) OR (((x-306)**2+(y-29)**2)<=256) OR (((x-374)**2+(y-29)**2)<=256) OR 
            ----Third Row---------------------    
            (((x-34)**2+(y-87)**2)<=256) OR (((x-102)**2+(y-87)**2)<=256) OR (((x-170)**2+(y-87)**2)<=256) OR (((x-238)**2+(y-87)**2)<=256) OR (((x-306)**2+(y-87)**2)<=256) OR (((x-374)**2+(y-87)**2)<=256) OR 
            ----Fifth Row---------------------
            (((x-34)**2+(y-145)**2)<=256) OR (((x-102)**2+(y-145)**2)<=256) OR (((x-170)**2+(y-145)**2)<=256) OR (((x-238)**2+(y-145)**2)<=256) OR (((x-306)**2+(y-145)**2)<=256) OR (((x-374)**2+(y-145)**2)<=256) OR 
            ----Seventh Row-------------------
            (((x-34)**2+(y-203)**2)<=256) OR (((x-102)**2+(y-203)**2)<=256) OR (((x-170)**2+(y-203)**2)<=256) OR (((x-238)**2+(y-203)**2)<=256) OR (((x-306)**2+(y-203)**2)<=256) OR (((x-374)**2+(y-203)**2)<=256) OR 
            ----Ninth Row---------------------
            (((x-34)**2+(y-261)**2)<=256) OR (((x-102)**2+(y-261)**2)<=256) OR (((x-170)**2+(y-261)**2)<=256) OR (((x-238)**2+(y-261)**2)<=256) OR (((x-306)**2+(y-261)**2)<=256) OR (((x-374)**2+(y-261)**2)<=256) OR 
            ----Second Row--------------------
            (((x-68)**2+(y-58)**2)<=256) OR (((x-136)**2+(y-58)**2)<=256) OR (((x-204)**2+(y-58)**2)<=256) OR (((x-272)**2+(y-58)**2)<=256) OR (((x-340)**2+(y-58)**2)<=256) OR
            ----Fourth Row-------------------- 
            (((x-68)**2+(y-116)**2)<=256) OR (((x-136)**2+(y-116)**2)<=256) OR (((x-204)**2+(y-116)**2)<=256) OR (((x-272)**2+(y-116)**2)<=256) OR (((x-340)**2+(y-116)**2)<=256) OR
            ----Sixth Row---------------------
            (((x-68)**2+(y-174)**2)<=256) OR (((x-136)**2+(y-174)**2)<=256) OR (((x-204)**2+(y-174)**2)<=256) OR (((x-272)**2+(y-174)**2)<=256) OR (((x-340)**2+(y-174)**2)<=256) OR
            ----Eighth Row--------------------
            (((x-68)**2+(y-232)**2)<=256) OR (((x-136)**2+(y-232)**2)<=256) OR (((x-204)**2+(y-232)**2)<=256) OR (((x-272)**2+(y-232)**2)<=256) OR (((x-340)**2+(y-232)**2)<=256)) THEN
                IF(red_switch='1') THEN
                    red := '1';
                END IF;
                IF(green_switch='1') THEN
                    green := '1';
                END IF;
            END IF;            
        ELSE
            red := '0';
            green := '0';
            blue := '0';
        END IF;
        R <= (OTHERS => red);
        G <= (OTHERS => green);
        B <= (OTHERS => blue);
    END PROCESS;
END image_generator;
--------------------------------------------------------------

