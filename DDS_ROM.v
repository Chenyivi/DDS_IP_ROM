`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: nhike
// Engineer: chenyivi
// 
// Create Date: 2019/11/03 19:25:35
// Design Name:DDS_ROM_IP 
// Module Name: DDS_ROM
// Project Name: DDS_ROM_IP
// Target Devices: zynq7010
// Tool Versions:1.0 
// Description: WaveFrom
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DDS_ROM(
	clk,
	rst_n,
	Freword,
	Phaword,
	WaveDataOut
  );
	
	parameter 	FrequencyBitWidth = 32;       
	parameter 	PhaseBitWidth =10;
	parameter 	DataOutBitWidth= 10;
	
	input clk;
    input rst_n;
    input 	[FrequencyBitWidth-1:0] Freword;
    input 	[PhaseBitWidth-1:0]		Phaword;
    output 	[DataOutBitWidth-1:0] 	WaveDataOut;
    
	reg 	[FrequencyBitWidth-1:0]	Freword_temp;
	reg 	[PhaseBitWidth-1:0]		Phaword_temp;
	wire 	[PhaseBitWidth-1:0]		WaveAddData;
	
	always@(posedge clk or negedge rst_n)begin  	//data latch.
		if(!rst_n)begin
			Freword_temp <= 32'b0;
			Phaword_temp <= 10'b0;
			end
		else begin
			Freword_temp <= Freword;
			Phaword_temp <= Phaword;	
			end
	end
	
	reg [FrequencyBitWidth-1:0] cnt;
	
	always @(posedge clk or negedge rst_n)begin		//Sampling control.
		if(!rst_n)
			cnt <= 0;
		else
			cnt <= cnt + Freword_temp;
	end
	
	assign WaveAddData = cnt[FrequencyBitWidth-1:FrequencyBitWidth-(DataOutBitWidth + 1)] + Phaword_temp;   //Data precision interception
	
	WaveRom WaveRomBase (
	  .clka(clk),   
	  .addra(WaveAddData),  
	  .douta(WaveDataOut)  
	);
	
endmodule

