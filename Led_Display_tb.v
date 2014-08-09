`timescale 1 ns/ 1 ns
module Led_Display_tb();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg clk;
reg [15:0] lednum;
// wires                                               
wire [1:0]  led_com;
wire [7:0]  led_data;

// assign statements (if any)                          
Led_Display i1 (
// port map - connection between master ports and signals/registers   
	.clk(clk),
	.led_com(led_com),
	.led_data(led_data),
	.lednum(lednum)
);
initial                                                
begin                                                  
	clk = 0;
	lednum = 15'b0001_0010_0011_0100;
end                                                    
always                                                              
begin
	#15 clk = ~clk;
end                                                    
endmodule

