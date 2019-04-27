module nop (instr, rd, rt, A3, A3o, GPRSel, 
	nopIFID
);

     input  [31:0]  instr;
     input  [4:0]   rd;
     input  [4:0]   rt;
     input  [4:0]   A3;
     input  [4:0]   A3o;
     input  [1:0]   GPRSel;

     output         nopIFID;

     wire   [4:0]   rstemp;
     wire   [4:0]   rttemp;
     wire   [5:0]   Op = instr[31:26];
     wire           rtype = ~|Op;
     wire   [5:0]   Funct = instr[5:0];
     wire   [4:0]   A1;
     
     wire i_jr   = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // jr
     wire i_bne  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]& Op[0]; // bne
     wire i_beq  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; // beq
     wire i_sw   =  Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0]; // sw


     // mux for register address to write
    mux4 #(5) U_MUX4_GPR_WD (
	    .d0(rd), .d1(rt), .d2(5'b11111), .d3(5'b0), .s(GPRSel), .y(A1)
    ); 


     assign rstemp = instr[25:21];
     assign rttemp = instr[20:16];
     assign nopIFID = ((i_bne | i_beq) & (((rstemp == A1 | rttemp == A1) & A1 != 5'b0) | ((rstemp == A3 | rttemp == A3) & A3 != 5'b0) | ((rstemp == A3o | rttemp == A3o) & A3o != 5'b0))) | (i_jr & ((rstemp == A1 & A1 != 5'b0) | (rstemp == A3 & A3 != 5'b0) | (rstemp == A3o & A3o != 5'b0))) | (i_sw & (rttemp == A1 | rttemp == A3 | rttemp == A3o)); 

endmodule
