module communication_send
(
	input [7:0]send_data,
	input clk1,
	input send_en,
	input finish_send,
	input rst,
	output reg sd,
	output reg freq,
	output reg rec_en
);
integer count;
integer count_stop;
integer count_all;
integer all;
reg[3:0] state_send;
reg [7:0] send;
parameter maxnum = 8, s0 = 0, s1 = 1, s2 = 2;
initial
begin
	count <= 0;
	count_stop <= 0;
	//state_send <= 4'b0000;
	rec_en <= 0;
	count_all <=0;
end
always @(clk1)
begin
freq <= clk1;
end
always @(posedge finish_send)
begin
	if(finish_send == 1)
	begin
		send <= send_data;
	end
end
always @(posedge clk1 or posedge rst)
begin
	if(rst == 1)
	begin
		state_send = 4'b0000;
	end
	else
		begin
		if(state_send < maxnum + 2)
		begin
			state_send = state_send + 1;
			if(state_send == 1)
				rec_en <= 1;
		end
		else
			if(state_send == maxnum + 2)
			begin
				count_stop = count_stop + 1;
				if(count_stop == 2)
				begin
					//state_send = 0;
					count_stop = 0;
					count_all = 0;
					state_send = maxnum + 3;
					rec_en <= 0;
				end
			end
			else
				if(state_send == maxnum + 3)
				begin
					state_send = 0;
					count_stop = 0;
				end
		end
end


always @(state_send or send_en)
begin
	if(send_en == 0)
	begin
		sd <= 1;
	end
	else
	if(state_send == 4'b0000)
	begin
		sd <= 0;
		//count <= 0;
	end
	else
	begin
		if(state_send >4'b0000 && state_send <= maxnum)
		begin
			sd <= send[state_send - 1];
			//count_all <= count_all + 1;
			//if(sd == 1)
				//count <= count + 1;
		end
		else
		begin
			if(state_send == maxnum + 1)
			begin
				if(count % 2 == 0)
				begin
					sd <= 0;
				end
				else
				begin
					sd <= 1;
				end
			end
			else
			begin	
				if(state_send == maxnum + 2)
				begin
					sd <= 1;
				end
				else
					sd <= 1;
			end
		end
	end
end
endmodule
