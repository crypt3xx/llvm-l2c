// L2CInstrInfo.td

include "L2CInstrFormats.td"

// Immediates Operands

// Signed 16 bits Immediate
def SImm16AsmOperand : AsmOperandClass {
    let Name = "SImm16";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = "InvalidSImm16";
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
    let DiagnosticType = "InvalidUImm16";
    let DiagnosticString = "immediate must be an integer in the range [0, 65535]";
}
def uimm16 : Operand<i32> {
  let ParserMatchClass = UImm16AsmOperand;
  let DecoderMethod = "decodeUImm16";
}

// Unsigned 5 bits Immediate (for shifts)
def UImm5AsmOperand : AsmOperandClass {
    let Name = "UImm5";
    let RenderMethod = "addImmOperands";
    let DiagnosticType = "InvalidUImm5";
    let DiagnosticString = "immediate must be an integer in the range [0, 31]";
}
def uimm5 : Operand<i32> {
  let ParserMatchClass = UImm5AsmOperand;
  let DecoderMethod = "decodeUImm5";
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
class Upper<bits<6> opcode, string opcodestr>
    : L2CInstI<opcode, (outs GPR:$rd), (ins uimm16:$imm16), opcodestr, "$rd, $imm16", []>
{
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;

    let rs1 = 0;
}

def LUI   : Upper<0b010000, "lui"  >;
def AUIPC : Upper<0b011011, "auipc">;


// CSR Read
class CSRRead<bits<6> opcode, string opcodestr>
    : L2CInstI<opcode, (outs GPR:$rd), (ins uimm16:$imm16), opcodestr, "$rd, $imm16", []>
{
    let hasSideEffects = 1;
    let mayLoad = 0;
    let mayStore = 0;

    let rs1 = 0;
}

def CSRR : CSRRead<0b011100, "csrr">;


// CSR Write
class CSRWrite<bits<6> opcode, string opcodestr>
    : L2CInstI<opcode, (outs), (ins uimm16:$imm16, GPR:$rs1), opcodestr, "$imm16, $rs1", []>
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
