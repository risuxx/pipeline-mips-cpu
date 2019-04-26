module MEMWB( clk, rst, 
	RegWritei, WDSeli, aluouti, readdatai, A3i, Zeroi, PCi, 
	RegWriteo, WDSelo, aluouto, readdatao, A3o, Zeroo, PCo
);

     input                clk;         // clock
     input                rst;         // reset
     input                RegWritei;   // control signal to register write
     input         [1:0]  WDSeli;      // (register) write data selection
     input         [31:0] aluouti;     // ALU output
     input         [31:0] readdatai;   // data from data memory
     input         [4:0]  A3i;         // data address for registers
     input                Zeroi;
     input         [31:0] PCi;

     output  reg          RegWriteo;   // control signal to register write
     output  reg   [1:0]  WDSelo;      // (register) write data selection
     output  reg   [31:0] aluouto;     // ALU output
     output  reg   [31:0] readdatao;   // data from data memory
     output  reg   [4:0]  A3o;         // data address for registers
     output  reg          Zeroo;
     output  reg   [31:0] PCo;

     always @(posedge clk, posedge rst)
	     if(rst)
	     begin
		     RegWriteo  <= 1'b0;
	             WDSelo     <= 2'b0;
		     aluouto    <= 32'b0;
		     readdatao  <= 32'b0;
		     A3o        <= 5'b0;
		     Zeroo      <= 1'b0;
		     PCo        <= 32'b0;
	     end
	     else
	     begin
		     RegWriteo  <= RegWritei;
	             WDSelo     <= WDSeli;
		     aluouto    <= aluouti;
		     readdatao  <= readdatai;
		     A3o        <= A3i;
		     Zeroo      <= Zeroi;
		     PCo        <= PCi;
	     end


endmodule
