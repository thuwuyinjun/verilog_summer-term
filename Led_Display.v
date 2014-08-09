module Led_Display(  //4位数码管显示子模块
        input wire clk, //时钟250Hz
        input wire [15:0] lednum, //由运算器输出的4数码管显示数字的BCD码
        output reg [7:0] led_data, //数码管段码数据接口
        output reg [1:0] led_com //数码管位选接口
        );
        
        reg [3:0] led_BCD = 4'h0; //待输出数码管BCD码
        reg [1:0] count = 2'd0; //数码管位扫描
        
        always @ (posedge clk) begin //动态扫描4位数码管显示,刷新频率62.5Hz
                count = count + 1'b1; //位扫描
        end
        
        always @ (count,lednum) begin
                case (count) //数码管当前位段码
                        2'd3: 
								begin
									led_BCD[3:0] = lednum[15:12]; //第1位（最高）
									led_com = 2'b11;
								end
                        2'd2:
								begin
									led_BCD[3:0] = lednum[11:8]; //第2位
									led_com = 2'b10;
								end
                        2'd1:
								begin
									led_BCD[3:0] = lednum[7:4]; //第3位
									led_com = 2'b01;
								end
                        2'd0:
								begin
									led_BCD[3:0] = lednum[3:0]; //第4位（最低）
									led_com = 2'b00;
								end
                endcase
        end
 
        always @ (led_BCD) begin
                case (led_BCD) //共阳极数码管段码数据输出
                        4'h0: led_data[7:0] = 8'b1100_0000; //显示数字0
                        4'h1: led_data[7:0] = 8'b1111_1001; //显示数字1
                        4'h2: led_data[7:0] = 8'b1010_0100; //显示数字2
                        4'h3: led_data[7:0] = 8'b1011_0000; //显示数字3
                        4'h4: led_data[7:0] = 8'b1001_1001; //显示数字4
                        4'h5: led_data[7:0] = 8'b1001_0010; //显示数字5
                        4'h6: led_data[7:0] = 8'b1000_0010; //显示数字6
                        4'h7: led_data[7:0] = 8'b1111_1000; //显示数字7
                        4'h8: led_data[7:0] = 8'b1000_0000; //显示数字8
                        4'h9: led_data[7:0] = 8'b1001_0000; //显示数字9
                        4'hA: led_data[7:0] = 8'b1000_1000; //显示数字A
                        4'hB: led_data[7:0] = 8'b1000_0011; //显示数字B
                        4'hC: led_data[7:0] = 8'b1100_0110; //显示数字C
                        4'hD: led_data[7:0] = 8'b1010_0001; //显示数字D
                        4'hE: led_data[7:0] = 8'b1000_0110; //显示数字E
                        4'hF: led_data[7:0] = 8'b1000_1110; //显示数字F
                        default: led_data[7:0] = 8'b1111_1111; //不显示
                endcase
        end
                
endmodule