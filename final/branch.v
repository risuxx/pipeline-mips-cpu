module branch (
	RD1, RD2, NPCOp, equal, IFIDflush
);

     input  [31:0]  RD1;
     input  [31:0]  RD2;
     input  [0:1]   NPCOp;

     output         equal;
     output         IFIDflush;

     assign equal = (RD1 == RD2);
     assign IFIDflush = NPCOp[0] | NPCOp[1];


endmodule
