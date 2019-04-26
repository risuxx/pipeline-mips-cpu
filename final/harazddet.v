module harazddet (IDEXrt, IFIDrs,IFIDrt, MemRead, NPCOp, wpcir, branchwpcir);
    
    input  [4:0]  IDEXrt;
    input  [4:0]  IFIDrs;
    input  [4:0]  IFIDrt;
    input         MemRead;
    input  [1:0]  NPCOp;

    output        wpcir;
    output        branchwpcir;

    assign wpcir = MemRead & ((IDEXrt == IFIDrs) | (IDEXrt == IFIDrt));
    assign branchwpcir = NPCOp[0] | NPCOp[1];


endmodule
