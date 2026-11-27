// L2CInstrInfo.td

include "L2CInstrFormats.td"

// Immediates Operands

// Signed 16 bits Immediate
def SImm16AsmOperand : AsmOperandClass {
    let Name = "SImm16";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
    let DiagnosticString = "immediate must be an integer in the range [-32768, 32767]";
}
def simm16 : Operand<i32> {
  let ParserMatchClass = SImm16AsmOperand;
  let DecoderMethod = "decodeSImm16";
}

// Unsigned 16 bits Immediate
def UImm16AsmOperand : AsmOperandClass {
    let Name = "UImm16";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
    let DiagnosticString = "immediate must be an integer in the range [0, 65535]";
}
def uimm16 : Operand<i32> {
  let ParserMatchClass = UImm16AsmOperand;
  let DecoderMethod = "decodeUImm16";
}

// Unsigned 16 bits Immediate for LUI instr (supports %HI reloc)
def UImm16LUIAsmOperand : AsmOperandClass {
    let Name = "UImm16LUI";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
    let DiagnosticString = "operand must be a symbol with %hi specifier or an integer in the range [0, 65535]";
}
def uimm16_lui : Operand<i32> {
  let ParserMatchClass = UImm16LUIAsmOperand;
  let DecoderMethod = "decodeUImm16";
}

// Unsigned 16 bits Immediate for AUIPC instr (supports %PCREL_HI reloc)
def UImm16AUIPCAsmOperand : AsmOperandClass {
    let Name = "UImm16AUIPC";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
    let DiagnosticString = "operand must be a symbol with %pcrel_hi specifier or an integer in the range [0, 65535]";
}
def uimm16_auipc : Operand<i32> {
  let ParserMatchClass = UImm16AUIPCAsmOperand;
  let DecoderMethod = "decodeUImm16";
}

// Unsigned 5 bits Immediate (for shifts)
def UImm5AsmOperand : AsmOperandClass {
    let Name = "UImm5";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
    let DiagnosticString = "immediate must be an integer in the range [0, 31]";
}
def uimm5 : Operand<i32> {
  let ParserMatchClass = UImm5AsmOperand;
  let DecoderMethod = "decodeUImm5";
}

// Signed 16 bits Immediate for Branch targets (must be multiple of 4)
def BrTarget16AsmOperand : AsmOperandClass {
    let Name = "BrTarget16";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
    let DiagnosticString = "branch target must be a multiple of 4 in the range [-131072, 131068]";
}
def brtarget16 : Operand<i32> {
    let ParserMatchClass = BrTarget16AsmOperand;
    let DecoderMethod = "decodeSImmLsl2<16>";
    let EncoderMethod = "getBranchTargetOpValue";
    let OperandType = "OPERAND_PCREL";
    let PrintMethod = "printBranchOperand";
}

// Signed 26 bits Immediate for Jump targets (must be multiple of 4)
def JmpTarget26AsmOperand : AsmOperandClass {
    let Name = "JmpTarget26";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
    let DiagnosticString = "jump target must be a multiple of 4 in the range [-134217728, 134217724]";
}
def jmptarget26 : Operand<i32> {
    let ParserMatchClass = JmpTarget26AsmOperand;
    let DecoderMethod = "decodeSImmLsl2<26>";
    let EncoderMethod = "getJumpTargetOpValue";
    let OperandType = "OPERAND_PCREL";
    let PrintMethod = "printBranchOperand";
}

// Unsigned 16 bits Immediate for CSR System Registers
def CSRSysRegAsmOperand : AsmOperandClass {
    let Name = "CSRSysReg";
    // let PredicateMethod = "isUImm16";
    let ParserMethod = "parseCSRSystemRegister";
    let RenderMethod = "addSysRegOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
    let DiagnosticString = "operand must be a valid system register name or an integer in the range [0, 65535]";
}
def csr_sysreg : Operand<i32> {
    let ParserMatchClass = CSRSysRegAsmOperand;
    let DecoderMethod = "decodeUImm16";
    let PrintMethod = "printCSRSystemRegister";
}

// Load Immediate for Pseudo Instructions
def LIImmAsmOperand : AsmOperandClass {
    let Name = "LIImm";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
    let DiagnosticString = "immediate must be an integer in the range [-2147483648, 4294967295]";
}
def li_imm : Operand<i32> {
    let ParserMatchClass = LIImmAsmOperand;
}

// Bare Symbol operand for the LA, CALL and TAIL instructions
def BareSymbolAsmOperand : AsmOperandClass {
    let Name = "BareSymbol";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = "InvalidBareSymbol";
    let DiagnosticString = "operand must be a bare symbol name";
}
def bare_symbol : Operand<i32> {
    let ParserMatchClass = BareSymbolAsmOperand;
}


// ALU Register-Register Ops
class ALU_rr<bits<6> opcode, string opcodestr, bit Commutable = 0>
    : L2CInstR<opcode, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2", []>
{
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;
    let isCommutable = Commutable;
}

def ADD  : ALU_rr<0b000001, "add", Commutable=1>;
def SUB  : ALU_rr<0b000010, "sub"  >;
def AND  : ALU_rr<0b000011, "and", Commutable=1>;
def OR   : ALU_rr<0b000100, "or",  Commutable=1>;
def XOR  : ALU_rr<0b000101, "xor", Commutable=1>;
def SLL  : ALU_rr<0b000110, "sll"  >;
def SRL  : ALU_rr<0b000111, "srl"  >;
def SRA  : ALU_rr<0b001000, "sra"  >;
def SLT  : ALU_rr<0b001001, "slt"  >;
def SLTU : ALU_rr<0b001010, "sltu" >;
def MUL  : ALU_rr<0b001011, "mul"  >;


// System Ops
class System<bits<6> opcode, string opcodestr>
    : L2CInstR<opcode, (outs), (ins), opcodestr, "", []>
{
    let hasSideEffects = 1;
    let mayLoad = 0;
    let mayStore = 0;

    let rd = 0;
    let rs1 = 0;
    let rs2 = 0;
}

def ECALL  : System<0b111011, "ecall" >;
def EBREAK : System<0b111100, "ebreak">;
def ERET   : System<0b111101, "eret"  >;


// ALU Register Signed Immediate Ops
class ALU_rsi<bits<6> opcode, string opcodestr>
    : L2CInstI<opcode, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm16), opcodestr, "$rd, $rs1, $imm16", []>
{
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;
}

def ADDI  : ALU_rsi<0b010001, "addi" >;
def SLTI  : ALU_rsi<0b011001, "slti" >;
def SLTIU : ALU_rsi<0b011010, "sltiu">;


// ALU Register Unsigned Immediate Ops
class ALU_rui<bits<6> opcode, string opcodestr>
    : L2CInstI<opcode, (outs GPR:$rd), (ins GPR:$rs1, uimm16:$imm16), opcodestr, "$rd, $rs1, $imm16", []>
{
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;
}

def ANDNI : ALU_rui<0b010010, "andni">;
def ANDI  : ALU_rui<0b010011, "andi" >;
def ORI   : ALU_rui<0b010100, "ori"  >;
def XORI  : ALU_rui<0b010101, "xori" >;


// ALU Register Shift Immediate Ops
class ALU_rshifti<bits<6> opcode, string opcodestr>
    : L2CInstI<opcode, (outs GPR:$rd), (ins GPR:$rs1, uimm5:$shamt), opcodestr, "$rd, $rs1, $shamt", []>
{
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;

    bits<5> shamt;
    let Inst{31-21} = 0;
    let Inst{20-16} = shamt;
}

def SLLI : ALU_rshifti<0b010110, "slli">;
def SRLI : ALU_rshifti<0b010111, "srli">;
def SRAI : ALU_rshifti<0b011000, "srai">;


// Upper Ops
class Upper<bits<6> opcode, string opcodestr, DAGOperand imm_op>
    : L2CInstI<opcode, (outs GPR:$rd), (ins imm_op:$imm16), opcodestr, "$rd, $imm16", []>
{
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;

    let rs1 = 0;
}

def LUI   : Upper<0b010000, "lui"  , uimm16_lui>;
def AUIPC : Upper<0b011011, "auipc", uimm16_auipc>;


// CSR Read
class CSRRead<bits<6> opcode, string opcodestr>
    : L2CInstI<opcode, (outs GPR:$rd), (ins csr_sysreg:$imm16), opcodestr, "$rd, $imm16", []>
{
    let hasSideEffects = 1;
    let mayLoad = 0;
    let mayStore = 0;

    let rs1 = 0;
}

def CSRR : CSRRead<0b011100, "csrr">;


// CSR Write
class CSRWrite<bits<6> opcode, string opcodestr>
    : L2CInstI<opcode, (outs), (ins csr_sysreg:$imm16, GPR:$rs1), opcodestr, "$imm16, $rs1", []>
{
    let hasSideEffects = 1;
    let mayLoad = 0;
    let mayStore = 0;

    let rd = 0;
}

def CSRW : CSRWrite<0b011101, "csrw">;


// Load Ops
class Load<bits<6> opcode, string opcodestr>
    : L2CInstI<opcode, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm16), opcodestr, "$rd, ${imm16}(${rs1})", []>
{
    let hasSideEffects = 0;
    let mayLoad = 1;
    let mayStore = 0;
}

def LB  : Load<0b100000, "lb" >;
def LH  : Load<0b100001, "lh" >;
def LW  : Load<0b100010, "lw" >;
def LBU : Load<0b100100, "lbu">;
def LHU : Load<0b100101, "lhu">;


// Store Ops
class Store<bits<6> opcode, string opcodestr>
    : L2CInstB<opcode, (outs), (ins GPR:$rs2, GPR:$rs1, simm16:$imm16), opcodestr, "$rs2, ${imm16}(${rs1})", []>
{
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 1;
}

def SB : Store<0b101000, "sb">;
def SH : Store<0b101001, "sh">;
def SW : Store<0b101010, "sw">;


// Branch Ops
class Branch<bits<6> opcode, string opcodestr>
    : L2CInstB<opcode, (outs), (ins GPR:$rs1, GPR:$rs2, brtarget16:$imm16), opcodestr, "$rs1, $rs2, $imm16", []>
{
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;
    let isBranch = 1;
    let isTerminator = 1;
}

def BEQ  : Branch<0b110000, "beq" >;
def BNE  : Branch<0b110001, "bne" >;
def BLT  : Branch<0b110100, "blt" >;
def BGE  : Branch<0b110101, "bge" >;
def BLTU : Branch<0b110110, "bltu">;
def BGEU : Branch<0b110111, "bgeu">;


// Jump / Jump and Link
def J   : L2CInstJ<0b111010, (outs), (ins jmptarget26:$imm26), "j",   "$imm26", []> {
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;
    
    let isBranch = 1;
    let isTerminator = 1;
    let isBarrier = 1;
}
def JAL : L2CInstJ<0b111000, (outs), (ins jmptarget26:$imm26), "jal", "$imm26", []> {
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;

    let isCall = 1;
    let Defs = [R31];
}


// Jump and Link Register
def JALR : L2CInstI<0b111001, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm16), "jalr", "$rd, $rs1, $imm16", []> {
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;
}


// Alias Instructions

def : InstAlias<"nop", (ADD R0, R0, R0), 1>;

def : InstAlias<"mv $rd, $rs",   (ADDI  GPR:$rd,  GPR:$rs,  0       )>;
def : InstAlias<"neg $rd, $rs",  (SUB   GPR:$rd,  R0,       GPR:$rs )>;
def : InstAlias<"seqz $rd, $rs", (SLTIU GPR:$rd,  GPR:$rs,  1       )>;
def : InstAlias<"snez $rd, $rs", (SLTU  GPR:$rd,  R0,       GPR:$rs )>;
def : InstAlias<"sltz $rd, $rs", (SLT   GPR:$rd,  GPR:$rs,  R0      )>;
def : InstAlias<"sgtz $rd, $rs", (SLT   GPR:$rd,  R0,       GPR:$rs )>;


def : InstAlias<"beqz $rs, $imm16", (BEQ  GPR:$rs,  R0,      brtarget16:$imm16 )>;
def : InstAlias<"bnez $rs, $imm16", (BNE  GPR:$rs,  R0,      brtarget16:$imm16 )>;
def : InstAlias<"bltz $rs, $imm16", (BLT  GPR:$rs,  R0,      brtarget16:$imm16 )>;
def : InstAlias<"bgez $rs, $imm16", (BGE  GPR:$rs,  R0,      brtarget16:$imm16 )>;
def : InstAlias<"blez $rs, $imm16", (BGE  R0,       GPR:$rs, brtarget16:$imm16 )>;
def : InstAlias<"bgtz $rs, $imm16", (BLT  R0,       GPR:$rs, brtarget16:$imm16 )>;

def : InstAlias<"bgt $rs, $rt, $imm16",  (BLT  GPR:$rt, GPR:$rs, brtarget16:$imm16), 0>;
def : InstAlias<"ble $rs, $rt, $imm16",  (BGE  GPR:$rt, GPR:$rs, brtarget16:$imm16), 0>;
def : InstAlias<"bgtu $rs, $rt, $imm16", (BLTU GPR:$rt, GPR:$rs, brtarget16:$imm16), 0>;
def : InstAlias<"bleu $rs, $rt, $imm16", (BGEU GPR:$rt, GPR:$rs, brtarget16:$imm16), 0>;

def : InstAlias<"jalr $rs", (JALR R31, GPR:$rs, 0), 1>;
def : InstAlias<"jr $rs",   (JALR R0,  GPR:$rs, 0), 1>;
def : InstAlias<"ret",      (JALR R0,  R31,     0), 2>;


// Pseudo Instructions

def PseudoLI  : PseudoInst<(outs GPR:$rd), (ins li_imm:$imm), "li",  "$rd, $imm">;
def PseudoNOT : PseudoInst<(outs GPR:$rd), (ins GPR:$rs),     "not", "$rd, $rs">;

def PseudoLA   : PseudoInst<(outs GPR:$rd), (ins bare_symbol:$sym), "la",   "$rd, $sym">;
def PseudoCALL : PseudoInst<(outs), (ins bare_symbol:$sym), "call", "$sym"> {
  let isCall = 1;
  let Defs = [R31];
}
def PseudoTAIL : PseudoInst<(outs), (ins bare_symbol:$sym), "tail", "$sym"> {
  let isCall = 1;
  let isTerminator = 1;
  let isReturn = 1;
  let isBarrier = 1;
  let Defs = [R9];   // t0
}
