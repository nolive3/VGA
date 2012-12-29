LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY VGA IS
	PORT (
		clock_pix : IN STD_LOGIC; -- 25.175 MHz clock
		
		H : IN NATURAL; -- From VGACounter
		V : IN NATURAL;
		
		ired : IN STD_LOGIC;   -- From RGB logic
		igreen : IN STD_LOGIC;
		iblue : IN STD_LOGIC;
		
		hsync : OUT STD_LOGIC; -- To VGA device
		vsync : OUT STD_LOGIC;
		ored : OUT STD_LOGIC;
		ogreen : OUT STD_LOGIC;
		oblue : OUT STD_LOGIC;
		
		pixelsent : OUT STD_LOGIC -- To RGB logic if needed
	);
END VGA;


ARCHITECTURE VGA_work OF VGA IS
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
	
	SIGNAL CSYNC : STD_LOGIC := '0';
	SIGNAL MVSYNC : STD_LOGIC := '0';
	SIGNAL MHSYNC : STD_LOGIC := '0';
	SIGNAL INVIEW : STD_LOGIC := '0';
	
BEGIN
	vsync <= MVSYNC;
	hsync <= MHSYNC;
	pixelsent <= '0' WHEN V<VBP ELSE
	             '0' WHEN V>VPX ELSE
					 '0' WHEN H<HBP ELSE
	             '0' WHEN H>HPX ELSE
					 clock_pix;
	MVSYNC <= '0' WHEN V < VST ELSE
	         '1';
	MHSYNC <= '0' WHEN H < HST ELSE
	         '1';
	CSYNC <= MVSYNC XOR MHSYNC;
	INVIEW <= '0' WHEN V<VBP ELSE
	          '0' WHEN V>VPX ELSE
	          '0' WHEN H<HBP ELSE
	          '0' WHEN H>HPX ELSE
				 '1';
	
	

	PROCESS (clock_pix)
	BEGIN
		IF (clock_pix='1' AND clock_pix'event) THEN
			IF (INVIEW='1') THEN
				ored <= ired;
				ogreen <= igreen;
				oblue <= iblue;
			ELSE
				ored <= CSYNC;
				ogreen <= CSYNC;
				oblue <= CSYNC;
			END IF;
		END IF;
	END PROCESS;
	
END VGA_work;