module Divider(div_1hz,div_10hz,div_100hz,div_1khz,clk,rst);
input clk;
input rst;
output reg div_1hz,div_10hz,div_100hz,div_1khz;
reg [29:0]cnt1,cnt2,cnt3,cnt4;
always @(posedge clk or negedge rst)
  begin
    if (rst == 1'b0)
      begin
        div_1hz <=1'b0;
		  div_10hz <=1'b0;
		  div_100hz <=1'b0;
		  div_1khz <=1'b0;
        cnt1 <='b0;
		  cnt2 <='b0;
		  cnt3 <='b0;
		  cnt4 <='b0;
      end
    else
      begin
        if(cnt1==25000000)
          begin
            div_1hz <= ~div_1hz;
            cnt1 <= 'b0;
          end
        else
          begin
            cnt1 <= cnt1 + 1'b1;
          end
			if(cnt2==2500000)
          begin
            div_10hz <= ~div_10hz;
            cnt2 <= 'b0;
          end
        else
          begin
            cnt2 <= cnt2 + 1'b1;
          end
			if(cnt3==250000)
          begin
            div_100hz <= ~div_100hz;
            cnt3 <= 'b0;
          end
        else
          begin
            cnt3 <= cnt3 + 1'b1;
          end
			if(cnt4==25000)
          begin
            div_1khz <= ~div_1khz;
            cnt4 <= 'b0;
          end
        else
          begin
            cnt4 <= cnt4 + 1'b1;
          end
      end
  end
endmodule 