`timescale 1ms/1ns
module FPGA2
(
	input [2:0] level,	//半自动的时候的手动输入
	input [1:0] rank, //手动，半自动还是自动,由FPGA2输入
	input control, //手动控制时的脉冲输入
	input clk,	//系统时钟
	//input rst,	//复位标志
	input rec_data,//接收到的串行数据
	input freq,	//接收到的发送端的频率
	output en,	//发送给FPGA1，1表示可以继续发送数据
	output reg [3:0] speed, //发送给电动机作为转速
	output reg reset,		//发送给FPGA1作为复位标志
	output reg send_en	//1表示为自动档，可以发送数据，发送给FPGA1
);
wire [7:0] data;
reg [1:0]state;
reg [2:0] level_tp;
reg run;
integer i;
reg rec_en;	//接收允许的标志位,由是否为自动档的标志位决定
communication_receive receive(.clk2(clk),.rec_data(rec_data),.freq(freq),.rec_en(rec_en),.out_data(data),.en(en));
reg[7:0] s0=8'b00000000, s1=8'b00011110,s2=8'b00111100,s3=8'b01011010,s4=8'b01111000,s5=8'b10010110,s6=8'b10110100;
initial 
begin
	i = 0;
	speed = 4'b0000;
	state = 2'b00;
	run = 0;
	level_tp = 3'b000;
end

/*always @(rst)
begin
	reset <= rst;
end*/
always @(posedge control)
begin
	run = 1;
	#1000 run = 0;
end
always @(rank or run)
begin
	case(rank)
		2'b00:
		begin
			state <= 2'b00;
			send_en <= 0;		//停止档
		end
		2'b01:
		begin
			state <= 2'b01;	//纯手动
			send_en <= 0;
		end
		2'b10:
		begin
			state <= 2'b10;	//半自动
			send_en <= 0;
		end
		2'b11:
		begin
			state <= 2'b11;
			send_en <= 1;
			rec_en <= 1;
		end					//自动
	endcase
end
always @(state or level or level_tp or run)
begin
	case(state)
	2'b00:speed <= 4'b0000;
	2'b01:
	begin
		if(run == 1)
		begin
			speed = 4'b1111;
		end
		else
			speed = 4'b0000;
	end
	2'b10:
	begin
		case(level)
		3'b000:speed <= 4'b0000;
		3'b001:speed <= 4'b0001;
		3'b010:speed <= 4'b0101;
		3'b011:speed <= 4'b0111;
		3'b100:speed <= 4'b1001;
		3'b101:speed <= 4'b1101;
		3'b110:speed <= 4'b1111;
		endcase
	end
	2'b11:
	begin
		case(level_tp)
		3'b000:speed <= 4'b0000;
		3'b001:speed <= 4'b0001;
		3'b010:speed <= 4'b0101;
		3'b011:speed <= 4'b0111;
		3'b100:speed <= 4'b1001;
		3'b101:speed <= 4'b1101;
		3'b110:speed <= 4'b1111;
		endcase
	end
	endcase
end
/*always @(posedge control)
begin
	if(state == 2'b01)
	begin
		for(i=0;i<100;i=i+1)
		begin
			speed = 4'b1111;
		end
		i <= 0;
	end
end*/
always @(data)
begin
	if(data == s0)
		level_tp = 3'b000;
	else
	if(data > s0 && data <s1)
		level_tp = 3'b001;
	else
	if(data >= s1 && data <s2)
		level_tp = 3'b010;
	else
	if(data >= s2 && data <s3)
		level_tp = 3'b011;
	else
	if(data >= s3 && data <s4)
		level_tp = 3'b100;
	else
	if(data >= s4 && data <s5)
		level_tp = 3'b101;
	else
	if(data >= s5)
		level_tp = 3'b110;
	else
		level_tp = 3'b000;
end
/*always @(level_tp or level)
begin
	if(state == 2'b11)
	case(level_tp)
		1'd0:speed <= 4'b0000;
		1'd1:speed <= 4'b0001;
		1'd2:speed <= 4'b0101;
		1'd3:speed <= 4'b0111;
		1'd4:speed <= 4'b1001;
		1'd5:speed <= 4'b1101;
		1'd6:speed <= 4'b1111;
	endcase
	else
	if(state == 2'b10)
	case(level)
		1'd0:speed <= 4'b0000;
		1'd1:speed <= 4'b0001;
		1'd2:speed <= 4'b0101;
		1'd3:speed <= 4'b0111;
		1'd4:speed <= 4'b1001;
		1'd5:speed <= 4'b1101;
		1'd6:speed <= 4'b1111;
	endcase
end*/
endmodule
