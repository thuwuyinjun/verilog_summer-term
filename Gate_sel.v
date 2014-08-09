module Gate_sel(rst,gate_sel1,gate_sel2,
gate_sel3,div_1hz,div_10hz,div_100hz,
div_1khz,gate_out,err,scan_signal,flag);
input rst,gate_sel1,gate_sel2,gate_sel3,
div_1hz,div_10hz,div_100hz,div_1khz;
output reg gate_out,err;
output wire scan_signal;
output reg [1:0] flag;
reg gate;
always @(posedge div_1khz or negedge rst)
begin
	if(!rst) 
		begin
			gate <= 0;
			err <= 1;
			flag <= 2'b00;
		end
	else begin
		if(gate_sel1 == 1 && gate_sel2 == 0 && gate_sel3 == 0)
			begin
				gate <= div_1hz;
				flag = 2'b01;
				err <= 1;
			end
		else if(gate_sel1 == 0 && gate_sel2 == 1 && gate_sel3 == 0)
			begin
				gate <= div_10hz;
				flag = 2'b10;
				err <= 1;
			end
				else if(gate_sel1 == 0 && gate_sel2 == 0 && gate_sel3 == 1)
			begin
				gate <= div_100hz;
				flag = 2'b11;
				err <= 1;
			end
		else
			begin
				err <= 0;
			end
	end
end
assign scan_signal = div_1khz;
always @(posedge gate or negedge rst)
begin
	if(!rst) begin
		gate_out <= 0;
	end
	else begin
		gate_out <= ~gate_out;
		end
end
endmodule
	