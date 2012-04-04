---Serializer:------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------
ENTITY serializer IS
	PORT (clk500: IN STD_LOGIC;
		  din: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		  dout: OUT STD_LOGIC);
END ENTITY serializer;
--------------------------------------------------
ARCHITECTURE serializer OF serializer IS
	SIGNAL internal: STD_LOGIC_VECTOR (9 DOWNTO 0);
BEGIN
	PROCESS (clk500)
		VARIABLE count: INTEGER RANGE 0 TO 10;
	BEGIN
		IF (clk500'EVENT AND clk500='1') THEN
			count := count + 1;
			IF (count = 9) THEN
				internal <= din;
			ELSIF (count = 10) THEN
				count := 0;
			END IF;
			dout <= internal(count);
		END IF;
	END PROCESS;
END ARCHITECTURE serializer;
--------------------------------------------------
