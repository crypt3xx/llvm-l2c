// L2CInstrFormats.td

class L2CInst<bits<6> opcode, dag outs, dag ins, string opcodestr, string argstr, list<dag> pattern>
        : Instruction
{
    let Namespace = "L2C";

    field bits<32> Inst;
    let Size = 4;

    let Inst{5-0} = opcode;

    dag OutOperandList = outs;
    dag InOperandList = ins;
    let AsmString = opcodestr # !if(!empty(argstr), "", "\t" # argstr);
    let Pattern = pattern;
}

class PseudoInst<dag outs, dag ins, string opcodestr = "", string argstr = "", list<dag> pattern = []>
        : Instruction
{
    let Namespace = "L2C";
    
    dag OutOperandList = outs;
    dag InOperandList = ins;
    let AsmString = opcodestr # !if(!empty(argstr), "", "\t" # argstr);
    let Pattern = pattern;

    let isPseudo = 1;
    let isCodeGenOnly = 0;
    let isAsmParserOnly = 1;

    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;
}

class L2CInstR<bits<6> opcode, dag outs, dag ins, string opcodestr, string argstr, list<dag> pattern>
        : L2CInst<opcode, outs, ins, opcodestr, argstr, pattern>
{
    bits<5> rs2;
    bits<5> rs1;
    bits<5> rd;

    let Inst{31-21} = 0;
    let Inst{20-16} = rs2;
    let Inst{15-11} = rs1;
    let Inst{10-6} = rd;
}

class L2CInstI<bits<6> opcode, dag outs, dag ins, string opcodestr, string argstr, list<dag> pattern>
    : L2CInst<opcode, outs, ins, opcodestr, argstr, pattern>
{
    bits<16> imm16;
    bits<5> rs1;
    bits<5> rd;

    let Inst{31-16} = imm16;
    let Inst{15-11} = rs1;
    let Inst{10-6} = rd;
}

class L2CInstB<bits<6> opcode, dag outs, dag ins, string opcodestr, string argstr, list<dag> pattern>
    : L2CInst<opcode, outs, ins, opcodestr, argstr, pattern>
{
    bits<16> imm16;
    bits<5> rs2;
    bits<5> rs1;

    let Inst{31-21} = imm16{15-5};
    let Inst{20-16} = rs2;
    let Inst{15-11} = rs1;
    let Inst{10-6} = imm16{4-0};
}

class L2CInstJ<bits<6> opcode, dag outs, dag ins, string opcodestr, string argstr, list<dag> pattern>
    : L2CInst<opcode, outs, ins, opcodestr, argstr, pattern>
{
    bits<26> imm26;

    let Inst{31-6} = imm26;
}
