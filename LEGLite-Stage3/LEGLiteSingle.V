// EE 361
// LEGLite Single Cycle
// 
// Obviously, it's incomplete.  Just the ports are defined.
//

module LEGLiteSingle(
	iaddr,		// Program memory address.  This is the program counter
	daddr,		// Data memory address
	dwrite,		// Data memory write enable
	dread,		// Data memory read enable
	dwdata,		// Data memory write output
	alu_out,	// Output of alu for debugging purposes
	clock,
	idata,		// Program memory output, which is the current instruction
	ddata,		// Data memory output
	reset,
	probe
	);

output [15:0] iaddr; 	//PC
output [15:0] daddr;	//ALU Output
output dwrite;			//Mem Writ EN
output dread;			//Mem Read EN
output [15:0] dwdata;	//Write data or read data 2 from reg
output [15:0] alu_out;	//ALU OUT
input clock;			//CLK
input [15:0] idata; 	//Instructions 
input [15:0] ddata;		//Read data from memory
input reset;
output [15:0] probe;
	
//Create wires for control modules	
wire reg2loc;
wire uncondbranch;
wire branch;
wire memtoreg;
wire [2:0] alu_selec;
wire alusrc;
wire regwrite;

//Create wires for register
wire [15:0] rdata1;
wire [15:0] rdata2;
wire [15:0] readReg1;
wire [15:0] readReg2;
wire [15:0] writeDataReg;
 
//create wires for ALU
wire [15:0] ALU_input2;
wire  mainALU_z_out;
assign alu_out = daddr;

//signextension
wire [15:0] signextension;
assign signextension = {{10{idata[11]}}, idata[11:6]};

//debugging
assign probe = signextension;

//Wires to mem
assign dwdata = rdata2;

Control legv8_control(
	reg2loc, 
	uncondbranch, 
	branch, 
	dread, 
	memtoreg, 
	alu_selec, 
	dwrite, 
	alusrc , 
	regwrite, 
	{idata [15:12]}
	);

RegFile legv8_register(
	rdata1, 
	rdata2, 
	clock, 
	writeDataReg, 
	{idata [2:0]}, 
	{idata [5:3]}, //raddress2
	readReg2[2:0], 		//raddress1
	regwrite
	);


MUX2 reg2loc_mux(
	readReg2, 
	{{13'b0},idata [11:9]}, 
	{{13'b0},idata [2:0]}, 
	reg2loc
	);

MUX2 alusrc_mux(
	ALU_input2, 
	rdata2, 
	signextension, 
	alusrc
	);
	
MUX2 memtoreg_mux(
	writeDataReg,
	daddr,
  	ddata,
	memtoreg
	);
	
ALU legv8_mainALU(
	daddr,
	mainALU_z_out,
	rdata1,
	ALU_input2,
	alu_selec
	);

	
PCLogic legv8_pclogic(
	iaddr,
	clock,
	signextension,
	uncondbranch,
	branch,
	mainALU_z_out,
	reset
	);

endmodule
