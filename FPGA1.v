module FPGA1
(
	//input [2:0] level,	//半自动和自动状态的时候的
	//input [1:0] rank, //手动，半自动还是自动,由FPGA2输入
	//input control, //手动控制时的脉冲输入
	input freq,	//输入的来自模拟电路的频率值
	input clk,	//FPGA系统时钟
	input en,	//是否为自动档的标志位，由FPGA2给出
	input rst,  //复位标志位，由FPGA2给出
	input finish_send,	//开始发送最终数据的标志,由FPGA2给出
	output sd,//输出串行数据
	output frq	//发送到的模拟电路的频率
);
 
integer num;	//用于计数，将频率值转换为相应的数值
reg count_end; //计数结束的标志
reg [7:0] dt; //将数值num转化为对应的降雨量
//wire rec_en; //是否接收数据的标志位
reg send_en;
initial
begin
	num = 0;
	count_end = 0;
	dt = 8'bzzzzzzzz;
	//finish_send = 0;
	send_en = 0;
end

always @(posedge clk) // 计算频率倍数的模块
begin
	if(en == 1)
	begin
		if(finish_send == 0)
		begin
		if(freq == 1 && count_end == 0)
			num = num + 1;
		if(freq == 0 && num > 0)
			begin
				count_end = 1;
				//num = 0;
				//finish_send = 1;
			end
		end
		else
		begin
			num <= 0;
			count_end <= 0;
			//dt <= 8'bzzzzzzzz;
			//finish_send <= 0;
			//send_en <= 0;
		end
	end
end

always @(num)   //将频率倍数转化为降雨量数值的模块
begin
	if(en == 1)
		dt = num;
	else
		dt = 8'bzzzzzzzz;
end

always @(count_end or en or num)
begin
	if(count_end == 1 && en ==1)
		send_en <= 1;
	else
		if(num > 0)
		send_en = 0;
end

communication_send send(.send_data(dt),.clk1(clk),.send_en(send_en),.finish_send(finish_send),.rst(rst),.sd(sd),.freq(frq));
endmodule 
