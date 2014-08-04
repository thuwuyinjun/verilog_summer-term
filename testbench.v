`timescale 1ms/1ns 
module testbench;

reg [7:0]send_data;
reg clk1,send_en,rst,finish_send;
wire sd,freq,rec_en;
communication_send send(.send_data(send_data),.clk1(clk1),.send_en(send_en),.finish_send(finish_send),.rst(rst),.sd(sd),.freq(freq),.rec_en(rec_en));

initial
begin
	send_en = 0;
	send_data = 1;
	finish_send = 1;
	rst = 1;
	send_data = 8'b10101110;
	clk1 = 0;
	#10 rst = 0;
	#1000 send_en = 1;
	
	
end
always begin
	#10 clk1 =~clk1;
	
end
endmodule