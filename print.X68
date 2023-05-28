*-----------------------------------------------------------
* Description: Outputs op-code result
*-----------------------------------------------------------

    ORG    $1000
START:   
; Need to use D0 and D2, so move variables
    MOVE.B  D0, D6 * Store op code key
    MOVE.B  D1, D7 * Store bool, does opcode have atleast 1 EA?

CR          EQU     $0D
LF          EQU     $0A

; Assumes memory location stored in D5
PRINT_MEM_LOC
    MOVE.L  D5,D1
    MOVE.B  #14,D0
    TRAP    #15 

CMPRTO_PRINT
    CMP.B   #1, D6 
    BEQ     load_mssg_MOVEB
    CMP.B   #2, D6 
    BEQ     load_mssg_MOVEL
    CMP.B   #4, D6 
    BEQ     load_mssg_MOVEW
    
    CMP.B   #3, D6 
    BEQ     load_mssg_MOVEAL
    CMP.B   #5, D6 
    BEQ     load_mssg_MOVEAW
    
    CMP.B   #6, D6 
    BEQ     load_mssg_RTS
    CMP.B   #7, D6 
    BEQ     load_mssg_LEA
    
    CMP.B   #8, D6 
    BEQ     load_mssg_NOTL
    CMP.B   #9, D6 
    BEQ     load_mssg_NOP
    CMP.B   #10, D6 
    BEQ     load_mssg_NOTW
    CMP.B   #11, D6 
    BEQ     load_mssg_NOTB
    
    CMP.B   #12, D6 
    BEQ     load_mssg_JSR
    
    CMP.B   #13, D6 
    BEQ     load_mssg_MOVEML
    CMP.B   #14, D6 
    BEQ     load_mssg_MOVEMW
    
    CMP.B   #15, D6 
    BEQ     load_mssg_ADDQW
    CMP.B   #16, D6 
    BEQ     load_mssg_ADDQL
    CMP.B   #17, D6 
    BEQ     load_mssg_ADDQB
    CMP.B   #18, D6 
    
    BEQ     load_mssg_MOVEQ
    CMP.B   #19, D6 
    
    BEQ     load_mssg_ORB
    CMP.B   #20, D6 
    BEQ     load_mssg_ORW
    CMP.B   #21, D6 
    BEQ     load_mssg_ORL
    
    CMP.B   #22, D6 
    BEQ     load_mssg_SUBB
    CMP.B   #23, D6 
    BEQ     load_mssg_SUBW
    CMP.B   #24, D6 
    BEQ     load_mssg_SUBL
    
    CMP.B   #25, D6 
    BEQ     load_mssg_ANDB
    CMP.B   #26, D6 
    BEQ     load_mssg_ANDW
    CMP.B   #27, D6 
    BEQ     load_mssg_ANDL
    
    CMP.B   #28, D6 
    BEQ     load_mssg_ADDAL
    CMP.B   #29, D6 
    BEQ     load_mssg_ADDAW
    
    CMP.B   #30, D6 
    BEQ     load_mssg_ADDB
    CMP.B   #31, D6 
    BEQ     load_mssg_ADDW
    CMP.B   #32, D6 
    BEQ     load_mssg_ADDB
    
    CMP.B   #33, D6 
    BEQ     load_mssg_BGT
    CMP.B   #34, D6 
    BEQ     load_mssg_BLE
    CMP.B   #35, D6 
    BEQ     load_mssg_BRA
    CMP.B   #36, D6 
    BEQ     load_mssg_BEQ
    CMP.B   #37, D6 
    BEQ     load_mssg_BCC
    
    ; Memory shifts
    CMP.B   #38, D6 
    BEQ     load_mssg_ROL
    CMP.B   #39, D6 
    BEQ     load_mssg_ROR
    CMP.B   #40, D6 
    BEQ     load_mssg_LSL
    CMP.B   #41, D6 
    BEQ     load_mssg_LSR
    CMP.B   #42, D6 
    BEQ     load_mssg_ASR
    CMP.B   #43, D6 
    BEQ     load_mssg_ASL
    
    CMP.B   #44, D6 
    BEQ     load_mssg_RORL
    CMP.B   #45, D6 
    BEQ     load_mssg_RORW
    CMP.B   #46, D6 
    BEQ     load_mssg_RORB
    
    CMP.B   #47, D6 
    BEQ     load_mssg_ROLL
    CMP.B   #48, D6 
    BEQ     load_mssg_ROLW
    CMP.B   #49, D6 
    BEQ     load_mssg_ROLB
    
    CMP.B   #50, D6 
    BEQ     load_mssg_LSLL
    CMP.B   #51, D6 
    BEQ     load_mssg_LSLW
    CMP.B   #52, D6 
    BEQ     load_mssg_LSLB
    
    CMP.B   #53, D6 
    BEQ     load_mssg_LSRL
    CMP.B   #54, D6 
    BEQ     load_mssg_LSRW
    CMP.B   #55, D6 
    BEQ     load_mssg_LSRB
    
    CMP.B   #56, D6 
    BEQ     load_mssg_ASRL
    CMP.B   #57, D6 
    BEQ     load_mssg_ASRW
    CMP.B   #58, D6 
    BEQ     load_mssg_ASRB
    
    CMP.B   #59, D6 
    BEQ     load_mssg_ASLL
    CMP.B   #60, D6 
    BEQ     load_mssg_ASLW
    CMP.B   #61, D6 
    BEQ     load_mssg_ASLB

*-----[Load Mssg Start]-----        
load_mssg_MOVEB
mssg1 DC.B    'MOVE.B',CR,LF,0
     LEA     mssg1, A1
     JMP     PRINT_OPCODE
    
load_mssg_MOVEL
mssg2 DC.B    'MOVE.L',CR,LF,0
     LEA     mssg1, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEW
mssg3 DC.B    'MOVE.W',CR,LF,0
     LEA     mssg3, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEAL
mssg4 DC.B    'MOVEA.L',CR,LF,0
     LEA     mssg4, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEAW
mssg5 DC.B    'MOVEA.w',CR,LF,0
     LEA     mssg5, A1
     JMP     PRINT_OPCODE
     
load_mssg_RTS
mssg6 DC.B    'RTS',CR,LF,0
     LEA     mssg6, A1
     JMP     PRINT_OPCODE
     
load_mssg_LEA
mssg7 DC.B    'LEA',CR,LF,0
     LEA     mssg6, A1
     JMP     PRINT_OPCODE
     
load_mssg_NOTL
mssg8 DC.B    'NOT.L',CR,LF,0
     LEA     mssg8, A1
     JMP     PRINT_OPCODE
     
load_mssg_NOP
mssg9 DC.B    'NOP',CR,LF,0
     LEA     mssg9, A1
     JMP     PRINT_OPCODE
     
load_mssg_NOTW
mssg10 DC.B    'NOT.W',CR,LF,0
     LEA     mssg10, A1
     JMP     PRINT_OPCODE
     
load_mssg_NOTB
mssg11 DC.B    'NOT.B',CR,LF,0
     LEA     mssg11, A1
     JMP     PRINT_OPCODE
     
load_mssg_JSR
mssg12 DC.B    'JSR',CR,LF,0
     LEA     mssg12, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEML
mssg13 DC.B    'MOVEM.L',CR,LF,0
     LEA     mssg13, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEMW
mssg14 DC.B    'MOVEM.W',CR,LF,0
     LEA     mssg14, A1
     JMP     PRINT_OPCODE
     
load_mssg_ADDQW
mssg15 DC.B    'ADDQ.W',CR,LF,0
     LEA     mssg15, A1
     JMP     PRINT_OPCODE
     
load_mssg_ADDQL
mssg16 DC.B    'ADDQ.L',CR,LF,0
     LEA     mssg16, A1
     JMP     PRINT_OPCODE
     
load_mssg_ADDQB
mssg17 DC.B    'ADDQ.B',CR,LF,0
     LEA     mssg17, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEQ
mssg18 DC.B    'MOVE.Q',CR,LF,0
     LEA     mssg18, A1
     JMP     PRINT_OPCODE
     
load_mssg_ORB
mssg19 DC.B    'OR.B',CR,LF,0
     LEA     mssg19, A1
     JMP     PRINT_OPCODE
     
load_mssg_ORW
mssg20 DC.B    'OR.W',CR,LF,0
     LEA     mssg20, A1
     JMP     PRINT_OPCODE
     
load_mssg_ORL
mssg21 DC.B    'OR.L',CR,LF,0
     LEA     mssg21, A1
     JMP     PRINT_OPCODE
     
load_mssg_SUBB
mssg22 DC.B    'SUB.B',CR,LF,0
     LEA     mssg22, A1
     JMP     PRINT_OPCODE
     
load_mssg_SUBW
mssg23 DC.B    'SUB.W',CR,LF,0
     LEA     mssg23, A1
     JMP     PRINT_OPCODE
     
load_mssg_SUBL
mssg24 DC.B    'SUB.L',CR,LF,0
     LEA     mssg24, A1
     JMP     PRINT_OPCODE
     
load_mssg_ANDB
mssg25 DC.B    'AND.B',CR,LF,0
     LEA     mssg25, A1
     JMP     PRINT_OPCODE
     
load_mssg_ANDW
mssg26 DC.B    'AND.W',CR,LF,0
     LEA     mssg26, A1
     JMP     PRINT_OPCODE
     
load_mssg_ANDL
mssg27 DC.B    'AND.L',CR,LF,0
     LEA     mssg27, A1
     JMP     PRINT_OPCODE
     
load_mssg_ADDAL
mssg28 DC.B    'ADDA.L',CR,LF,0
     LEA     mssg28, A1
     JMP     PRINT_OPCODE
     
load_mssg_ADDAW
mssg29 DC.B    'ADDA.W',CR,LF,0
     LEA     mssg29, A1
     JMP     PRINT_OPCODE
     
load_mssg_ADDB
mssg30 DC.B    'ADD.B',CR,LF,0
     LEA     mssg30, A1
     JMP     PRINT_OPCODE
     
load_mssg_ADDW
mssg31 DC.B    'ADD.W',CR,LF,0
     LEA     mssg31, A1
     JMP     PRINT_OPCODE
     
load_mssg_BGT
mssg32 DC.B    'BGT',CR,LF,0
     LEA     mssg32, A1
     JMP     PRINT_OPCODE
     
load_mssg_BLE
mssg33 DC.B    'BLE',CR,LF,0
     LEA     mssg33, A1
     JMP     PRINT_OPCODE
     
load_mssg_BRA
mssg34 DC.B    'BRA',CR,LF,0
     LEA     mssg34, A1
     JMP     PRINT_OPCODE
     JMP     PRINT_OPCODE
     
load_mssg_BEQ
mssg35  DC.B    'BEQ',CR,LF,0
        LEA     mssg35, A1
        JMP     PRINT_OPCODE
     
load_mssg_BCC
mssg36  DC.B    'BCC',CR,LF,0
        LEA     mssg36, A1
        JMP     PRINT_OPCODE
     
load_mssg_ROL
mssg37  DC.B    'ROL',CR,LF,0
        LEA     mssg37, A1
        JMP     PRINT_OPCODE
     
load_mssg_ROR
mssg38  DC.B    'ROR',CR,LF,0
        LEA     mssg38, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSL
mssg39  DC.B    'LSL',CR,LF,0
        LEA     mssg39, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSR
mssg40  DC.B    'LSR',CR,LF,0
        LEA     mssg40, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASR
mssg41  DC.B    'ASR',CR,LF,0
        LEA     mssg41, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASL
mssg42  DC.B    'ASL',CR,LF,0
        LEA     mssg42, A1
        JMP     PRINT_OPCODE
     
load_mssg_RORL
mssg43  DC.B    'ROR.L',CR,LF,0
        LEA     mssg43, A1
        JMP     PRINT_OPCODE
     
load_mssg_RORW
mssg44  DC.B    'ROR.W',CR,LF,0
        LEA     mssg44, A1
        JMP     PRINT_OPCODE
     
load_mssg_RORB
mssg45  DC.B    'ROR.B',CR,LF,0
        LEA     mssg45, A1
        JMP     PRINT_OPCODE
     
load_mssg_ROLL
mssg46  DC.B    'ROL.L',CR,LF,0
        LEA     mssg46, A1
        JMP     PRINT_OPCODE
     
load_mssg_ROLW
mssg47  DC.B    'ROL.W',CR,LF,0
        LEA     mssg47, A1
        JMP     PRINT_OPCODE
     
load_mssg_ROLB
mssg48  DC.B    'ROL.B',CR,LF,0
        LEA     mssg48, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSLL
mssg49  DC.B    'LSL.L',CR,LF,0
        LEA     mssg49, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSLW
mssg50  DC.B    'LSL.W',CR,LF,0
        LEA     mssg50, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSLB
mssg51  DC.B    'LSL.B',CR,LF,0
        LEA     mssg51, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSRL
mssg52  DC.B    'LSR.L',CR,LF,0
        LEA     mssg52, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSRW
mssg53  DC.B    'LSR.W',CR,LF,0
        LEA     mssg53, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSRB
mssg54  DC.B    'LSR.B',CR,LF,0
        LEA     mssg54, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASRL
mssg55  DC.B    'ASR.L',CR,LF,0
        LEA     mssg55, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASRW
mssg56  DC.B    'ASR.W',CR,LF,0
        LEA     mssg56, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASRB
mssg57  DC.B    'ASR.B',CR,LF,0
        LEA     mssg57, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASLL
mssg58  DC.B    'ASL.L',CR,LF,0
        LEA     mssg58, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASLW
mssg59  DC.B    'ASL.W',CR,LF,0
        LEA     mssg59, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASLB
mssg60  DC.B    'ASL.B',CR,LF,0
        LEA     mssg60, A1
        JMP     PRINT_OPCODE

*-----[Load Mssg End]-----     

PRINT_OPCODE 
    MOVE.B  #14,D0      
    TRAP    #15         * Displays Message
; to-do: Print addressing mode
    
PRINT_OPERAND
; to-do


    SIMHALT             ; halt simulator
    


* Put variables and constants here

    END    START        ; last line of source
