module IDEX ( clk, rst, IDEXflush,  
	RegWritei, MemWritei, ALUOpi, ALUSrci, ALUSrcAi, GPRSeli, WDSeli, rti, rdi, shamt32i, Imm32i, RD1i, writedatai, PCi, rsi, MemReadi, NPCOpi,   
	RegWriteo, MemWriteo, ALUOpo, ALUSrco, ALUSrcAo, GPRSelo, WDSelo, rto, rdo, shamt32o, Imm32o, RD1o, writedatao, PCo, rso, MemReado, NPCOpo
);

    input                clk;       // clock
    input                rst;       // reset
    input                RegWritei; // control signal for register write
    input                MemWritei; // control signal for memory write
    input       [3:0]    ALUOpi;    // ALU operation
    input                ALUSrci;   // ALU source for B
    input                ALUSrcAi;  // ALU source for A
    input       [1:0]    GPRSeli;   // general purpose register selection
    input       [1:0]    WDSeli;    // (regsiter) write data selection
    input       [4:0]    rti;       // rt
    input       [4:0]    rdi;       // rd
    input       [31:0]   shamt32i;  // extension for shamt
    input       [31:0]   Imm32i;    // 32-bit immediate
    input       [31:0]   RD1i;      // register data specified by rs
    input       [31:0]   writedatai;// data to data memery
    input       [31:0]   PCi;
    input       [4:0]    rsi;        // rs
    input                MemReadi;
    input       [1:0]    NPCOpi;
    input                IDEXflush;

    output reg           RegWriteo; // control signal for register write
    output reg           MemWriteo; // control signal for memory write
    output reg  [3:0]    ALUOpo;    // ALU operation
    output reg           ALUSrco;   // ALU source for B
    output reg           ALUSrcAo;  // ALU source for A
    output reg  [1:0]    GPRSelo;   // general purpose register selection
    output reg  [1:0]    WDSelo;    // (regsiter) write data selection
    output reg  [4:0]    rto;       // rt
    output reg  [4:0]    rdo;       // rd
    output reg  [31:0]   shamt32o;  // extension for shamt
    output reg  [31:0]   Imm32o;    // 32-bit immediate
    output reg  [31:0]   RD1o;      // register data specified by rs
    output reg  [31:0]   writedatao;// data to data memery
    output reg  [31:0]   PCo;
    output reg  [4:0]    rso;        // rs
    output reg           MemReado;
    output reg  [1:0]    NPCOpo;

    always @( posedge clk, posedge rst)
	    if (rst | IDEXflush)
	    begin
		    RegWriteo <= 1'b0;
	            MemWriteo <= 1'b0;
		    ALUOpo    <= 4'b0;
		    ALUSrco   <= 1'b0;
		    ALUSrcAo  <= 1'b0;
		    GPRSelo   <= 2'b0;
		    WDSelo    <= 2'b0;
		    rto       <= 5'b0;
		    rdo       <= 5'b0;
		    shamt32o  <= 32'b0;
		    Imm32o    <= 32'b0;
		    RD1o      <= 32'b0;
		    writedatao<= 32'b0;
		    PCo       <= 32'b0;
		    rso       <= 5'b0;
		    MemReado  <= 1'b0; 
		    NPCOpo    <= 2'b0;
	    end
	     else
	     begin
		    RegWriteo <= RegWritei; 
	            MemWriteo <= MemWritei;
		    ALUOpo    <= ALUOpi;
		    ALUSrco   <= ALUSrci;
		    ALUSrcAo  <= ALUSrcAi;
		    GPRSelo   <= GPRSeli;
		    WDSelo    <= WDSeli;
		    rto       <= rti;
		    rdo       <= rdi;
		    shamt32o  <= shamt32i;
		    Imm32o    <= Imm32i;
		    RD1o      <= RD1i;
		    writedatao<= writedatai;
		    PCo       <= PCi;
		    rso       <= rsi;
		    MemReado  <= MemReadi;
		    NPCOpo    <= NPCOpi;
	    end


endmodule
