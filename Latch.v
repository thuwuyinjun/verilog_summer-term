module latch(rst,div_1hz,num0,num1,num2,num3,num4,num5,num6,
_num0,_num1,_num2,_num3,_num4,_num5,_num6);
input rst,div_1hz;
input [3:0]   num0,num1,num2,num3,num4,num5,num6;
output  reg [3:0]   _num0,_num1,_num2,_num3,_num4,_num5,_num6;
always @(posedge div_1hz or negedge rst) begin 
	if(!rst) 
	begin
		_num0<=4'b0000; _num1<=4'b0000; _num2<=4'b0000; _num3<=4'b0000; 
		_num4<=4'b0000; _num5<=4'b0000; _num6<=4'b0000;
	end 
	else 
		begin
		_num0<=num0; _num1<=num1; _num2<=num2; _num3<=num3;
		_num4<=num4; _num5<=num5; _num6<=num6;
	end 
end
endmodule
