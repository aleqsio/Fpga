module my8bitdisplay(
	value, result, clk
);
input clk;
input wire [3:0] value;
output reg [7:0] result;

always@(posedge clk)
begin
	case (value)
	0: result <= 8'b00000011;//bo stan wysoki oznacza 0 wyswietlacza
	1: result <= 8'b10011111;
	2: result <= 8'b00100101;
	3: result <= 8'b00001101;
	4: result <= 8'b10011001;
	5: result <= 8'b01001001;
	6: result <= 8'b01000001;
	7: result <= 8'b00011111;
	8: result <= 8'b00000001;
	9: result <= 8'b00001001;
	endcase
end
endmodule


module rs_flipflop(r,s,q,q1,clk);
	output q,q1;
	input r,s,clk;
	reg q,q1;
	initial
	begin
		q=1'b0;
		q1=1'b1;
	end
	always @(posedge clk)
	  begin
	if(s==0 & r==0) begin
		q<=1;
		q1<=1;
		end
	 else if (r == 0) begin
		q<=1;
		q1<=0;
	end
	else if(s==0) begin
		q<=0;
		q1<=1;
		end
	
	end
endmodule

module my_counter (
	clk,
	count_up,
	count_down, 
	segm_o1,
	segm_o2,
);

input clk;
input count_up;
input count_down;

output wire [7:0] segm_o1;
output wire [7:0] segm_o2;

reg [3:0] count;
reg [24:0] clock_count;
wire q1;
wire notq1;
reg [3:0] disp_input_digit=0;
reg [3:0] disp_input_unit=0;
rs_flipflop main_rs (count_down, count_up, q1, notq1,clk);
my8bitdisplay digitdisp(disp_input_digit, segm_o1,clk);
my8bitdisplay unitdisp(disp_input_unit, segm_o2,clk);

initial begin
	count = 0;
	clock_count=0;
end

always @ (posedge clk)
begin
	clock_count<=clock_count +1;
	if (q1 == 1 & notq1==1) begin
	count<=0;
	end
	if(clock_count > 20000000) begin
		clock_count<=0;
		
	
		if (q1 == 1) begin
			count<=count +1;
		end else begin
			count<=count -1;
		end
	end
	disp_input_digit = (count/10);
	disp_input_unit = (count%10); 
end

endmodule 