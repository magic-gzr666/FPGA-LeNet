`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 02:41:40
// Design Name: 
// Module Name: FloatReciprocal16
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module FloatReciprocal16(
    clk,
    reset,
    number,
    output_rec,
    ack
);

    parameter DATA_WIDTH=16;
    
    input clk,reset;
    input number;
    output output_rec;
    output ack;
    
    wire [DATA_WIDTH-1:0] number; //the number that we need to get the 1/number of 
    reg[DATA_WIDTH-1:0] output_rec; // = 1/number
    reg ack;

    wire [DATA_WIDTH-1:0] Ddash; // D' = Mantissa of D and exponent of -1
    wire [DATA_WIDTH-1:0] P2Ddash; // (-32/17) * D'
    wire [DATA_WIDTH-1:0] Xi ; // X[i]= 43/17 - (32/17)D'
    wire [DATA_WIDTH-1:0] Xip1; //X[i+1]
    wire [DATA_WIDTH-1:0] out0; // Xi*D
    wire [DATA_WIDTH-1:0] out1; // 1-Xi*D
    wire [DATA_WIDTH-1:0] out2; // X*(1-Xi*D)
    reg  [DATA_WIDTH-1:0] mux;

    localparam P1=16'b0100000100001111; // 43/17
    localparam P2=16'b1011111110000111; // -32/17

    assign Ddash={{1'b0,5'b01110},number[9:0]};

    FloatMult16 FM1 (P2,Ddash,P2Ddash); // -(32/17)* D'
    FloatAdd16 FADD1 (P2Ddash,P1,Xi); // 43/17 * (-32/17)D'
    FloatMult16 FM2 (mux,Ddash,out0); // Xi*D'
    FloatAdd16 FSUB1 (16'b0011110000000000,{1'b1,out0[DATA_WIDTH-2:0]},out1); // 1-Xi*D
    FloatMult16 FM3 (mux,out1,out2); // X*(1-Xi*D)
    FloatAdd16 FADD2 (mux,out2,Xip1); //Xi+Xi*(1-D*Xi)

    always @ (posedge clk or posedge reset) begin
	   if (reset == 1) begin
		  mux=Xi;
		  ack=1'b0;
		  output_rec = 0;
	   end
	   else begin 
		  if(mux==Xip1) begin
			 ack=1'b1; //set ack bit to show that the division is done
			 output_rec={{number[15],5'd14-number[14:10] + mux[14:10]},Xip1[9:0]}; //sign of number, new exponent, mantissa of Xip1
		  end 
		  else begin
			 mux=Xip1; //continue until ack is 1
		  end
	   end
    end

endmodule




