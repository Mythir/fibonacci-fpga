`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2023 16:12:36
// Design Name: 
// Module Name: spiclk
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


module spiclk(input wire clk);
   STARTUPE2 STARTUPE2
     (.CLK(1'b0),
      .GSR(1'b0),
      .GTS(1'b0),
      .KEYCLEARB(1'b1),
      .PACK(1'b0),
      .PREQ(),

      // Drive clock.
      .USRCCLKO(clk),
      .USRCCLKTS(1'b0),

      // These control the DONE pin.  UG470 says USRDONETS should
      // usually be low to enable DONE output.  But by default
      // (i.e. when the STARTUPE2 is not instaintiated), the DONE pin
      // goes to hi-z after initialization.  This is how to do that.
      .USRDONEO(1'b0),
      .USRDONETS(1'b1),

      .CFGCLK(),
      .CFGMCLK(),
      .EOS());
endmodule
