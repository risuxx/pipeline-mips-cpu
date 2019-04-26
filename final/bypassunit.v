module bypassunit (
	EXMEMrd, IDEXrs, IDEXrt, MEMWBrd, EXMEMregwrite, MEMWBregwrite, NPCOp, 
	ForwardA, ForwardB
);

    input       [4:0]   EXMEMrd;       // EX/MEM.RegisterRd
    input       [4:0]   IDEXrs;        // ID/EX.RegisterRs
    input       [4:0]   IDEXrt;        // ID/EX.RegisterRt
    input       [4:0]   MEMWBrd;       // MEM/WB.RegisterRd
    input               EXMEMregwrite; // EX/MEM.RegWrite
    input               MEMWBregwrite; // MEMWBregwrite
    input       [1:0]   NPCOp;

    output reg  [1:0]   ForwardA; 
    output reg  [1:0]   ForwardB;

    always @(*) begin
	    ForwardA = 2'b0;
            ForwardB = 2'b0;
	    if (EXMEMregwrite & (EXMEMrd[0] | EXMEMrd[1] | EXMEMrd[2] | EXMEMrd[3] | EXMEMrd[4])) begin
		    if (EXMEMrd == IDEXrs) begin
			    ForwardA <= 2'b10;
		    end
		    if (EXMEMrd == IDEXrt) begin
			    ForwardB <= 2'b10;
		    end
	    end
	    if (MEMWBregwrite & (EXMEMrd[0] | EXMEMrd[1] | EXMEMrd[2] | EXMEMrd[3] | EXMEMrd[4])) begin
		    if (EXMEMrd != IDEXrs && MEMWBrd == IDEXrs) begin
			    ForwardA <= 2'b01;
		    end
		    if (EXMEMrd != IDEXrt && MEMWBrd == IDEXrt) begin
			    ForwardB <= 2'b01;
		    end
	    end
	
	    if (NPCOp[0] | NPCOp[1]) begin
		    ForwardA = 2'b0;
		    ForwardB = 2'b0;
            end
    end


endmodule
