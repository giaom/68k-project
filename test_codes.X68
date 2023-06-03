*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $5000
START:                  ; first instruction of program

* Put program code here
    ;MOVEQ  
    MOVEQ      #123,D1
    MOVEQ      #0,D5
    MOVEQ      #-21,D6
    ;MOVE
    MOVE.B     D1,D2
    MOVE.B     D1,(A1)
    MOVE.B     D1,-(A1)
    MOVE.B     D1,(A1)+
    MOVE.B     D1,$1234
    MOVE.B     D1,$12345678
    MOVE.B     $1234,$1234              
    MOVE.B     $12345678,$12345678      
    MOVE.B     #20,D1  ;B
    MOVE.B     #-21,D1
    MOVE.B     #0,D2
    MOVE.W     #-16,(A1)
    MOVE.W     #0,(A1)+
    MOVE.W     #1234,D2 ;W              
    MOVE.L     #-21,-(A1)
    MOVE.L     #0,$1234
    MOVE.L     #12345678,D1    ;L
    MOVE.W     A1,D1
    MOVE.B     (A1),D2
    MOVE.B     -(A1),D2
    MOVE.B     (A1)+,D2
    MOVE.B      $1234,D1
    MOVE.B      $12345678,D2
    MOVE.B      $1234,$12345678
    MOVE.B      $1234678,$1234
    MOVE.B      #12,$1234
    MOVE.W      #30,$1235678
    MOVE.L      #500,$1234
    ;MOVEA
    MOVEA.L      D1,A1
    MOVEA.L      A2,A1
    MOVEA.L      (A2),A1
    MOVEA.L       (A2)+,A1
    MOVEA.L         -(A2),A1
    MOVEA.L      $1234,A1
    MOVEA.L      $1234678,A1
    MOVEA.L      #616,A1
    MOVEA.L      #-61,A1
    MOVEA.W      D1,A1
    MOVEA.W      A2,A1
    MOVEA.W      (A2),A1
    MOVEA.W     (A2)+,A1
    MOVEA.W        -(A2),A1
    MOVEA.W     $1234,A1
    MOVEA.W     $1234678,A1
    MOVEA.W     #616,A1
    MOVEA.W     #-61,A1
    ;LEA
    LEA         (A1),A2
    LEA         (A2),A4
    LEA         $1234,A2
    LEA         $1234578,A5
    ;NOT
    NOT.B       D1
    NOT.B       (A1)
    NOT.B       (A3)+
    NOT.B       -(A4)
    NOT.B       $1234
    NOT.B       $12345678
    NOT.W       D1
    NOT.W       (A1)
    NOT.W       (A3)+
    NOT.W       -(A4)
    NOT.W       $1234
    NOT.W       $12345678
    NOT.L       D1
    NOT.L       (A1)
    NOT.L       (A3)+
    NOT.L       -(A4)
    NOT.L       $1234
    NOT.L       $12345678
    ;JSR
    JSR         $1234
    JSR         (A5)
    JSR         $12345678
    ;ADDQ
    ADDQ.B      #1,D1
    ADDQ.B      #2,(A2)
    ADDQ.B      #3,(A3)+
    ADDQ.B      #4,-(A4)
    ADDQ.B      #5,$1234
    ADDQ.B      #6,$1234678
    ADDQ.W      #1,D1
    ADDQ.W      #2,A2
    ADDQ.W      #2,(A2)
    ADDQ.W      #3,(A3)+
    ADDQ.W      #4,-(A4)
    ADDQ.W      #5,$1234
    ADDQ.W      #6,$1234678
    ADDQ.L      #1,D1
    ADDQ.L      #2,A2
    ADDQ.L      #2,(A2)
    ADDQ.L    #3,(A3)+
    ADDQ.L     #4,-(A4)
    ADDQ.L     #5,$1234
    ADDQ.L    #6,$1234678
    ;OR
    OR.B      D2,D1
    OR.B      (A1),D2
    OR.B      (A3)+,D4
    OR.B       -(A4),D5
    OR.B       $1234,D5
    OR.B       $12345678,D1
    OR.B        #12,D1
    OR.B        #0,D1
    OR.B        #-2,D1
    OR.B        D1,(A2)
    OR.B        D1,(A3)+
    OR.B        D2,-(A2)
    OR.B        D2,$1234
    OR.B        D3,$12345678
    OR.W      D2,D1
    OR.W      (A1),D2
    OR.W      (A3)+,D4
    OR.W       -(A4),D5
    OR.W       $1234,D5
    OR.W       $12345678,D1
    OR.W        #12,D1
    OR.W        #0,D1
    OR.W        #-2,D1
    OR.W        D1,(A2)
    OR.W        D1,(A3)+
    OR.W        D2,-(A2)
    OR.W        D2,$1234
    OR.W        D3,$12345678
    OR.L      D2,D1
    OR.L      (A1),D2
    OR.L      (A3)+,D4
    OR.L       -(A4),D5
    OR.L       $1234,D5
    OR.L       $12345678,D1
    OR.L        #12,D1
    OR.L        #0,D1
    OR.L        #-2,D1
    OR.L        D1,(A2)
    OR.L        D1,(A3)+
    OR.L        D2,-(A2)
    OR.L        D2,$1234
    OR.L        D3,$12345678
    ;AND
    AND.B      D2,D1
    AND.B      (A1),D2
    AND.B      (A3)+,D4
    AND.B       -(A4),D5
    AND.B       $1234,D5
    AND.B       $12345678,D1
    AND.B        #12,D1
    AND.B        #0,D1
    AND.B        #-2,D1
    AND.B        D1,(A2)
    AND.B        D1,(A3)+
    AND.B        D2,-(A2)
    AND.B        D2,$1234
    AND.B        D3,$12345678
    AND.W      D2,D1
    AND.W      (A1),D2
    AND.W      (A3)+,D4
    AND.W       -(A4),D5
    AND.W       $1234,D5
    AND.W       $12345678,D1
    AND.W        #12,D1
    AND.W        #0,D1
    AND.W        #-2,D1
    AND.W        D1,(A2)
    AND.W        D1,(A3)+
    AND.W        D2,-(A2)
    AND.W        D2,$1234
    AND.W        D3,$12345678
    AND.L      D2,D1
    AND.L      (A1),D2
    AND.L      (A3)+,D4
    AND.L       -(A4),D5
    AND.L       $1234,D5
    AND.L       $12345678,D1
    AND.L        #12,D1
    AND.L        #0,D1
    AND.L        #-2,D1
    AND.L    D1,(A2)
    AND.L     D1,(A3)+
    AND.L     D2,-(A2)
    AND.L     D2,$1234
    AND.L  D3,$12345678
    ;SUB
    SUB.B     D1,D2
    SUB.B     (A1),D3
    SUB.B     (A4)+,D4
    SUB.B      -(A3),D2
    SUB.B      $1234,D1
    SUB.B      $12345678,D2
    SUB.B      #12,D2
    SUB.B      #0,D1
    SUB.B      #-5,D2
    SUB.W     D1,D2
    SUB.W     A1,D2
    SUB.W     (A1),D3
    SUB.W     (A4)+,D4
    SUB.W      -(A3),D2
    SUB.W      $1234,D1
    SUB.W      $12345678,D2
    SUB.W      #12,D2
    SUB.W      #0,D1
    SUB.W      #-5,D2
    SUB.L     D1,D2
    SUB.L     A1,D2
    SUB.L     (A1),D3
    SUB.L     (A4)+,D4
    SUB.L      -(A3),D2
    SUB.L      $1234,D1
    SUB.L      $12345678,D2
    SUB.L      #12,D2
    SUB.L      #0,D1
    SUB.L      #-5,D2
    SUB.B      D1,(A1)
    SUB.B      D2,-(A2)
    SUB.B      D3,(A3)+
    SUB.B      D4,$1234
    SUB.B      D5,$12345678
    SUB.W      D1,(A1)
    SUB.W      D2,-(A2)
    SUB.W      D3,(A3)+
    SUB.W      D4,$1234
    SUB.W      D5,$12345678
    SUB.L      D1,(A1)
    SUB.L      D2,-(A2)
    SUB.L      D3,(A3)+
    SUB.L      D4,$1234
    SUB.L      D5,$12345678     
    ;ADD
    ADD.B     D1,D2
    ADD.B     (A1),D3
    ADD.B     (A4)+,D4
    ADD.B      -(A3),D2
    ADD.B      $1234,D1
    ADD.B      $12345678,D2
    ADD.B      #127,D2
    ADD.B      #0,D1
    ADD.B      #-125,D2
    ADD.W     D1,D2
    ADD.W     A1,D2
    ADD.W     (A1),D3
    ADD.W     (A4)+,D4
    ADD.W      -(A3),D2
    ADD.W      $1234,D1
    ADD.W      $12345678,D2
    ADD.W      #12,D2
    ADD.W      #0,D1
    ADD.W      #-5,D2
    ADD.L     D1,D2
    ADD.L     A1,D2
    ADD.L     (A1),D3
    ADD.L     (A4)+,D4
    ADD.L      -(A3),D2
    ADD.L      $1234,D1
    ADD.L      $12345678,D2
    ADD.L      #12,D2
    ADD.L      #0,D1
    ADD.L      #-5,D2
    ADD.B      D1,(A1)
    ADD.B      D2,-(A2)
    ADD.B      D3,(A3)+
    ADD.B      D4,$1234
    ADD.B      D5,$12345678
    ADD.W      D1,(A1)
    ADD.W      D2,-(A2)
    ADD.W      D3,(A3)+
    ADD.W      D4,$1234
    ADD.W      D5,$12345678
    ADD.L      D1,(A1)
    ADD.L      D2,-(A2)
    ADD.L      D3,(A3)+
    ADD.L      D4,$1234
    ADD.L      D5,$12345678    
    ;ADDA
    ADDA.W      D1,A1
    ADDA.W      A2,A2
    ADDA.W      (A3),A2
    ADDA.W       -(A4),A2
    ADDA.W       (A1)+,A2
    ADDA.W      #1234,A2
    ADDA.W      #-1234,A2
    ADDA.W      #0,A2
    ADDA.W      $1234,A2
    ADDA.W      $12345678,A5
    ADDA.L      D1,A1
    ADDA.L      A2,A2
    ADDA.L      (A3),A2
    ADDA.L       -(A4),A2
    ADDA.L       (A1)+,A2
    ADDA.L      #1234,A2
    ADDA.L      $1234,A2
    ADDA.L      $12345678,A5
    ADDA.L      #-12,A2
    ADDA.L      #0,A2
    ;BCC
    BRA     $53E5
    BCC     $53E0
    BEQ     $53E9
    BLE     $53EC
    BGT     $53ED
    BRA     $1000
    BCC     $6000
    BEQ     $4000
    BLE     $3500
    BGT     $D000
    ;ROL Memory shift
    ROL     (A1)
    ROL     -(A1)
    ROL     (A4)+
    ROL     $1234
    ROL     $12345678
    ;ROR Memory shift
    ROR     (A1)
    ROR     -(A1)
    ROR     (A4)+
    ROR     $1234
    ROR     $12345678    
    ;LSL Memory shift
    LSL     (A1)
    LSL     -(A1)
    LSL     (A4)+
    LSL     $1234
    LSL     $12345678  
    ;LSR Memory shift
    LSR     (A1)
    LSR     -(A1)
    LSR     (A4)+
    LSR     $1234
    LSR     $12345678
    ;ASR Memory shift
    ASR     (A1)
    ASR     -(A1)
    ASR     (A4)+
    ASR     $1234
    ASR     $12345678
    ;ASL Memory shift
    ASL     (A1)
    ASL     -(A1)
    ASL     (A4)+
    ASL     $1234
    ASL     $12345678
    ;ROL REGISTER shift
    ROL     #2,D1
    ROL     D1,D2
    ;ROR REGISTER shift
    ROR     #2,D1
    ROR     D1,D2
    ;LSL REGISTER shift
    LSL     #2,D1
    LSL     D1,D2
    ;LSR REGISTER shift
    LSR     #2,D1
    LSR     D1,D2
    ;ASL REGISTER shift
    ASL     #2,D1
    ASL     D1,D2
    ;ASR REGISTER shift
    ASR     #2,D1
    ASR     D1,D2
    ;MOVEM
    MOVEM.W   D1/D3/D4-D5/A1-A5,(A1)
    MOVEM.W   D2-D3/D4-D5/A1-A5,$1234
    MOVEM.W   D1/D3/D4-D5/A1-A5,$12345678
    MOVEM.W   D1/D3/D4-D5/A1-A5,-(A1)
    MOVEM.L   D1/D3/D4-D5/A1-A5,-(A1)  
    MOVEM.L   D1/D3/D4-D5/A1-A5,(A1)
    MOVEM.L   D2-D3/D4-D5/A1-A5,$1234
    MOVEM.L   D1/D3/D4-D5/A1-A5,$12345678
    MOVEM.W   (A1),D1/D3/D4-D5/A1-A5
    MOVEM.W   (A1)+,D1/D3/D4-D5/A1-A5
    MOVEM.W   $1234,D1/D3/D4-D5/A1-A5
    MOVEM.W   $12345678,D1/D3/D4-D5/A1-A5
    MOVEM.L   (A1),D1/D3/D4-D5/A1-A5
    MOVEM.L   (A1)+,D1/D3/D4-D5/A1-A5
    MOVEM.L   $1234,D1/D3/D4-D5/A1-A5
    MOVEM.L   $12345678,D1/D3/D4-D5/A1-A5
    SIMHALT             ; halt simalator

* Put variables and constants here

    END    START        ; last line of source

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
