// EE 361
// LEGLite
// 
// * PC and PC Control:  Program Counter and
//         the PC control logic
//--------------------------------------------------------------
// PC and PC Control
module PCLogic(
     output logic [15:0] pc,  // current pc value
     input logic clock, // clock input
     input logic [15:0] signext,	// from sign extend circuit
     input logic uncondbranch,
     input logic branch,	
     input logic alu_zero,	
     input logic reset	
     );
												    
// Program counter pc is updated
//   * if reset = 0 then pc = 0
//   * otherwise pc = pc +2
// What's missing is how pc is updated when a branch occurs

always_ff @(posedge clock)
	begin
	if (reset==1) 
		pc <= 0;
    else if(branch == 1 && alu_zero ==1) 
		pc <= pc + (signext << 1) ;
   	else if( uncondbranch == 1) 
		pc <= pc + (signext << 1) ;
	else 
		pc <= pc+2; // default
	end
		
		
endmodule
