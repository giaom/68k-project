*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    MOVE.B    D0,D1
    MOVE.L    D0,D1
    MOVEA.L    D0,A0
    MOVE.W    D0,D1
    MOVEA.W    D0,A0
    MOVEM.L   D1-D7,-(A1)
    MOVEM.W   A1-A7,-(A1)
    NOP      
    RTS
    LEA     (A0),A0
    NOT.B     D1
    NOT.W     D1
    NOT.L     D1
    JSR       (A0)
    JSR       $1234
    JSR       $12345678
    JSR       label1
    JSR       label2
    JSR       label3
    ADDQ      #1,D1
    MOVEQ   #1,D1 
    OR.B     D1,(A1)
    OR.B    (A1),D1
    OR.W     D1,(A1)
    OR.W    (A1),D1
    OR.L     D1,(A1)
    OR.L    (A1),D1
    SUB.B     D1,(A1)
    SUB.B     (A1),D1
    SUB.W     D1,(A1)
    SUB.W     (A1),D1
    SUB.L     D1,(A1)
    SUB.L     (A1),D1   
    AND.B     D1,(A1)
    AND.B     (A1),D1
    AND.W     D1,(A1)
    AND.W     (A1),D1
    AND.L     D1,(A1)
    AND.L     (A1),D1
    ADD.B     D1,(A1)
    ADD.B     (A1),D1
    ADD.W     D1,(A1)
    ADD.W     (A1),D1
    ADD.L     D1,(A1)
    ADD.L     (A1),D1
    ADDA.W        D1,A2
    ADDA.L        -(A1),A2
    LSL.B     D1,D2
    LSL.W     D1,D2
    LSL.L     D1,D2
    LSL       $1234
    LSR.B     D1,D2
    LSR.W     D1,D2
    LSR.L     D1,D2
    LSR       $1234
    ASR.B     D1,D2
    ASR.W     D1,D2
    ASR.L     D1,D2
    ASR       $1234
    ASL.B     D1,D2
    ASL.W     D1,D2
    ASL.L     D1,D2
    ASL       $1234
    ROR.B     D1,D2
    ROR.W     D1,D2
    ROR.L     D1,D2
    ROR       $1234
    ROL.B     D1,D2
    ROL.W     D1,D2
    ROL.L     D1,D2
    ROL       $1234
    BGT.B     label1
    BGT.B     label1
    BGT.B     label2
    BLE.B     label1
    BLE.B     label2
    BGE.B     label1
    BEQ.B     label2
    BEQ.W     label1
    BRA     label1
label1
    NOP
    RTS
    LEA       $12,A0
    LEA       $1234,A0
    LEA       $12345678,A0
label2
    MOVEQ     #$0,D0
    MOVEQ     #$12,D0
    MOVEQ     #$FF,D0
label3
    MOVEM.W   A1-A7,$12
    MOVEM.L   D1-D7,$12
    MOVEM.W   A1/D7,$12
    MOVEM.L   A1/D7,$12
    MOVEM.W   A1-A7,$1234
    MOVEM.L   D1-D7,$1234
    MOVEM.W   A1/D7,$1234
    MOVEM.L   A1/D7,$1234
    MOVEM.W   A1-A7,$12345678
    MOVEM.L   D1-D7,$12345678
    MOVEM.W   A1/D7,$12345678
    MOVEM.L   A1/D7,$12345678
    MOVEM.W   $12,A1-A7
    MOVEM.L   $12,D1-D7
    MOVEM.W   $12,A1/D7
    MOVEM.L   $12,A1/D7
    MOVEM.W   $1234,A1-A7
    MOVEM.L   $1234,D1-D7
    MOVEM.W   $1234,A1/D7
    MOVEM.L   $1234,A1/D7
    MOVEM.W   $12345678,A1-A7
    MOVEM.L   $12345678,D1-D7
    MOVEM.W   $12345678,A1/D7
    MOVEM.L   $12345678,A1/D7
    ADDA.W    $12,A2
    ADDA.W    $1234,A2
    ADDA.W    $12345678,A2
    ADDA.W    #$1234,A2
    ADDA.L    $12,A2
    ADDA.L    $1234,A2
    ADDA.L    $12345678,A2
    ADDA.L    #$12345678,A2
    MULS.W    $12,D1
    MULS.W    $1234,D1
    MULS.W    $12345678,D1
    MULS.W    #$1234,D1
    DIVU.W    $12,D1
    DIVU.W    $1234,D1
    DIVU.W    $12345678,D1
    DIVU.W    #$1234,D1
    AND.B     D1,$12
    AND.B     D1,$1234
    AND.B     D1,$12345678
    AND.B     $12,D1
    AND.B     $1234,D1
    AND.B     $12345678,D1
    AND.B     #$12,D1
    AND.W     D1,$12
    AND.W     D1,$1234
    AND.W     D1,$12345678
    AND.W     $12,D1
    AND.W     $1234,D1
    AND.W     $12345678,D1
    AND.W     #$1234,D1
    AND.L     D1,$12
    AND.L     D1,$1234
    AND.L     D1,$12345678
    AND.L     $12,D1
    AND.L     $1234,D1
    AND.L     $12345678,D1
    AND.L     #$12345678,D1
    LSL.B     #$1,D2
    LSL.W     #$2,D2
    LSL.L     #$3,D2
    LSL.W     $12
    LSL.W     $1234
    LSL.W     $12345678
    ASR.B     #$1,D2
    ASR.W     #$2,D2
    ASR.L     #$3,D2
    ASR.W     $12
    ASR.W     $1234
    ASR.W     $12345678
label4
    BGT.B     label4
    BGT.B     label4
    BGT.B     label4
    BLE.W     label1
    BLE.W     label2
    BLE.W     label3
    BEQ.W     label1
    BEQ.W     label2
    BEQ.W     label3
    JSR       label1
    JSR       label2
    JSR       label3
    BRA       label1
  
* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
