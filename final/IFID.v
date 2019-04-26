module IFID( clk, rst, IFIDWrite, instri, PCi, IFIDflush, instro, PCo);

   input              clk;     //clock
   input              rst;     //reset
   input              IFIDWrite;  //IFWrite
   input       [31:0] instri;  //input instr
   input       [31:0] PCi;     //input PC
   input              IFIDflush;

   output reg  [31:0] instro;  //output instr
   output reg  [31:0] PCo;     //output PC 

   always @(posedge clk, posedge rst)
	   if (rst | IFIDflush)//if rst or IFflush set the output to 0
	   begin
		   instro <= 32'b0;
	           PCo    <= 32'b0;
	   end
	   else if (IFIDWrite)
	   begin
		         instro <= instri;
	           PCo    <= PCi;
	   end

endmodule
