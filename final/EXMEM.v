module EXMEM( clk, rst, 
	MemWritei, RegWritei, WDSeli, A3i, writedatai, aluouti, Zeroi, PCi, 
	MemWriteo, RegWriteo, WDSelo, A3o, writedatao, aluouto, Zeroo, PCo
	);

    input                clk;         // clock
    input                rst;         // reset 
    input                MemWritei;   // control signal for memory write
    input                RegWritei;   // control signal for register write
    input         [1:0]  WDSeli;      // (register) write data selection
    input         [4:0]  A3i;         // data address for registers
    input         [31:0] writedatai;  // data to data memory
    input         [31:0] aluouti;     // ALU ouput
    input                Zeroi;        
    input         [31:0] PCi;

    output  reg          MemWriteo;   // control signal for memory write
    output  reg          RegWriteo;   // control signal for register write
    output  reg   [1:0]  WDSelo;      // (register) write data selection
    output  reg   [4:0]  A3o;         // data address for registers
    output  reg   [31:0] writedatao;  // data to data memory
    output  reg   [31:0] aluouto;     // ALU output
    output  reg          Zeroo;       
    output  reg   [31:0] PCo;


   always @(posedge clk, posedge rst)
	   if(rst)
	   begin
		   MemWriteo <= 1'b0;
	           RegWriteo <= 1'b0;
		   WDSelo    <= 2'b0;
		   A3o       <= 5'b0;
		   writedatao<= 32'b0;
		   aluouto   <= 32'b0;
		   Zeroo     <= 1'b0;
		   PCo       <= 32'b0;
	   end
	    else
	    begin
		   MemWriteo <= MemWritei;
	           RegWriteo <= RegWritei;
		   WDSelo    <= WDSeli;
		   A3o       <= A3i;
		   writedatao<= writedatai;
		   aluouto   <= aluouti;
		   Zeroo     <= Zeroi;
		   PCo       <= PCi;
	   end


endmodule
