module PC( clk, rst, NPC, PC, PCWrite);

  input              clk;
  input              rst;
  input       [31:0] NPC;
  input              PCWrite;
  
  output reg  [31:0] PC;

  always @(posedge clk, posedge rst)
    if (rst) 
      PC <= 32'h0000_0000;
//      PC <= 32'h0000_3000;
    else if (PCWrite)
      PC <= NPC;
      
endmodule

