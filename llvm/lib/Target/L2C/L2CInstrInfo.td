
include "L2CInstrFormats.td"


class ALU_rr<bits<6> opcode, string opcodestr, bit Commutable = 0>
    : L2CInstR<opcode, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2", []>
{
    let hasSideEffects = 0;
    let mayLoad = 0;
    let mayStore = 0;
    let isCommutable = Commutable;
}


def ADD : ALU_rr<0b000001, "add", Commutable=1>;
