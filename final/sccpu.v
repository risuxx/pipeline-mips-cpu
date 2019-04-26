`include "ctrl_encode_def.v"
module sccpu( clk, rst, instr, readdata, PCt, MemWriteo1, aluouto, writedatao1, reg_sel, reg_data);
         
   input      clk;          // clock
   input      rst;          // reset
   
   input [31:0]  instr;     // instruction
   input [31:0]  readdata;  // data from data memory
   
   output [31:0] PCt;        // PC address for IM
   output        MemWriteo1;  // memory write
   output [31:0] aluouto;    // ALU output
   output [31:0] writedatao1; // data to data memory
   
   input  [4:0] reg_sel;    // register selection (for debug use)
   output [31:0] reg_data;  // selected register data (for debug use)
   
   wire        RegWrite;    // control signal to register write
   wire        EXTOp;       // control signal to signed extension
   wire [3:0]  ALUOp;       // ALU opertion
   wire [1:0]  NPCOp;       // next PC operation

   wire [1:0]  WDSel;       // (register) write data selection
   wire [1:0]  GPRSel;      // general purpose register selection
   
   wire        ALUSrc;      // ALU source for B
   wire        ALUSrcA;     // ALU source for A
   wire        Zero;        // ALU ouput zero

   wire [31:0] NPC;         // next PC

   wire [4:0]  rs;          // rs
   wire [4:0]  rt;          // rt
   wire [4:0]  rd;          // rd
   wire [5:0]  Op;          // opcode
   wire [5:0]  Funct;       // funct
   //wire [4:0]  shamt;       // shamt
   wire [15:0] Imm16;       // 16-bit immediate
   wire [31:0] Imm32;       // 32-bit immediate
   //wire [25:0] IMM;         // 26-bit immediate (address)
   wire [4:0]  A3;          // register address for write
   wire [31:0] WD;          // register write data
   wire [31:0] RD1;         // register data specified by rs
   wire [31:0] B;           // operator for ALU B
   wire [31:0] A;           // operator for ALU A
   wire [31:0] shamt32;     // extension for shamt
   wire [31:0] sreg;        // sreg from registers
   wire [31:0] jumpPC;      // jumpPC for IF
   wire [31:0] PC;          // PC address
   
   //assign shamt = instr[10:6];// shamt
   

   //要将sreg引回IF级

   // for IF
   wire [31:0]  PCt;
   // for IFID
   wire [31:0]  instro;
   wire [31:0]  PCo;
   // for ID
   wire [31:0]  PCt1;
   wire [31:0]  PCt2;
   wire [4:0]   rt1;
   wire         MemWrite;
   wire         MemRead;
   //reg  [1:0]   IFNPCOp;
   // for IDEX
   wire         RegWriteo;
   wire         MemWriteo; 
   wire [3:0]   ALUOpo;
   wire         ALUSrco;
   wire         ALUSrcAo;
   wire [1:0]   GPRSelo;
   wire [1:0]   WDSelo;
   wire [4:0]   rto;
   wire [4:0]   rdo;
   wire [31:0]  shamt32o;
   wire [31:0]  Imm32o;
   wire [31:0]  RD1o;
   wire [31:0]  writedatao;
   wire [31:0]  PCo1;
   wire [4:0]   rso;
   wire         MemReado;
   // for EX
   wire [31:0]  aluout;
   // for EXMEM
   wire         MemWriteo1;
   wire         RegWriteo1;
   wire [1:0]   WDSelo1;
   wire [4:0]   A3o;
   //wire [31:0]  writedatao1;
   //wire [31:0]  aluouto;
   wire         Zeroo;
   wire [31:0]  PCo2;
   // for MEM
   wire [31:0]  writedata;
   // for MEMWB
   wire         RegWriteo2;
   wire [1:0]   WDSelo2;
   wire [31:0]  aluouto1;
   wire [31:0]  readdatao;
   wire [4:0]   A3o1;
   wire         Zeroo1;
   wire [31:0]  PCo3;
   // for dataharazd
   wire [1:0]   ForwardA;
   wire [1:0]   ForwardB;
   wire [31:0]  FA;
   wire [31:0]  FB;
   wire         RegWrite1;
   wire         MemWrite1;
   wire         wpcir;
   wire         stall;
   // for branch
   wire         equal;
   wire         IFIDflush;
   wire         branchwpcir;
   //wire         RegWrite2;
   //wire         MemWrite2;
   wire   [1:0]  NPCOpo;
   wire         IDEXflush;
   wire         isjal;
   wire         nopIFID;
   wire         IFIDflusho;
   wire         PCstall;

   //assign  IDEXflush = ~isjal & IFIDflush;
   assign  IFIDflusho = IFIDflush | nopIFID;
   assign  PCstall = stall & ~nopIFID;
   // IF

   //assign IMM = instr[25:0];    // 26-bit immediate
   assign PC = PCt + 4; 
   // instantiation of PC
   PC U_PC (
   	   .clk(clk), .rst(rst), .NPC(NPC), .PC(PCt), .PCWrite(PCstall)
   );

   // mux for NPC
   mux4 #(32) U_MUX_NPC (
	   .d0(PC), .d1(jumpPC), .d2(jumpPC), .d3(sreg), .s(NPCOp), .y(NPC)
   );

   // IFID
   IFID U_IFID ( 
	   .clk(clk), .rst(rst), .IFIDWrite(stall), .instri(instr), .PCi(PC), .IFIDflush(IFIDflusho), .instro(instro), .PCo(PCo)
   );

   // ID
   assign Op = instro[31:26];  // instruction
   assign Funct = instro[5:0]; // funct
   assign rs = instro[25:21];  // rs
   assign Imm16 = instro[15:0];// 16-bit immediate
   assign sreg = RD1 - 4;         // sreg from registers specially from $31
   assign PCt1 = PCo + {{14{instro[15]}}, instro[15:0], 2'b00};
   assign PCt2 = {PCo[31:28], instro[25:0], 2'b00};
   assign rt1 = instro[20:16];
   assign rt = instro[20:16];
   assign rd = instro[15:11];
   assign shamt32 = {27'b0, instro[10:6]};

   
    // instantiation of control unit
    ctrl U_CTRL (
	    .Op(Op), .Funct(Funct), .Zero(equal), 
	    .RegWrite(RegWrite), .MemWrite(MemWrite), 
	    .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), 
	    .ALUSrc(ALUSrc), .ALUSrcA(ALUSrcA), .GPRSel(GPRSel), .WDSel(WDSel), 
	    .MemRead(MemRead), .isjal(isjal)
    );


    // instantiation of register file
    RF U_RF (
	    .clk(clk), .rst(rst), .RFWr(RegWriteo2), 
	    .A1(rs), .A2(rt1), .A3(A3o1), 
	    .WD(WD), 
	    .RD1(RD1), .RD2(writedata), 
	    .reg_sel(reg_sel), 
	    .reg_data(reg_data)
    );

    // mux for signed extenison or zero extension
    EXT U_EXT (
	    .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32)
    );

    // mux for jumpPC
    mux2 #(32) U_MUX_jumpPC (
	    .d0(PCt1), .d1(PCt2), .s(NPCOp[1]), .y(jumpPC)
    );



   // IDEX
   IDEX U_IDEX( .clk(clk), .rst(rst), .IDEXflush(IDEXflush), 
	   .RegWritei(RegWrite1), .MemWritei(MemWrite1), .ALUOpi(ALUOp), .ALUSrci(ALUSrc), .ALUSrcAi(ALUSrcA), .GPRSeli(GPRSel), .WDSeli(WDSel), .rti(rt), .rdi(rd), .shamt32i(shamt32), .Imm32i(Imm32), .RD1i(RD1), .writedatai(writedata), .PCi(PCo), .rsi(rs), .MemReadi(MemRead), .NPCOpi(NPCOp),  
	   .RegWriteo(RegWriteo), .MemWriteo(MemWriteo), .ALUOpo(ALUOpo), .ALUSrco(ALUSrco), .ALUSrcAo(ALUSrcAo), .GPRSelo(GPRSelo), .WDSelo(WDSelo), .rto(rto), .rdo(rdo), .shamt32o(shamt32o), .Imm32o(Imm32o), .RD1o(RD1o), .writedatao(writedatao), .PCo(PCo1), .rso(rso), .MemReado(MemReado), .NPCOpo(NPCOpo)
   );


   //EX
   // mux for register address to write
    mux4 #(5) U_MUX4_GPR_WD (
	    .d0(rdo), .d1(rto), .d2(5'b11111), .d3(5'b0), .s(GPRSelo), .y(A3)
    ); 


    // mux for ALU B
    mux2 #(32) U_MUX_ALU_B (
	    .d0(FB), .d1(Imm32o), .s(ALUSrco), .y(B)
    );

    // mux for ALU A
    mux2 #(32) U_MUX_ALU_A (
	    .d0(FA), .d1(shamt32o), .s(ALUSrcAo), .y(A)
    );

    // instantiation of alu
    alu U_ALU (
	    .A(A), .B(B), .ALUOp(ALUOpo), .C(aluout), .Zero(Zero)
    );
 


   // EXMEM
   EXMEM U_EXMEM( .clk(clk), .rst(rst), 
	   .MemWritei(MemWriteo), .RegWritei(RegWriteo), .WDSeli(WDSelo), .A3i(A3), .writedatai(FB), .aluouti(aluout), .Zeroi(Zero), .PCi(PCo1), 
	   .MemWriteo(MemWriteo1), .RegWriteo(RegWriteo1), .WDSelo(WDSelo1), .A3o(A3o), .writedatao(writedatao1), .aluouto(aluouto), .Zeroo(Zeroo), .PCo(PCo2)
   );

   // MEMWB
   MEMWB U_MEMWB( .clk(clk), .rst(rst), 
	   .RegWritei(RegWriteo1), .WDSeli(WDSelo1), .aluouti(aluouto), .readdatai(readdata), .A3i(A3o), .Zeroi(Zeroo), .PCi(PCo2), 
	   .RegWriteo(RegWriteo2), .WDSelo(WDSelo2), .aluouto(aluouto1), .readdatao(readdatao), .A3o(A3o1), .Zeroo(Zeroo1), .PCo(PCo3)
   );

   // WB

   // mux for register address to write
    mux4 #(32) U_MUX4_GPR_WD1(
	    .d0(aluouto1), .d1(readdatao), .d2(PCo3+4), .d3(32'b0), .s(WDSelo2), .y(WD)
    );


    // data harazd
    
    // instantiation of bypassunit
    bypassunit U_BYPASSUNIT (
	    .EXMEMrd(A3o), .IDEXrs(rso), .IDEXrt(rto), .MEMWBrd(A3o1), .EXMEMregwrite(RegWriteo1), .MEMWBregwrite(RegWriteo2), .NPCOp(NPCOpo), 
	    .ForwardA(ForwardA), .ForwardB(ForwardB)
    );
    

    // mux for ALU A using ForwardA
    mux4 #(32) U_MUX_ALU_A_ForwardA (
	    .d0(RD1o), .d1(WD), .d2(aluouto), .d3(32'b0), .s(ForwardA), .y(FA)
    );

    // mux for ALU B using ForwardB
    mux4 #(32) U_MUX_ALU_A_ForwardB (
	    .d0(writedatao), .d1(WD), .d2(aluouto), .d3(32'b0), .s(ForwardB), .y(FB)
    );


    // harazd detection unit


    // instantiation of harazd detection unit
    harazddet U_HARAZDDET (
	    .IDEXrt(rto), .IFIDrs(rs), .IFIDrt(rt), .MemRead(MemReado), .NPCOp, .wpcir(wpcir), .branchwpcir(branchwpcir)
    );

     //mux for regwrite
    mux2 #(1) U_MUX_regwrite (
	    .d0(RegWrite), .d1(1'b0), .s(wpcir), .y(RegWrite1)
    );

    // mux for memwrite
    mux2 #(1) U_MUX_memwrite (
	    .d0(MemWrite), .d1(1'b0), .s(wpcir), .y(MemWrite1)
    );

    assign stall = ~wpcir;

    // branch
    
    // instantiation of branch
    branch U_BRANCH (
	    .RD1(RD1), .RD2(writedata), .NPCOp(NPCOp), .equal(equal), .IFIDflush(IFIDflush)
    );

    // mux for flush regwrite
    //mux2 #(1) U_MUX_FLUSH_regwrite (
//	    .d0(RegWrite1), .d1(1'b0), .s(branchwpcir), .y(RegWrite2)
  //  );

    // mux for flush memwrite
    //mux2 #(1) U_MUX_FLUSH_memwrite (
//	    .d0(MemWrite1), .d1(1'b0), .s(branchwpcir), .y(MemWrite2)
  //  );
    
    nop U_NOP (
	    .instr(instr), .rd(rd), .rt(rt), .A3(A3), .A3o(A3o), .GPRSel(GPRSel), 
	    .nopIFID(nopIFID)
    );
   

endmodule
