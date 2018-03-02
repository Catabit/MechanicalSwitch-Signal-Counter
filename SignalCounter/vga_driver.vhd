----------------------------------------------------------------------------------
-- Company: 
-- Engineer:	Noel Shimali
-- 
-- Create Date:    14:48:10 11/16/2015 
-- Design Name: 
-- Module Name:    vga_driver - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;


entity vga_driver is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           nIn : in STD_LOGIC;
           HOLD : in STD_LOGIC;
           CLKx2: in STD_LOGIC;
           CLKx3: in STD_LOGIC;
           FRAME: in STD_LOGIC;
           HSYNC : out  STD_LOGIC;
           VSYNC : out  STD_LOGIC;
           RGB : out  STD_LOGIC_VECTOR (2 downto 0);
           led1: out STD_LOGIC;
           led2: out STD_LOGIC;
           led3: out STD_LOGIC;  
           led4: out STD_LOGIC         
		   );
end vga_driver;

architecture Behavioral of vga_driver is

	signal CLK_25MHz : std_logic :='0';
	signal CLK_1000HZ : std_logic :='0';
	
    signal clk_Count : std_logic_vector (1 downto 0):= "00"; --25MHZ
    signal CLK_1000HzCount: integer range 0 to 99999 := 0;
                                             
	
	constant HD : integer := 639;  --  639   Horizontal Display (640)
	constant HBP : integer := 48;        --   48   Left boarder (back porch)
	constant HSP : integer := 96;       --   96   Sync pulse (Retrace)
	constant HFP : integer := 16;         --   16   Right border (front porch)
	
	constant VD : integer := 479;   --  479   Vertical Display (480)
	constant VBP : integer := 33;       --   33   Left boarder (back porch)
	constant VSP : integer := 2;				 --    2   Sync pulse (Retrace)
	constant VFP : integer := 10;       	 --   10   Right border (front porch)
	
	constant BorderSize : integer := 2;
	
	signal P1Seg : std_logic_vector (6 downto 0) :="0000000";
	
	constant SegWidth : integer := 12;
	constant SegSize1 : integer := SegWidth/6;
	constant SegSize2 : integer := SegWidth + (SegSize1/2);	
	
	constant Seg1Xpos : integer := 50;
	constant Seg1Ypos : integer := 6 + BorderSize;
	
	constant minBorder1 : integer := 50;
	constant minBorder2 : integer := 400;
	
	constant maxBorder1 : integer := minBorder1 + BorderSize;
	constant maxBorder2 : integer := minBorder2 + BorderSize;
	
	
	--NO NEED TO EDIT THE FOLLOWING SIGNALS

	constant H1 : integer := HD + HFP;
	constant H2 : integer := HD + HFP + HSP;
	constant HMAX : integer := HD + HFP + HSP + HBP;
	signal Hpos : integer range 0 to HMAX:= 0;
	
	constant V1 : integer := VD + VFP;
	constant V2 : integer := VD + VFP + VSP;
	constant VMAX : integer := VD + VFP + VSP + VBP;
	signal Vpos : integer range 0 to VMAX:= 0;
	
	signal Video_on : std_logic := '0';
	signal SRF : std_logic := '0';

	------------------------------------------ SAMPLES
	
	signal Samples :std_logic_vector (HD downto 0) := (others => '0');
	signal SampleCounter: integer range 0 to HD:= 0;
	
	signal offset: integer range 0 to HD :=0;
	signal first: std_logic := '1';
	
    signal secondCount: integer range 0 to 10000 :=0;
    
    ---------------------------------------- Clock multiplier
    
    signal CLK_divided: std_logic :='0'; 
    signal CLK_div_250Hz: std_logic :='0';
    signal CLK_div_500Hz: std_logic :='0';
    signal CLK_div_2000Hz: std_logic :='0';
    
    signal Clk_250hzCount: integer range 0 to 399999:=0;
    signal Clk_500hzCount: integer range 0 to 199999:=0;
    signal Clk_2000hzCount: integer range 0 to 49999:=0;

	
begin

    


clk_div:process(CLK)
begin
	if(CLK'event and CLK = '1')then
	   if (clk_Count = "11") then
	       CLK_25MHz <= not CLK_25MHz;
	       clk_Count <= "00";
	   else
	       clk_Count <= clk_Count +1;
	   end if;
	end if;
end process;

clk_1000hz_p:process(CLK)
begin
	if(CLK'event and CLK = '1')then
	   if (CLK_1000hzCount = 99999) then
	       CLK_1000Hz <= not CLK_1000Hz;
	       clk_1000hzCount <= 0;
	   else
	       clk_1000hzCount <= clk_1000hzCount +1;
	   end if;
	   led3 <= CLK_1000HZ;
	end if;
end process;

clk_2000hz_p:process(CLK)
begin
	if(CLK'event and CLK = '1')then
	   if (CLK_2000hzCount = 49999) then
	       CLK_div_2000Hz <= not CLK_div_2000Hz;
	       clk_2000hzCount <= 0;
	   else
	       clk_2000hzCount <= clk_2000hzCount +1;
	   end if;
	   led4 <= CLK_div_2000HZ;
	end if;
end process;

clk_250hz_p:process(CLK)
begin
	if(CLK'event and CLK = '1')then
	   if (CLK_250hzCount = 399999) then
	       CLK_div_250Hz <= not CLK_div_250Hz;
	       clk_250hzCount <= 0;
	   else
	       clk_250hzCount <= clk_250hzCount +1;
	   end if;
	   led1 <= CLK_div_250HZ;
	end if;
end process;

clk_500hz_p:process(CLK)
begin
	if(CLK'event and CLK = '1')then
	   if (CLK_500hzCount = 199999) then
	       CLK_div_500Hz <= not CLK_div_500Hz;
	       clk_500hzCount <= 0;
	   else
	       clk_500hzCount <= clk_500hzCount +1;
	   end if;
	   led2 <= CLK_div_500HZ;
	end if;
end process;

clkMulti:process(CLK)
begin
    if (rising_edge(CLK)) then
        if(CLKx2='1' AND CLKx3='0') then
            clk_divided<=CLK_div_250Hz;
        elsif(CLKx3='1' AND CLKx2='0') then
            clk_divided<=CLK_div_500Hz;
        elsif (CLKx3='1' AND CLKx2='1') then
            clk_divided <=CLK_div_2000Hz;
        else
            clk_divided<=CLK_1000hz;
        end if;
    end if;
end process;

secondCounting:process(CLK_1000HZ)
begin
        if (rising_edge(CLK_1000HZ)) then
            if (secondCount=10000) then
                secondCount <=0;
            else
                secondCount <= secondCount +2;
           end if;
        end if;
end process;

sampling:process(CLK_divided, nIn, HOLD, FRAME)
begin
    if(rising_edge(CLK_divided)) then
       if (HOLD = '0') then
            if( nIn = '1') then
                if(first='1') then
                    offset<=SampleCounter;
                    first<='0';
                end if;
                Samples(SampleCounter-offset+1) <= '1';
            else
                Samples(SampleCounter-offset+1) <= '0';
            end if;
       else
            Samples(SampleCounter-offset+1) <= Samples(SampleCounter-offset+1);
       end if;
        
       if (SampleCounter = HD) then
            if (FRAME='0' and HOLD='0') then
                first <='1';
                offset<=0;
                SampleCounter <= 0;
                Samples <= (others => '0');
            end if;          
       else
            if (HOLD = '0') then
                if(first ='0') then               
                     SampleCounter <= SampleCounter +1;
                end if;
            else
                SampleCounter <= SampleCounter;
            end if;         
       end if; 
        
    end if;
end process;


	Horizontal_position_counter: process(CLK, CLK_25MHz, RST)
	begin
		if (RST = '1') then
			Hpos <= 0;
		else
			if(CLK_25MHz'EVENT AND CLK_25MHz = '1') then
				if(Hpos = HMAX) then
					Hpos <= 0;
				else
					Hpos <= Hpos + 1;
				end if;
			end if;
		end if;
	end process;

	Vertical_position_counter: process(CLK, CLK_25MHz, RST, Hpos)
	begin
		if (RST = '1') then
			Vpos <= 0;
		else
			if(CLK_25MHz'EVENT AND CLK_25MHz = '1') then
				if(Hpos = HMAX) then
					if(Vpos = VMAX) then
						Vpos <= 0;
					else
						Vpos <= Vpos + 1;
					end if;
				end if;
			end if;
		end if;	
	end process;
	
	Horizontal_syncronisation: process(CLK, CLK_25MHz, RST, Hpos)
	begin
		if(RST = '1') then
		HSYNC <= '0';
		else
			if(CLK_25MHz'EVENT AND CLK_25MHz = '1') then				
				if(Hpos <= H1 OR Hpos > H2) then
					HSYNC <= '1';
				else
					HSYNC <= '0';
				end if;
			end if;
		end if;
	end process;
	
	Vertical_syncronisation: process(CLK, CLK_25MHz, RST, Vpos)
	begin
		if(RST = '1') then
			VSYNC <= '0';
		else
			if(CLK_25MHz'EVENT AND CLK_25MHz = '1') then
				if(Vpos <= V1 OR Vpos > V2) then
					VSYNC <= '1';
				else
					VSYNC <= '0';
				end if;
			end if;
		end if;
	end process;
	
	Video_on_check: process(CLK, CLK_25MHz, RST, Hpos, Vpos)
	begin
		if(CLK_25MHz'EVENT AND CLK_25MHz = '1') then
			if (Hpos <= HD AND Vpos <= VD) then
				Video_ON <= '1';
			else
				Video_ON <= '0';
			end if;
		end if;
	end process;
	
	
	Screen_Refresh: process(CLK, CLK_25MHz, RST, Hpos, Vpos)
	begin	
		if(CLK_25MHz'EVENT AND CLK_25MHz = '1') then
			if (Hpos = HD AND Vpos = VD) then
				SRF <= '1';
			else
				SRF <= '0';
			end if;
		end if;
	end process;
	
	
	
	Score_to_segment: process(CLK_25MHz, RST, SRF, secondCount)
	begin
		if (RST = '1') then
			P1seg <= "0000000";
		elsif(CLK_25MHz'EVENT AND CLK_25MHz = '1') then
			if (SRF = '1') then
				case secondCount/1000 is
					when 0 =>
						P1seg <= "0111111";
					when 1 =>
						P1seg <= "0000110";
					when 2 =>
						P1seg <= "1011011";
					when 3 =>
						P1seg <= "1001111";
					when 4 =>
						P1seg <= "1100110";
					when 5 =>
						P1seg <= "1101101";
					when 6 =>
						P1seg <= "1111101";
					when 7 =>
						P1seg <= "0000111";
					when 8 =>
						P1seg <= "1111111";
					when 9 =>
						P1seg <= "1101111";
					when others =>
						P1seg <= "0000000";
				end case;
			end if;
		end if;
	end process;
	

	
	DRAW: process(CLK, CLK_25MHz, RST, Hpos, Vpos, P1seg, nIn, clk_divided)
	begin
		if(CLK_25MHz'EVENT AND CLK_25MHz = '1') then
			if(Video_ON = '1') then
			
			    if (Vpos<=5 AND Hpos <=5) then
			         if (CLK_divided = '1') then
			             RGB <= "100";
			         else
			             RGB <="000";
			         end if;       -- clock
			    elsif (((Vpos>= minBorder1 AND vpos <= maxBorder1) OR (Vpos>= minBorder2 AND vpos <= maxBorder2))) then
			            RGB <="010"; -- borders
			    elsif (Vpos >maxBorder1+10 AND Vpos < minBorder2-10 AND hpos>0) then
			            if (Samples(hpos-1) ='0' AND Samples(hpos) = '1') then -- rising edge
			                 RGB<="100";
			            elsif  (Samples(hpos-1)='1' AND Samples(hpos) ='0') then --falling edge
			                 RGB<="001";
			            elsif (Samples(hpos-1)='1' AND Samples(hpos) ='1') then --high signal
			                 if (vpos = maxBorder1 + 11) then
			                     RGB<="111";
			                 else
			                     RGB<="000";
			                 end if;
			            elsif (Samples(hpos-1)='0' AND Samples(hpos) ='0') then --low signal
			                 if (vpos = minBorder2 - 11) then
                                 RGB<="111";
                             else
                                 RGB<="000";
                             end if;
                        else
                            RGB <= "000";     
			            end if;			            
				elsif (P1seg(0) = '1' AND Vpos >= Seg1Ypos AND Vpos <= seg1Ypos + SegSize1) AND (Hpos >= seg1Xpos AND Hpos <= seg1Xpos + SegWidth) then  -- segA P1
						RGB <= "110";
				elsif (P1seg(1) = '1' AND Vpos >= seg1Ypos AND Vpos <= seg1Ypos + SegWidth + (SegSize1/2)) AND (Hpos >= seg1Xpos + SegWidth - SegSize1 AND Hpos <= seg1Xpos + SegWidth) then  -- segB P1
						RGB <= "110";
				elsif (P1seg(2) = '1' AND Vpos >= seg1Ypos + SegWidth - (SegSize1/2) AND Vpos <= seg1Ypos + (2*SegWidth)) AND (Hpos >= seg1Xpos + SegWidth - SegSize1 AND Hpos <= seg1Xpos + SegWidth) then  -- segC P1
							RGB <= "110";
				elsif (P1seg(3) = '1' AND Vpos >= seg1Ypos + (2*SegWidth) - SegSize1 AND Vpos <= seg1Ypos + (2*SegWidth)) AND (Hpos >= seg1Xpos AND Hpos <= seg1Xpos + SegWidth) then  -- segD P1
						RGB <= "110";
				elsif (P1seg(4) = '1' AND Vpos >= seg1Ypos + SegWidth - (SegSize1/2) AND Vpos <= seg1Ypos + (2*SegWidth)) AND (Hpos >= seg1Xpos AND Hpos <= seg1Xpos + SegSize1) then  -- segE P1
						RGB <= "110";
				elsif (P1seg(5) = '1' AND Vpos >= seg1Ypos AND Vpos <= seg1Ypos + SegWidth ) AND (Hpos >= seg1Xpos AND Hpos <= seg1Xpos + SegSize1) then  -- segF P1
						RGB <= "110";
				elsif (P1seg(6) = '1' AND Vpos >= seg1Ypos + SegWidth - (SegSize1/2) AND Vpos <= seg1Ypos + SegWidth + (SegSize1/2) ) AND (Hpos >= seg1Xpos AND Hpos <= seg1Xpos + SegWidth) then  -- segG P1
						RGB <= "110";
			    elsif ((hpos > samplecounter-2 AND hpos < SampleCounter+2) AND vpos > minBorder2-4 AND vpos < minborder2-2) then
			            RGB <="100";
				else
					RGB <= "000";  -- background colour
				end if;
			else
				RGB <= "000";
			end if;
		end if;
	end process;
	


end Behavioral;

