

let Namespace = "L2C" in {

    let FallbackRegAltNameIndex = NoRegAltName in
    def ABIRegAltName : RegAltNameIndex;

    class L2CReg<bits<5> Enc, string n, list<string> alt> : Register<n> {
        let HWEncoding{4-0} = Enc;
        let AltNames = alt;
        let RegAltNameIndices = [ABIRegAltName];
    }

} // Namespace = "L2C"


def R0  : L2CReg<0,  "r0",  ["zero"]>,  DwarfRegNum<[0]> { let isConstant = true; }
def R1  : L2CReg<1,  "r1",  ["a0"]>,    DwarfRegNum<[1]>;
def R2  : L2CReg<2,  "r2",  ["a1"]>,    DwarfRegNum<[2]>;
def R3  : L2CReg<3,  "r3",  ["a2"]>,    DwarfRegNum<[3]>;
def R4  : L2CReg<4,  "r4",  ["a3"]>,    DwarfRegNum<[4]>;
def R5  : L2CReg<5,  "r5",  ["a4"]>,    DwarfRegNum<[5]>;
def R6  : L2CReg<6,  "r6",  ["a5"]>,    DwarfRegNum<[6]>;
def R7  : L2CReg<7,  "r7",  ["a6"]>,    DwarfRegNum<[7]>;
def R8  : L2CReg<8,  "r8",  ["a7"]>,    DwarfRegNum<[8]>;
def R9  : L2CReg<9,  "r9",  ["t0"]>,    DwarfRegNum<[9]>;
def R10 : L2CReg<10, "r10", ["t1"]>,    DwarfRegNum<[10]>;
def R11 : L2CReg<11, "r11", ["t2"]>,    DwarfRegNum<[11]>;
def R12 : L2CReg<12, "r12", ["t3"]>,    DwarfRegNum<[12]>;
def R13 : L2CReg<13, "r13", ["t4"]>,    DwarfRegNum<[13]>;
def R14 : L2CReg<14, "r14", ["t5"]>,    DwarfRegNum<[14]>;
def R15 : L2CReg<15, "r15", ["t6"]>,    DwarfRegNum<[15]>;
def R16 : L2CReg<16, "r16", ["t7"]>,    DwarfRegNum<[16]>;
def R17 : L2CReg<17, "r17", ["s0"]>,    DwarfRegNum<[17]>;
def R18 : L2CReg<18, "r18", ["s1"]>,    DwarfRegNum<[18]>;
def R19 : L2CReg<19, "r19", ["s2"]>,    DwarfRegNum<[19]>;
def R20 : L2CReg<20, "r20", ["s3"]>,    DwarfRegNum<[20]>;
def R21 : L2CReg<21, "r21", ["s4"]>,    DwarfRegNum<[21]>;
def R22 : L2CReg<22, "r22", ["s5"]>,    DwarfRegNum<[22]>;
def R23 : L2CReg<23, "r23", ["s6"]>,    DwarfRegNum<[23]>;
def R24 : L2CReg<24, "r24", ["s7"]>,    DwarfRegNum<[24]>;
def R25 : L2CReg<25, "r25", ["s8"]>,    DwarfRegNum<[25]>;
def R26 : L2CReg<26, "r26", ["s9"]>,    DwarfRegNum<[26]>;
def R27 : L2CReg<27, "r27", ["s10"]>,   DwarfRegNum<[27]>;
def R28 : L2CReg<28, "r28", ["s11"]>,   DwarfRegNum<[28]>;
def R29 : L2CReg<29, "r29", ["fp"]>,    DwarfRegNum<[29]>;
def R30 : L2CReg<30, "r30", ["sp"]>,    DwarfRegNum<[30]>;
def R31 : L2CReg<31, "r31", ["ra"]>,    DwarfRegNum<[31]>;



def GPR : RegisterClass<"L2C", [i32], 32, (add (sequence "R%u", 0, 31))> {
  let DiagnosticType = "InvalidRegClassGPR";
  let DiagnosticString = "register must be a GPR";
}
