(* Capstone Disassembler Engine
 * By Nguyen Anh Quynh <aquynh@gmail.com>, 2013> *)

let _CS_OP_ARCH = 5;;
let _CS_OP_CIMM = _CS_OP_ARCH         (* C-Immediate *)
let _CS_OP_PIMM = _CS_OP_ARCH + 1     (* P-Immediate *)

(* ARM operand shift type *)
let _ARM_SFT_INVALID = 0;;
let _ARM_SFT_ASR = 1;;
let _ARM_SFT_LSL = 2;;
let _ARM_SFT_LSR = 3;;
let _ARM_SFT_ROR = 4;;
let _ARM_SFT_RRX = 5;;
let _ARM_SFT_ASR_REG = 6;;
let _ARM_SFT_LSL_REG = 7;;
let _ARM_SFT_LSR_REG = 8;;
let _ARM_SFT_ROR_REG = 9;;
let _ARM_SFT_RRX_REG = 10;;

(* ARM code condition type *)
let _ARM_CC_INVALID = 0;;
let _ARM_CC_EQ = 1;;
let _ARM_CC_NE = 2;;
let _ARM_CC_HS = 3;;
let _ARM_CC_LO = 4;;
let _ARM_CC_MI = 5;;
let _ARM_CC_PL = 6;;
let _ARM_CC_VS = 7;;
let _ARM_CC_VC = 8;;
let _ARM_CC_HI = 9;;
let _ARM_CC_LS = 10;;
let _ARM_CC_GE = 11;;
let _ARM_CC_LT = 12;;
let _ARM_CC_GT = 13;;
let _ARM_CC_LE = 14;;
let _ARM_CC_AL = 15;;

(* architecture specific info of instruction *)
type arm_op_shift = {
	shift_type: int;	(* TODO: covert this to pattern like arm_op_value? *)
	shift_value: int;
}

type arm_op_mem = {
	base: int;
	index: int;
	scale: int;
	displ: int
}

type arm_op_value =
	| ARM_OP_INVALID of int
	| ARM_OP_REG of int
	| ARM_OP_CIMM of int
	| ARM_OP_PIMM of int
	| ARM_OP_IMM of int
	| ARM_OP_FP of float
	| ARM_OP_MEM of arm_op_mem

type arm_op = {
	shift: arm_op_shift;
	value: arm_op_value;
}

type cs_arm = {
	cc: int;
	update_flags: bool;
	writeback: bool;
	op_count: int;
	operands: arm_op array;
}

(*  Operand type for instruction's operands *)
let _ARM_OP_INVALID = 0;;
let _ARM_OP_REG = 1;;
let _ARM_OP_CIMM = 2;;
let _ARM_OP_PIMM = 3;;
let _ARM_OP_IMM = 4;;
let _ARM_OP_FP = 5;;
let _ARM_OP_MEM = 6;;

(* ARM registers *)
let _ARM_REG_INVALID = 0;;
let _ARM_REG_APSR = 1;;
let _ARM_REG_APSR_NZCV = 2;;
let _ARM_REG_CPSR = 3;;
let _ARM_REG_FPEXC = 4;;
let _ARM_REG_FPINST = 5;;
let _ARM_REG_FPSCR = 6;;
let _ARM_REG_FPSCR_NZCV = 7;;
let _ARM_REG_FPSID = 8;;
let _ARM_REG_ITSTATE = 9;;
let _ARM_REG_LR = 10;;
let _ARM_REG_PC = 11;;
let _ARM_REG_SP = 12;;
let _ARM_REG_SPSR = 13;;
let _ARM_REG_D0 = 14;;
let _ARM_REG_D1 = 15;;
let _ARM_REG_D2 = 16;;
let _ARM_REG_D3 = 17;;
let _ARM_REG_D4 = 18;;
let _ARM_REG_D5 = 19;;
let _ARM_REG_D6 = 20;;
let _ARM_REG_D7 = 21;;
let _ARM_REG_D8 = 22;;
let _ARM_REG_D9 = 23;;
let _ARM_REG_D10 = 24;;
let _ARM_REG_D11 = 25;;
let _ARM_REG_D12 = 26;;
let _ARM_REG_D13 = 27;;
let _ARM_REG_D14 = 28;;
let _ARM_REG_D15 = 29;;
let _ARM_REG_D16 = 30;;
let _ARM_REG_D17 = 31;;
let _ARM_REG_D18 = 32;;
let _ARM_REG_D19 = 33;;
let _ARM_REG_D20 = 34;;
let _ARM_REG_D21 = 35;;
let _ARM_REG_D22 = 36;;
let _ARM_REG_D23 = 37;;
let _ARM_REG_D24 = 38;;
let _ARM_REG_D25 = 39;;
let _ARM_REG_D26 = 40;;
let _ARM_REG_D27 = 41;;
let _ARM_REG_D28 = 42;;
let _ARM_REG_D29 = 43;;
let _ARM_REG_D30 = 44;;
let _ARM_REG_D31 = 45;;
let _ARM_REG_FPINST2 = 46;;
let _ARM_REG_MVFR0 = 47;;
let _ARM_REG_MVFR1 = 48;;
let _ARM_REG_MVFR2 = 49;;
let _ARM_REG_Q0 = 50;;
let _ARM_REG_Q1 = 51;;
let _ARM_REG_Q2 = 52;;
let _ARM_REG_Q3 = 53;;
let _ARM_REG_Q4 = 54;;
let _ARM_REG_Q5 = 55;;
let _ARM_REG_Q6 = 56;;
let _ARM_REG_Q7 = 57;;
let _ARM_REG_Q8 = 58;;
let _ARM_REG_Q9 = 59;;
let _ARM_REG_Q10 = 60;;
let _ARM_REG_Q11 = 61;;
let _ARM_REG_Q12 = 62;;
let _ARM_REG_Q13 = 63;;
let _ARM_REG_Q14 = 64;;
let _ARM_REG_Q15 = 65;;
let _ARM_REG_R0 = 66;;
let _ARM_REG_R1 = 67;;
let _ARM_REG_R2 = 68;;
let _ARM_REG_R3 = 69;;
let _ARM_REG_R4 = 70;;
let _ARM_REG_R5 = 71;;
let _ARM_REG_R6 = 72;;
let _ARM_REG_R7 = 73;;
let _ARM_REG_R8 = 74;;
let _ARM_REG_R9 = 75;;
let _ARM_REG_R10 = 76;;
let _ARM_REG_R11 = 77;;
let _ARM_REG_R12 = 78;;
let _ARM_REG_S0 = 79;;
let _ARM_REG_S1 = 80;;
let _ARM_REG_S2 = 81;;
let _ARM_REG_S3 = 82;;
let _ARM_REG_S4 = 83;;
let _ARM_REG_S5 = 84;;
let _ARM_REG_S6 = 85;;
let _ARM_REG_S7 = 86;;
let _ARM_REG_S8 = 87;;
let _ARM_REG_S9 = 88;;
let _ARM_REG_S10 = 89;;
let _ARM_REG_S11 = 90;;
let _ARM_REG_S12 = 91;;
let _ARM_REG_S13 = 92;;
let _ARM_REG_S14 = 93;;
let _ARM_REG_S15 = 94;;
let _ARM_REG_S16 = 95;;
let _ARM_REG_S17 = 96;;
let _ARM_REG_S18 = 97;;
let _ARM_REG_S19 = 98;;
let _ARM_REG_S20 = 99;;
let _ARM_REG_S21 = 100;;
let _ARM_REG_S22 = 101;;
let _ARM_REG_S23 = 102;;
let _ARM_REG_S24 = 103;;
let _ARM_REG_S25 = 104;;
let _ARM_REG_S26 = 105;;
let _ARM_REG_S27 = 106;;
let _ARM_REG_S28 = 107;;
let _ARM_REG_S29 = 108;;
let _ARM_REG_S30 = 109;;
let _ARM_REG_S31 = 110;;
let _ARM_REG_MAX = 111;;

(*  alias registers *)
let _ARM_REG_R13 = _ARM_REG_SP;;
let _ARM_REG_R14 = _ARM_REG_LR;;
let _ARM_REG_R15 = _ARM_REG_PC;;
let _ARM_REG_SB = _ARM_REG_R9;;
let _ARM_REG_SL = _ARM_REG_R10;;
let _ARM_REG_FP = _ARM_REG_R11;;
let _ARM_REG_IP = _ARM_REG_R12;;

(* ARM instructions *)
let _ARM_INS_INVALID = 0;;
let _ARM_INS_ADC = 1;;
let _ARM_INS_ADD = 2;;
let _ARM_INS_ADR = 3;;
let _ARM_INS_AESD = 4;;
let _ARM_INS_AESE = 5;;
let _ARM_INS_AESIMC = 6;;
let _ARM_INS_AESMC = 7;;
let _ARM_INS_AND = 8;;
let _ARM_INS_BFC = 9;;
let _ARM_INS_BFI = 10;;
let _ARM_INS_BIC = 11;;
let _ARM_INS_BKPT = 12;;
let _ARM_INS_BL = 13;;
let _ARM_INS_BLX = 14;;
let _ARM_INS_BX = 15;;
let _ARM_INS_BXJ = 16;;
let _ARM_INS_B = 17;;
let _ARM_INS_CDP = 18;;
let _ARM_INS_CDP2 = 19;;
let _ARM_INS_CLREX = 20;;
let _ARM_INS_CLZ = 21;;
let _ARM_INS_CMN = 22;;
let _ARM_INS_CMP = 23;;
let _ARM_INS_CPS = 24;;
let _ARM_INS_CRC32B = 25;;
let _ARM_INS_CRC32CB = 26;;
let _ARM_INS_CRC32CH = 27;;
let _ARM_INS_CRC32CW = 28;;
let _ARM_INS_CRC32H = 29;;
let _ARM_INS_CRC32W = 30;;
let _ARM_INS_DBG = 31;;
let _ARM_INS_DMB = 32;;
let _ARM_INS_DSB = 33;;
let _ARM_INS_EOR = 34;;
let _ARM_INS_VMOV = 35;;
let _ARM_INS_FLDMDBX = 36;;
let _ARM_INS_FLDMIAX = 37;;
let _ARM_INS_VMRS = 38;;
let _ARM_INS_FSTMDBX = 39;;
let _ARM_INS_FSTMIAX = 40;;
let _ARM_INS_HINT = 41;;
let _ARM_INS_HLT = 42;;
let _ARM_INS_ISB = 43;;
let _ARM_INS_LDA = 44;;
let _ARM_INS_LDAB = 45;;
let _ARM_INS_LDAEX = 46;;
let _ARM_INS_LDAEXB = 47;;
let _ARM_INS_LDAEXD = 48;;
let _ARM_INS_LDAEXH = 49;;
let _ARM_INS_LDAH = 50;;
let _ARM_INS_LDC2L = 51;;
let _ARM_INS_LDC2 = 52;;
let _ARM_INS_LDCL = 53;;
let _ARM_INS_LDC = 54;;
let _ARM_INS_LDMDA = 55;;
let _ARM_INS_LDMDB = 56;;
let _ARM_INS_LDM = 57;;
let _ARM_INS_LDMIB = 58;;
let _ARM_INS_LDRBT = 59;;
let _ARM_INS_LDRB = 60;;
let _ARM_INS_LDRD = 61;;
let _ARM_INS_LDREX = 62;;
let _ARM_INS_LDREXB = 63;;
let _ARM_INS_LDREXD = 64;;
let _ARM_INS_LDREXH = 65;;
let _ARM_INS_LDRH = 66;;
let _ARM_INS_LDRHT = 67;;
let _ARM_INS_LDRSB = 68;;
let _ARM_INS_LDRSBT = 69;;
let _ARM_INS_LDRSH = 70;;
let _ARM_INS_LDRSHT = 71;;
let _ARM_INS_LDRT = 72;;
let _ARM_INS_LDR = 73;;
let _ARM_INS_MCR = 74;;
let _ARM_INS_MCR2 = 75;;
let _ARM_INS_MCRR = 76;;
let _ARM_INS_MCRR2 = 77;;
let _ARM_INS_MLA = 78;;
let _ARM_INS_MLS = 79;;
let _ARM_INS_MOV = 80;;
let _ARM_INS_MOVT = 81;;
let _ARM_INS_MOVW = 82;;
let _ARM_INS_MRC = 83;;
let _ARM_INS_MRC2 = 84;;
let _ARM_INS_MRRC = 85;;
let _ARM_INS_MRRC2 = 86;;
let _ARM_INS_MRS = 87;;
let _ARM_INS_MSR = 88;;
let _ARM_INS_MUL = 89;;
let _ARM_INS_MVN = 90;;
let _ARM_INS_ORR = 91;;
let _ARM_INS_PKHBT = 92;;
let _ARM_INS_PKHTB = 93;;
let _ARM_INS_PLDW = 94;;
let _ARM_INS_PLD = 95;;
let _ARM_INS_PLI = 96;;
let _ARM_INS_QADD = 97;;
let _ARM_INS_QADD16 = 98;;
let _ARM_INS_QADD8 = 99;;
let _ARM_INS_QASX = 100;;
let _ARM_INS_QDADD = 101;;
let _ARM_INS_QDSUB = 102;;
let _ARM_INS_QSAX = 103;;
let _ARM_INS_QSUB = 104;;
let _ARM_INS_QSUB16 = 105;;
let _ARM_INS_QSUB8 = 106;;
let _ARM_INS_RBIT = 107;;
let _ARM_INS_REV = 108;;
let _ARM_INS_REV16 = 109;;
let _ARM_INS_REVSH = 110;;
let _ARM_INS_RFEDA = 111;;
let _ARM_INS_RFEDB = 112;;
let _ARM_INS_RFEIA = 113;;
let _ARM_INS_RFEIB = 114;;
let _ARM_INS_RSB = 115;;
let _ARM_INS_RSC = 116;;
let _ARM_INS_SADD16 = 117;;
let _ARM_INS_SADD8 = 118;;
let _ARM_INS_SASX = 119;;
let _ARM_INS_SBC = 120;;
let _ARM_INS_SBFX = 121;;
let _ARM_INS_SDIV = 122;;
let _ARM_INS_SEL = 123;;
let _ARM_INS_SETEND = 124;;
let _ARM_INS_SHA1C = 125;;
let _ARM_INS_SHA1H = 126;;
let _ARM_INS_SHA1M = 127;;
let _ARM_INS_SHA1P = 128;;
let _ARM_INS_SHA1SU0 = 129;;
let _ARM_INS_SHA1SU1 = 130;;
let _ARM_INS_SHA256H = 131;;
let _ARM_INS_SHA256H2 = 132;;
let _ARM_INS_SHA256SU0 = 133;;
let _ARM_INS_SHA256SU1 = 134;;
let _ARM_INS_SHADD16 = 135;;
let _ARM_INS_SHADD8 = 136;;
let _ARM_INS_SHASX = 137;;
let _ARM_INS_SHSAX = 138;;
let _ARM_INS_SHSUB16 = 139;;
let _ARM_INS_SHSUB8 = 140;;
let _ARM_INS_SMC = 141;;
let _ARM_INS_SMLABB = 142;;
let _ARM_INS_SMLABT = 143;;
let _ARM_INS_SMLAD = 144;;
let _ARM_INS_SMLADX = 145;;
let _ARM_INS_SMLAL = 146;;
let _ARM_INS_SMLALBB = 147;;
let _ARM_INS_SMLALBT = 148;;
let _ARM_INS_SMLALD = 149;;
let _ARM_INS_SMLALDX = 150;;
let _ARM_INS_SMLALTB = 151;;
let _ARM_INS_SMLALTT = 152;;
let _ARM_INS_SMLATB = 153;;
let _ARM_INS_SMLATT = 154;;
let _ARM_INS_SMLAWB = 155;;
let _ARM_INS_SMLAWT = 156;;
let _ARM_INS_SMLSD = 157;;
let _ARM_INS_SMLSDX = 158;;
let _ARM_INS_SMLSLD = 159;;
let _ARM_INS_SMLSLDX = 160;;
let _ARM_INS_SMMLA = 161;;
let _ARM_INS_SMMLAR = 162;;
let _ARM_INS_SMMLS = 163;;
let _ARM_INS_SMMLSR = 164;;
let _ARM_INS_SMMUL = 165;;
let _ARM_INS_SMMULR = 166;;
let _ARM_INS_SMUAD = 167;;
let _ARM_INS_SMUADX = 168;;
let _ARM_INS_SMULBB = 169;;
let _ARM_INS_SMULBT = 170;;
let _ARM_INS_SMULL = 171;;
let _ARM_INS_SMULTB = 172;;
let _ARM_INS_SMULTT = 173;;
let _ARM_INS_SMULWB = 174;;
let _ARM_INS_SMULWT = 175;;
let _ARM_INS_SMUSD = 176;;
let _ARM_INS_SMUSDX = 177;;
let _ARM_INS_SRSDA = 178;;
let _ARM_INS_SRSDB = 179;;
let _ARM_INS_SRSIA = 180;;
let _ARM_INS_SRSIB = 181;;
let _ARM_INS_SSAT = 182;;
let _ARM_INS_SSAT16 = 183;;
let _ARM_INS_SSAX = 184;;
let _ARM_INS_SSUB16 = 185;;
let _ARM_INS_SSUB8 = 186;;
let _ARM_INS_STC2L = 187;;
let _ARM_INS_STC2 = 188;;
let _ARM_INS_STCL = 189;;
let _ARM_INS_STC = 190;;
let _ARM_INS_STL = 191;;
let _ARM_INS_STLB = 192;;
let _ARM_INS_STLEX = 193;;
let _ARM_INS_STLEXB = 194;;
let _ARM_INS_STLEXD = 195;;
let _ARM_INS_STLEXH = 196;;
let _ARM_INS_STLH = 197;;
let _ARM_INS_STMDA = 198;;
let _ARM_INS_STMDB = 199;;
let _ARM_INS_STM = 200;;
let _ARM_INS_STMIB = 201;;
let _ARM_INS_STRBT = 202;;
let _ARM_INS_STRB = 203;;
let _ARM_INS_STRD = 204;;
let _ARM_INS_STREX = 205;;
let _ARM_INS_STREXB = 206;;
let _ARM_INS_STREXD = 207;;
let _ARM_INS_STREXH = 208;;
let _ARM_INS_STRH = 209;;
let _ARM_INS_STRHT = 210;;
let _ARM_INS_STRT = 211;;
let _ARM_INS_STR = 212;;
let _ARM_INS_SUB = 213;;
let _ARM_INS_SVC = 214;;
let _ARM_INS_SWP = 215;;
let _ARM_INS_SWPB = 216;;
let _ARM_INS_SXTAB = 217;;
let _ARM_INS_SXTAB16 = 218;;
let _ARM_INS_SXTAH = 219;;
let _ARM_INS_SXTB = 220;;
let _ARM_INS_SXTB16 = 221;;
let _ARM_INS_SXTH = 222;;
let _ARM_INS_TEQ = 223;;
let _ARM_INS_TRAP = 224;;
let _ARM_INS_TST = 225;;
let _ARM_INS_UADD16 = 226;;
let _ARM_INS_UADD8 = 227;;
let _ARM_INS_UASX = 228;;
let _ARM_INS_UBFX = 229;;
let _ARM_INS_UDIV = 230;;
let _ARM_INS_UHADD16 = 231;;
let _ARM_INS_UHADD8 = 232;;
let _ARM_INS_UHASX = 233;;
let _ARM_INS_UHSAX = 234;;
let _ARM_INS_UHSUB16 = 235;;
let _ARM_INS_UHSUB8 = 236;;
let _ARM_INS_UMAAL = 237;;
let _ARM_INS_UMLAL = 238;;
let _ARM_INS_UMULL = 239;;
let _ARM_INS_UQADD16 = 240;;
let _ARM_INS_UQADD8 = 241;;
let _ARM_INS_UQASX = 242;;
let _ARM_INS_UQSAX = 243;;
let _ARM_INS_UQSUB16 = 244;;
let _ARM_INS_UQSUB8 = 245;;
let _ARM_INS_USAD8 = 246;;
let _ARM_INS_USADA8 = 247;;
let _ARM_INS_USAT = 248;;
let _ARM_INS_USAT16 = 249;;
let _ARM_INS_USAX = 250;;
let _ARM_INS_USUB16 = 251;;
let _ARM_INS_USUB8 = 252;;
let _ARM_INS_UXTAB = 253;;
let _ARM_INS_UXTAB16 = 254;;
let _ARM_INS_UXTAH = 255;;
let _ARM_INS_UXTB = 256;;
let _ARM_INS_UXTB16 = 257;;
let _ARM_INS_UXTH = 258;;
let _ARM_INS_VABAL = 259;;
let _ARM_INS_VABA = 260;;
let _ARM_INS_VABDL = 261;;
let _ARM_INS_VABD = 262;;
let _ARM_INS_VABS = 263;;
let _ARM_INS_VACGE = 264;;
let _ARM_INS_VACGT = 265;;
let _ARM_INS_VADD = 266;;
let _ARM_INS_VADDHN = 267;;
let _ARM_INS_VADDL = 268;;
let _ARM_INS_VADDW = 269;;
let _ARM_INS_VAND = 270;;
let _ARM_INS_VBIC = 271;;
let _ARM_INS_VBIF = 272;;
let _ARM_INS_VBIT = 273;;
let _ARM_INS_VBSL = 274;;
let _ARM_INS_VCEQ = 275;;
let _ARM_INS_VCGE = 276;;
let _ARM_INS_VCGT = 277;;
let _ARM_INS_VCLE = 278;;
let _ARM_INS_VCLS = 279;;
let _ARM_INS_VCLT = 280;;
let _ARM_INS_VCLZ = 281;;
let _ARM_INS_VCMP = 282;;
let _ARM_INS_VCMPE = 283;;
let _ARM_INS_VCNT = 284;;
let _ARM_INS_VCVTA = 285;;
let _ARM_INS_VCVTB = 286;;
let _ARM_INS_VCVT = 287;;
let _ARM_INS_VCVTM = 288;;
let _ARM_INS_VCVTN = 289;;
let _ARM_INS_VCVTP = 290;;
let _ARM_INS_VCVTT = 291;;
let _ARM_INS_VDIV = 292;;
let _ARM_INS_VDUP = 293;;
let _ARM_INS_VEOR = 294;;
let _ARM_INS_VEXT = 295;;
let _ARM_INS_VFMA = 296;;
let _ARM_INS_VFMS = 297;;
let _ARM_INS_VFNMA = 298;;
let _ARM_INS_VFNMS = 299;;
let _ARM_INS_VHADD = 300;;
let _ARM_INS_VHSUB = 301;;
let _ARM_INS_VLD1 = 302;;
let _ARM_INS_VLD2 = 303;;
let _ARM_INS_VLD3 = 304;;
let _ARM_INS_VLD4 = 305;;
let _ARM_INS_VLDMDB = 306;;
let _ARM_INS_VLDMIA = 307;;
let _ARM_INS_VLDR = 308;;
let _ARM_INS_VMAXNM = 309;;
let _ARM_INS_VMAX = 310;;
let _ARM_INS_VMINNM = 311;;
let _ARM_INS_VMIN = 312;;
let _ARM_INS_VMLA = 313;;
let _ARM_INS_VMLAL = 314;;
let _ARM_INS_VMLS = 315;;
let _ARM_INS_VMLSL = 316;;
let _ARM_INS_VMOVL = 317;;
let _ARM_INS_VMOVN = 318;;
let _ARM_INS_VMSR = 319;;
let _ARM_INS_VMUL = 320;;
let _ARM_INS_VMULL = 321;;
let _ARM_INS_VMVN = 322;;
let _ARM_INS_VNEG = 323;;
let _ARM_INS_VNMLA = 324;;
let _ARM_INS_VNMLS = 325;;
let _ARM_INS_VNMUL = 326;;
let _ARM_INS_VORN = 327;;
let _ARM_INS_VORR = 328;;
let _ARM_INS_VPADAL = 329;;
let _ARM_INS_VPADDL = 330;;
let _ARM_INS_VPADD = 331;;
let _ARM_INS_VPMAX = 332;;
let _ARM_INS_VPMIN = 333;;
let _ARM_INS_VQABS = 334;;
let _ARM_INS_VQADD = 335;;
let _ARM_INS_VQDMLAL = 336;;
let _ARM_INS_VQDMLSL = 337;;
let _ARM_INS_VQDMULH = 338;;
let _ARM_INS_VQDMULL = 339;;
let _ARM_INS_VQMOVUN = 340;;
let _ARM_INS_VQMOVN = 341;;
let _ARM_INS_VQNEG = 342;;
let _ARM_INS_VQRDMULH = 343;;
let _ARM_INS_VQRSHL = 344;;
let _ARM_INS_VQRSHRN = 345;;
let _ARM_INS_VQRSHRUN = 346;;
let _ARM_INS_VQSHL = 347;;
let _ARM_INS_VQSHLU = 348;;
let _ARM_INS_VQSHRN = 349;;
let _ARM_INS_VQSHRUN = 350;;
let _ARM_INS_VQSUB = 351;;
let _ARM_INS_VRADDHN = 352;;
let _ARM_INS_VRECPE = 353;;
let _ARM_INS_VRECPS = 354;;
let _ARM_INS_VREV16 = 355;;
let _ARM_INS_VREV32 = 356;;
let _ARM_INS_VREV64 = 357;;
let _ARM_INS_VRHADD = 358;;
let _ARM_INS_VRINTA = 359;;
let _ARM_INS_VRINTM = 360;;
let _ARM_INS_VRINTN = 361;;
let _ARM_INS_VRINTP = 362;;
let _ARM_INS_VRINTR = 363;;
let _ARM_INS_VRINTX = 364;;
let _ARM_INS_VRINTZ = 365;;
let _ARM_INS_VRSHL = 366;;
let _ARM_INS_VRSHRN = 367;;
let _ARM_INS_VRSHR = 368;;
let _ARM_INS_VRSQRTE = 369;;
let _ARM_INS_VRSQRTS = 370;;
let _ARM_INS_VRSRA = 371;;
let _ARM_INS_VRSUBHN = 372;;
let _ARM_INS_VSELEQ = 373;;
let _ARM_INS_VSELGE = 374;;
let _ARM_INS_VSELGT = 375;;
let _ARM_INS_VSELVS = 376;;
let _ARM_INS_VSHLL = 377;;
let _ARM_INS_VSHL = 378;;
let _ARM_INS_VSHRN = 379;;
let _ARM_INS_VSHR = 380;;
let _ARM_INS_VSLI = 381;;
let _ARM_INS_VSQRT = 382;;
let _ARM_INS_VSRA = 383;;
let _ARM_INS_VSRI = 384;;
let _ARM_INS_VST1 = 385;;
let _ARM_INS_VST2 = 386;;
let _ARM_INS_VST3 = 387;;
let _ARM_INS_VST4 = 388;;
let _ARM_INS_VSTMDB = 389;;
let _ARM_INS_VSTMIA = 390;;
let _ARM_INS_VSTR = 391;;
let _ARM_INS_VSUB = 392;;
let _ARM_INS_VSUBHN = 393;;
let _ARM_INS_VSUBL = 394;;
let _ARM_INS_VSUBW = 395;;
let _ARM_INS_VSWP = 396;;
let _ARM_INS_VTBL = 397;;
let _ARM_INS_VTBX = 398;;
let _ARM_INS_VCVTR = 399;;
let _ARM_INS_VTRN = 400;;
let _ARM_INS_VTST = 401;;
let _ARM_INS_VUZP = 402;;
let _ARM_INS_VZIP = 403;;
let _ARM_INS_ADDW = 404;;
let _ARM_INS_ASR = 405;;
let _ARM_INS_DCPS1 = 406;;
let _ARM_INS_DCPS2 = 407;;
let _ARM_INS_DCPS3 = 408;;
let _ARM_INS_IT = 409;;
let _ARM_INS_LSL = 410;;
let _ARM_INS_LSR = 411;;
let _ARM_INS_ASRS = 412;;
let _ARM_INS_LSRS = 413;;
let _ARM_INS_ORN = 414;;
let _ARM_INS_ROR = 415;;
let _ARM_INS_RRX = 416;;
let _ARM_INS_SUBS = 417;;
let _ARM_INS_SUBW = 418;;
let _ARM_INS_TBB = 419;;
let _ARM_INS_TBH = 420;;
let _ARM_INS_CBNZ = 421;;
let _ARM_INS_CBZ = 422;;
let _ARM_INS_MOVS = 423;;
let _ARM_INS_POP = 424;;
let _ARM_INS_PUSH = 425;;
let _ARM_INS_MAX = 426;;

(* ARM group of instructions *)
let _ARM_GRP_INVALID = 0;;
let _ARM_GRP_CRYPTO = 1;;
let _ARM_GRP_DATABARRIER = 2;;
let _ARM_GRP_DIVIDE = 3;;
let _ARM_GRP_FPARMV8 = 4;;
let _ARM_GRP_MULTPRO = 5;;
let _ARM_GRP_NEON = 6;;
let _ARM_GRP_T2EXTRACTPACK = 7;;
let _ARM_GRP_THUMB2DSP = 8;;
let _ARM_GRP_TRUSTZONE = 9;;
let _ARM_GRP_V4T = 10;;
let _ARM_GRP_V5T = 11;;
let _ARM_GRP_V5TE = 12;;
let _ARM_GRP_V6 = 13;;
let _ARM_GRP_V6T2 = 14;;
let _ARM_GRP_V7 = 15;;
let _ARM_GRP_V8 = 16;;
let _ARM_GRP_VFP2 = 17;;
let _ARM_GRP_VFP3 = 18;;
let _ARM_GRP_VFP4 = 19;;
let _ARM_GRP_ARM = 20;;
let _ARM_GRP_MCLASS = 21;;
let _ARM_GRP_NOTMCLASS = 22;;
let _ARM_GRP_THUMB = 23;;
let _ARM_GRP_THUMB1ONLY = 24;;
let _ARM_GRP_THUMB2 = 25;;
let _ARM_GRP_PREV8 = 26;;
let _ARM_GRP_FPVMLX = 27;;
let _ARM_GRP_MULOPS = 28;;
let _ARM_GRP_CRC = 29;;
let _ARM_GRP_DPVFP = 30;;
let _ARM_GRP_V6M = 31;;
let _ARM_GRP_JUMP = 32;;
let _ARM_GRP_MAX = 33;;
