module communication_receive
(
	input clk2,	//系统时钟
	input rec_data,//接收到的串行数据
	input freq,	//接收到的发送端的频率
	input rec_en,	//接收允许的标志位
	output reg[7:0] out_data,//输出并行的数据
	output reg en	//发送给FPGA1，为1时表示可以继续发送数据
);

reg f_rec;
reg flag;   //存奇偶校验位
reg [7:0] rec;
reg data;
reg [3:0]state;
reg state_next;
reg finish;
integer counter;
integer counter_stop;
parameter s0=0, s1=1, s2=2, s3=3, s4=4, s5=5, s6=6, s7=7, s8=8, s9=9;
initial 
begin
	counter <= 0;
	state <= s0;
	en <= 0;
	out_data <= 8'bzzzzzzzz;
	counter_stop <= 0;
	finish <= 0;
	state_next <= s0;
end
always @(freq)
begin
	f_rec <= freq;
end
always @(posedge f_rec)
begin
	if(rec_en == 1)
	begin
		data <= rec_data;
		if(state == s0)
		begin
			//state <=s1;
			finish <= 0;
			counter_stop <= 0;
			if(data == 0)
				state <= s1;
		end
		else
		begin
			if(state == s1)
			begin
				if(counter<7)
				begin
					rec[counter] <= data;
					counter <= counter + 1;
				end
				else
				begin
					counter <= 0;
					rec[7] <= data;
					state <= s2;
				end
			end
			else
			if(state == s2)
			begin
				flag <= data;
				state <= s3;
			end
			else
				if(state == s3)
				begin
					if(data == 1)
					counter_stop <= counter_stop + 1;
					if(counter_stop == 2)
					begin
						state <= s0;
						finish <= 1;
					end
				end
			end
		end
end
always @(posedge clk2)
begin
	if(finish == 1)
	begin
		state_next <= s1;
	end
	else
		state_next <= s0;
end

always @(state_next)
begin
	case(state_next)
		s0:
		begin
			//out_data <= 8'bzzzzzzzz;
			en <= 0;
		end
		s1:
		begin
			out_data <= rec;
			en <= 1;
		end
	endcase
end
endmodule
