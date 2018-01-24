library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;




entity my_counter is port (
	clk: in std_logic;
	count_up: in bit;
	count_down: in bit;
	segm_o1: out std_logic_vector(7 downto 0);
	segm_o2: out std_logic_vector(7 downto 0)
 );
end my_counter;

entity rs_flipflop is port(
	r,s: in bit;
	q, notq: inout bit
);
end rs_flipflop;

architecture a_rs_flipflop of rs_flipflop is begin
	process(s, r) is
		begin
		q <= s nand (q nand r);
		notq <= not q;
	end process;
end a_rs_flipflop;

architecture ar_my_counter of my_counter is
	component  rs_flipflop is port(
			r,s: in bit;
			q, notq:  inout bit
		);
	end component rs_flipflop;
	
	

function display (
   number : in natural range 0 to 15)
    return std_logic_vector is
    variable disp : std_logic_vector(7 downto 0);
  begin
case number is
when 0 => disp :="00000011";
when 1 => disp := "10011111";
when 2 => disp :="00100101";
when 3 => disp := "00001101";
when 4 => disp :="10011001";
when 5 => disp := "01001001";
when 6 => disp :="01000001";
when 7 => disp := "00011111";
when 8 => disp :="00000001";
when 9 => disp := "00001001";
when others =>disp := "00000000";

end case;
    return std_logic_vector(disp);
end display;
	
	
	signal r1, s1,q1, notq1 : bit;
	signal segm1: std_logic_vector(7 downto 0) := "11111101";
	signal segm2: std_logic_vector(7 downto 0) := "11111101";
	signal digitsn: natural range 0 to 15;
	signal unitsn: natural range 0 to 15;
	signal count: natural range 0 to 15;
	signal clock_count : integer range 0 to 20000000 := 0;
	begin
		rs1: rs_flipflop port map(r1, s1, q1, notq1);
		process (clk, count_up, count_down) is
		 begin
			s1 <= count_up;
			r1 <= count_down;
			if rising_edge(clk) then
				if(clock_count > 20000000) then
					clock_count <= 0;
					if(q1 = '1') then
						count <= count + 1;
					elsif(q1 = '0') then
						count <= count - 1;
					end if;
				else 
					clock_count <= clock_count + 1;
					digitsn<=count / 10;
					unitsn<=count mod 10;
					segm1<=display(unitsn);
					segm2<=display(digitsn);
				end if;
			end if;
		 end process;
		 
end ar_my_counter;

