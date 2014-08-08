`timescale 1ns/1ns
module 
Divider_tb;

reg clk;
wire div_1hz,div_10hz,div_100hz,div_1khz;
reg rst;
 
Divider u3cs(
    .clk(clk),
    .div_1hz(div_1hz),
    .div_10hz(div_10hz),
    .div_100hz(div_100hz),
    .div_1khz(div_1khz),
    .rst(rst)); 
initial
begin
        clk=1'b0;
        rst=1'b0;
	#30 rst=1'b1;  
end
always
begin
    #20 clk=~clk;
end
endmodule