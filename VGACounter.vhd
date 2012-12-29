LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY VGACounter IS
	PORT (
		clock_pix : IN STD_LOGIC; -- From host device 25.175 MHz clock
		
		oH : OUT NATURAL; -- To VGA logic
		oV : OUT NATURAL;
		
		oVCLK : OUT STD_LOGIC;
		
		orow : OUT INTEGER; -- To RGB control
		ocol : OUT INTEGER
	);
END VGACounter;


ARCHITECTURE VGA_count OF VGACounter IS
	CONSTANT HST : NATURAL := 96;
	CONSTANT HBP : NATURAL := HST+48;
	CONSTANT HPX : NATURAL := HBP+640;
	CONSTANT HFP : NATURAL := HPX+16;
	CONSTANT HMAX : NATURAL := 800;
	CONSTANT VST : NATURAL := 2;
	CONSTANT VBP : NATURAL := VST+33;
	CONSTANT VPX : NATURAL := VBP+480;
	CONSTANT VFP : NATURAL := VPX+10;
	CONSTANT VMAX : NATURAL := 525;
	
	SIGNAL H, V : NATURAL;
	SIGNAL VCLK : STD_LOGIC;
	
BEGIN
	orow <= V-VBP;
	ocol <= H-HBP;
	oV <= V;
	oH <= H;
	oVCLK <= VCLK;
	VCLK <= '1' WHEN H=0 ELSE
	        '0';
	PROCESS (clock_pix) -- Tick the H position
	BEGIN
		IF (clock_pix='1' AND clock_pix'event) THEN
			H <= H+1;
			IF (H>=HMAX) THEN
				H <= 0;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (VCLK, clock_pix)  -- Tick the V position
	BEGIN
		IF (VCLK='1' AND (clock_pix='1' AND clock_pix'event)) THEN
			V <= V+1;
			IF (V>=VMAX) THEN
				V <= 0;
			END IF;
		END IF;
	END PROCESS;
END VGA_count;