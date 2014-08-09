module Count(signal,gate_out,rst,
num0,num1,num2,num3,num4,num5,num6);
input signal,gate_out,rst;
output reg [3:0]  num0,num1,num2,num3,num4,num5,num6;//4位BCD码
reg [3:0]  cnt0,cnt1,cnt2,cnt3,cnt4,cnt5,cnt6;  //计数器的6个计数值
reg flag;//溢出标志
reg [3:0] delay;//未设定
always @(posedge signal or negedge rst)
begin
	delay <= delay + 1'b1;
	if(!rst) 
		begin
			cnt0 <= 4'b0000;cnt1 <= 4'b0000;cnt2 <= 4'b0000;cnt3 <= 4'b0000;
			cnt4 <= 4'b0000;cnt5 <= 4'b0000;cnt6 <= 4'b0000;						
			num0 <= 4'b0000;num1 <= 4'b0000;num2 <= 4'b0000;
			num3 <= 4'b0000;num4 <= 4'b0000;num5 <= 4'b0000;flag <= 0;
		end 
	else 
	begin 
	if(gate_out == 1 && delay == 0) 
		begin 
			flag <= 0;
			if((cnt5 == 4'b1001)&&(cnt4 == 4'b1001)&&(cnt3 == 4'b1001)&&(cnt2 == 4'b1001)&&(cnt1 == 4'b1001)&&(cnt0 == 4'b1001))//溢出  
			begin
				cnt0 <= 4'b0000;cnt1 <= 4'b0000;cnt2 <= 4'b0000;cnt3 <= 4'b0000;
				cnt4 <= 4'b0000;cnt5 <= 4'b0000;cnt6 <= cnt6 + 4'b0001;
			end 
	else 
		begin
			if((cnt4 == 4'b1001)&&(cnt3 == 4'b1001)&&(cnt2 == 4'b1001)&&(cnt1 == 4'b1001)&&(cnt0 == 4'b1001)) 
			begin
				cnt0 <= 4'b0000; cnt1 <= 4'b0000; cnt2 <= 4'b0000; cnt3 <= 4'b0000;
				cnt4 <= 4'b0000; cnt5 <= 4'b0001 + cnt5; cnt6 <= cnt6;
		end 
	else 
		begin
			if((cnt3 == 4'b1001)&&(cnt2 == 4'b1001)&&(cnt1 == 4'b1001)&&(cnt0 == 4'b1001))
			begin
				cnt0 <= 4'b0000; cnt1 <= 4'b0000; cnt2 <= 4'b0000; cnt3 <= 4'b0000;
				cnt4 <= 4'b0001 + cnt4; cnt5 <= cnt5; cnt6 <= cnt6;
			end 
	else 
		begin
			if((cnt2 == 4'b1001)&&(cnt1 == 4'b1001)&&(cnt0 == 4'b1001)) 
			begin
				cnt0 <= 4'b0000; cnt1 <= 4'b0000; cnt2 <= 4'b0000; cnt3 <= 4'b0001 + cnt3;
				cnt4 <= cnt4; cnt5 <= cnt5; cnt6 <= cnt6;
			end 
	else 
		begin 
			if((cnt1 == 4'b1001)&&(cnt0 == 4'b1001)) 
			begin
				cnt0 <= 4'b0000; cnt1 <= 4'b0000; cnt2 <= 4'b0001 + cnt2; cnt3 <= cnt3;
				cnt4 <= cnt4; cnt5 <= cnt5;	cnt6 <= cnt6;
			end 
	else 
		begin 
			if((cnt0 == 4'b1001))  
			begin
				cnt0 <= 4'b0000; cnt1 <= 4'b0001 + cnt1; cnt2 <= cnt2; cnt3 <= cnt3;
				cnt4 <= cnt4; cnt5 <= cnt5; cnt6 <= cnt6;
			end 
	else 
		begin
			cnt0 <= 4'b0001 + cnt0; cnt1 <= cnt1; cnt2 <= cnt2; cnt3 <= cnt3;
			cnt4 <= cnt4; cnt5 <= cnt5; cnt6 <= cnt6;
		end 
	end 
end end end end end 
	else begin 
	if(flag == 1)//溢出清零 
	begin
		cnt0 <= 4'b0000; cnt1 <= 4'b0000; cnt2 <= 4'b0000; cnt3 <= 4'b0000;
		cnt4 <= 4'b0000; cnt5 <= 4'b0000; cnt6 <= 4'b0000;
	end 
	else 
	begin
		flag <= flag + 1; num0 <= cnt0; num1 <= cnt1;
		num2 <= cnt2;num3 <= cnt3; num4 <= cnt4; num5 <= cnt5; num6 <= cnt6;
	end 
end 
end 
end
endmodule
