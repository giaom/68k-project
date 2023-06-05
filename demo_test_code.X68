*****************************
*
* demo_test.X68
* Created 12/05/2018
* Test program for CSS 422 Disassembler Project Demo
*
* Edited 6/04/2023
*
*****************************

start		EQU	 $00009000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000
		    ORG	 start

NOP
    DC $4E75    ; RTS
    DC $4E71    ; NOP
    DC $4E75    ; RTS
    DC $41D0    ; LEA     (A0),A0
    DC $41D5    ; LEA     (A5),A0
    DC $41D7    ; LEA     (A7),A0
    DC $4FD0    ; LEA     (A0),A7
    DC $4FD5    ; LEA     (A5),A7
    DC $4FD7    ; LEA     (A7),A7
    
MOVE_TESTS:
    DC $1200    ; MOVE.B    D0,D1
    DC $1080    ; MOVE.B    D0,(A0)
    DC $10C0    ; MOVE.B    D0,(A0)+
    DC $1100    ; MOVE.B    D0,-(A0)
    DC $1010    ; MOVE.B    (A0),D0
    DC $1290    ; MOVE.B    (A0),(A1)
    DC $12D0    ; MOVE.B    (A0),(A1)+
    DC $1310    ; MOVE.B    (A0),-(A1)
    DC $1018    ; MOVE.B    (A0)+,D0
    DC $1298    ; MOVE.B    (A0)+,(A1)
    DC $12D8    ; MOVE.B    (A0)+,(A1)+
    DC $1318    ; MOVE.B    (A0)+,-(A1)
    DC $1020    ; MOVE.B    -(A0),D0
    DC $12A0    ; MOVE.B    -(A0),(A1)
    DC $12E0    ; MOVE.B    -(A0),(A1)+
    DC $1320    ; MOVE.B    -(A0),-(A1)
    DC $3200    ; MOVE.W    D0,D1
    DC $3080    ; MOVE.W    D0,(A0)
    DC $30C0    ; MOVE.W    D0,(A0)+
    DC $3100    ; MOVE.W    D0,-(A0)
    DC $3008    ; MOVE.W    A0,D0
    DC $3288    ; MOVE.W    A0,(A1)
    DC $32C8    ; MOVE.W    A0,(A1)+
    DC $3308    ; MOVE.W    A0,-(A1)
    DC $3010    ; MOVE.W    (A0),D0
    DC $3290    ; MOVE.W    (A0),(A1)
    DC $32D0    ; MOVE.W    (A0),(A1)+
    DC $3310    ; MOVE.W    (A0),-(A1)
    DC $3018    ; MOVE.W    (A0)+,D0
    DC $3298    ; MOVE.W    (A0)+,(A1)
    DC $32D8    ; MOVE.W    (A0)+,(A1)+
    DC $3318    ; MOVE.W    (A0)+,-(A1)
    DC $3020    ; MOVE.W    -(A0),D0
    DC $32A0    ; MOVE.W    -(A0),(A1)
    DC $32E0    ; MOVE.W    -(A0),(A1)+
    DC $3320    ; MOVE.W    -(A0),-(A1)
    DC $2200    ; MOVE.L    D0,D1
    DC $2080    ; MOVE.L    D0,(A0)
    DC $20C0    ; MOVE.L    D0,(A0)+
    DC $2100    ; MOVE.L    D0,-(A0)
    DC $2008    ; MOVE.L    A0,D0
    DC $2288    ; MOVE.L    A0,(A1)
    DC $22C8    ; MOVE.L    A0,(A1)+
    DC $2308    ; MOVE.L    A0,-(A1)
    DC $2010    ; MOVE.L    (A0),D0
    DC $2290    ; MOVE.L    (A0),(A1)
    DC $22D0    ; MOVE.L    (A0),(A1)+
    DC $2310    ; MOVE.L    (A0),-(A1)
    DC $2018    ; MOVE.L    (A0)+,D0
    DC $2298    ; MOVE.L    (A0)+,(A1)
    DC $22D8    ; MOVE.L    (A0)+,(A1)+
    DC $2318    ; MOVE.L    (A0)+,-(A1)
    DC $2020    ; MOVE.L    -(A0),D0
    DC $22A0    ; MOVE.L    -(A0),(A1)
    DC $22E0    ; MOVE.L    -(A0),(A1)+
    DC $2320    ; MOVE.L    -(A0),-(A1)
    
MOVEM_TESTS:
    DC $48A1    ; MOVEM.W   A1-A7,-(A1)
    DC $007F
    DC $48E1    ; MOVEM.L   D1-D7,-(A1)
    DC $7F00
    DC $48A1    ; MOVEM.W   A1/D7,-(A1)
    DC $0140
    DC $48E1    ; MOVEM.L   A1/D7,-(A1)
    DC $0140
    DC $4891    ; MOVEM.W   A1-A7,(A1)
    DC $FE00
    DC $48D1    ; MOVEM.L   D1-D7,(A1)
    DC $00FE
    DC $4891    ; MOVEM.W   A1/D7,(A1)
    DC $0280
    DC $48D1    ; MOVEM.L   A1/D7,(A1)
    DC $0280
    DC $4C99    ; MOVEM.W   (A1)+,A1-A7
    DC $FE00
    DC $4CD9    ; MOVEM.L   (A1)+,D1-D7
    DC $00FE
    DC $4C99    ; MOVEM.W   (A1)+,A1/D7
    DC $0280
    DC $4CD9    ; MOVEM.L   (A1)+,A1/D7
    DC $0280
    DC $4C91    ; MOVEM.W   (A1),A1-A7
    DC $FE00
    DC $4CD1    ; MOVEM.L   (A1),D1-D7
    DC $00FE
    DC $4C91    ; MOVEM.W   (A1),A1/D7
    DC $0280
    DC $4CD1    ; MOVEM.L   (A1),A1/D7
    DC $0280
    
MOVEA_TESTS:
    DC $3040    ; MOVEA.W    D0,A0
    DC $3048    ; MOVEA.W    A0,A0
    DC $3050    ; MOVEA.W    (A0),A0
    DC $3058    ; MOVEA.W    (A0)+,A0
    DC $3060    ; MOVEA.W    -(A0),A0
    DC $2040    ; MOVEA.L    D0,A0
    DC $2048    ; MOVEA.L    A0,A0
    DC $2050    ; MOVEA.L    (A0),A0
    DC $2058    ; MOVEA.L    (A0)+,A0
    DC $2060    ; MOVEA.L    -(A0),A0  
    
ADD_TESTS:
    DC $D401    ; ADD.B     D1,D2
    DC $D311    ; ADD.B     D1,(A1)
    DC $D319    ; ADD.B     D1,(A1)+
    DC $D321    ; ADD.B     D1,-(A1)
    DC $D211    ; ADD.B     (A1),D1
    DC $D219    ; ADD.B     (A1)+,D1
    DC $D221    ; ADD.B     -(A1),D1
    DC $D441    ; ADD.W     D1,D2
    DC $D351    ; ADD.W     D1,(A1)
    DC $D359    ; ADD.W     D1,(A1)+
    DC $D361    ; ADD.W     D1,-(A1)
    DC $D251    ; ADD.W     (A1),D1
    DC $D259    ; ADD.W     (A1)+,D1
    DC $D261    ; ADD.W     -(A1),D1
    DC $D481    ; ADD.L     D1,D2
    DC $D391    ; ADD.L     D1,(A1)
    DC $D399    ; ADD.L     D1,(A1)+
    DC $D3A1    ; ADD.L     D1,-(A1)
    DC $D291    ; ADD.L     (A1),D1
    DC $D299    ; ADD.L     (A1)+,D1
    DC $D2A1    ; ADD.L     -(A1),D1
    DC $D4C1    ; ADDA.W        D1,A2
    DC $D4D1    ; ADDA.W        (A1),A2
    DC $D4D9    ; ADDA.W        (A1)+,A2
    DC $D4E1    ; ADDA.W        -(A1),A2
    DC $D5C1    ; ADDA.L        D1,A2
    DC $D5D1    ; ADDA.L        (A1),A2
    DC $D595    ; ADDA.L        (A1)+,A2
    DC $D5E1    ; ADDA.L        -(A1),A2
    
SUB_TESTS:
    DC $9401    ; SUB.B     D1,D2
    DC $9311    ; SUB.B     D1,(A1)
    DC $9319    ; SUB.B     D1,(A1)+
    DC $9321    ; SUB.B     D1,-(A1)
    DC $9211    ; SUB.B     (A1),D1
    DC $9219    ; SUB.B     (A1)+,D1
    DC $9221    ; SUB.B     -(A1),D1
    DC $9441    ; SUB.W     D1,D2
    DC $92C1    ; SUB.W     D1,A1
    DC $9351    ; SUB.W     D1,(A1)
    DC $9359    ; SUB.W     D1,(A1)+
    DC $9361    ; SUB.W     D1,-(A1)
    DC $9249    ; SUB.W     A1,D1
    DC $9251    ; SUB.W     (A1),D1
    DC $9259    ; SUB.W     (A1)+,D1
    DC $9261    ; SUB.W     -(A1),D1
    DC $9481    ; SUB.L     D1,D2
    DC $93C1    ; SUB.L     D1,A1
    DC $9391    ; SUB.L     D1,(A1)
    DC $9399    ; SUB.L     D1,(A1)+
    DC $93A1    ; SUB.L     D1,-(A1)
    DC $9289    ; SUB.L     A1,D1
    DC $9291    ; SUB.L     (A1),D1
    DC $9299    ; SUB.L     (A1)+,D1
    DC $92A1    ; SUB.L     -(A1),D1 

MULS_TESTS:   
    DC $C3C0    ; MULS.W    D0,D1
    DC $C3D0    ; MULS.W    (A0),D1
    DC $C3E0    ; MULS.W    -(A0),D1
    DC $C3D8    ; MULS.W    (A0)+,D1
    DC $82C0    ; DIVU.W    D0,D1
    DC $82D0    ; DIVU.W    (A0),D1
    DC $82E0    ; DIVU.W    -(A0),D1
    DC $82D8    ; DIVU.W    (A0)+,D1
    
AND_TESTS:
    DC $C401    ; AND.B     D1,D2
    DC $C311    ; AND.B     D1,(A1)
    DC $C319    ; AND.B     D1,(A1)+
    DC $C321    ; AND.B     D1,-(A1)
    DC $C211    ; AND.B     (A1),D1
    DC $C219    ; AND.B     (A1)+,D1
    DC $C221    ; AND.B     -(A1),D1
    DC $C441    ; AND.W     D1,D2
    DC $C351    ; AND.W     D1,(A1)
    DC $C359    ; AND.W     D1,(A1)+
    DC $C361    ; AND.W     D1,-(A1)
    DC $C251    ; AND.W     (A1),D1
    DC $C259    ; AND.W     (A1)+,D1
    DC $C261    ; AND.W     -(A1),D1
    DC $C481    ; AND.L     D1,D2
    DC $C391    ; AND.L     D1,(A1)
    DC $C399    ; AND.L     D1,(A1)+
    DC $C3A1    ; AND.L     D1,-(A1)
    DC $C291    ; AND.L     (A1),D1
    DC $C299    ; AND.L     (A1)+,D1
    DC $C2A1    ; AND.L     -(A1),D1
    
OR_TESTS:
    DC $8401    ; OR.B     D1,D2
    DC $8311    ; OR.B     D1,(A1)
    DC $8319    ; OR.B     D1,(A1)+
    DC 9321$    ; OR.B     D1,-(A1)
    DC $8211    ; OR.B     (A1),D1
    DC $8219    ; OR.B     (A1)+,D1
    DC $8221    ; OR.B     -(A1),D1
    DC $8441    ; OR.W     D1,D2
    DC $8351    ; OR.W     D1,(A1)
    DC $8359    ; OR.W     D1,(A1)+
    DC $8261    ; OR.W     D1,-(A1)
    DC $8251    ; OR.W     (A1),D1
    DC $8259    ; OR.W     (A1)+,D1
    DC $8261    ; OR.W     -(A1),D1
    DC $8481    ; OR.L     D1,D2
    DC $8391    ; OR.L     D1,(A1)
    DC $8399    ; OR.L     D1,(A1)+
    DC $83A1    ; OR.L     D1,-(A1)
    DC $8291    ; OR.L     (A1),D1
    DC $8299    ; OR.L     (A1)+,D1
    DC $82A1    ; OR.L     -(A1),D1
    
LSL_TESTS:
    DC $E32A    ; LSL.B     D1,D2
    DC $E36A    ; LSL.W     D1,D2
    DC $E3D1    ; LSL.W     (A1)
    DC $E3D9    ; LSL.W     (A1)+
    DC $E3E1    ; LSL.W     -(A1)
    DC $E3AA    ; LSL.L     D1,D2
    DC $E22A    ; LSR.B     D1,D2
    DC $E26A    ; LSR.W     D1,D2
    DC $E2D1    ; LSR.W     (A1)
    DC $E2D9    ; LSR.W     (A1)+
    DC $E2E1    ; LSR.W     -(A1)
    DC $E2AA    ; LSR.L     D1,D2  

ASR_TESTS:  
    DC $E222    ; ASR.B     D1,D2
    DC $E262    ; ASR.W     D1,D2
    DC $E0D1    ; ASR.W     (A1)
    DC $E0D9    ; ASR.W     (A1)+
    DC $E0E1    ; ASR.W     -(A1)
    DC $E2A2    ; ASR.L     D1,D2
    DC $E322    ; ASL.B     D1,D2
    DC $E362    ; ASL.W     D1,D2
    DC $E1D1    ; ASL.W     (A1)
    DC $E1D9    ; ASL.W     (A1)+
    DC $E1E1    ; ASL.W     -(A1)
    DC $E3A2    ; ASL.L     D1,D2  
    
BRANCH_TESTS:
    DC $6E30    ; BGT.B     label1
    DC $6E40    ; BGT.B     label2
    DC $6F2C    ; BLE.B     label1
    DC $653C    ; BLE.B     label2
    DC $6C28    ; BGE.B     label1
    DC $6738    ; BEQ.B     label2
    DC $6700    ; BEQ.W     label1
    DC $0024
    
JSR_TESTS:
    DC $4E90    ; JSR       (A0)
    DC $4EB8    ; JSR       $1234
    DC $1234
    DC $4EB9    ; JSR       $12345678
    DC $1234
    DC $5678
    DC $4EB9    ; JSR       label1
    DC $0000
    DC $9208
    DC $4EB9    ; JSR       label2
    DC $0000
    DC $921A
    DC $4EB9    ; JSR       label3
    DC $0000
    DC $9220
    
MISC_TESTS:
    DC $4E71    ; NOP
    DC $4E75    ; RTS
    
label1
    DC $4E71    ; NOP
    DC $4E75    ; RTS
    DC $41F8    ; LEA       $12,A0
    DC $0012
    DC $41F8    ; LEA       $1234,A0
    DC $1234
    DC $41F8    ; LEA       $12345678,A0
    DC $1234
    DC $5678
label2

MOVEQ_TESTS:
    DC $7000    ; MOVEQ     #$0,D0
    DC $7012    ; MOVEQ     #$12,D0
    DC $70FF    ; MOVEQ     #$FF,D0
label3

MOVEM_TESTS:
    DC $48B8    ; MOVEM.W   A1-A7,$12
    DC $FE00
    DC $0012
    DC $48F8    ; MOVEM.L   D1-D7,$12
    DC $00FE
    DC $0012
    DC $48B8    ; MOVEM.W   A1/D7,$12
    DC $0280
    DC $0012
    DC $48F8    ; MOVEM.L   A1/D7,$12
    DC $0280
    DC $0012
    DC $48B8    ; MOVEM.W   A1-A7,$1234
    DC $FE00
    DC $1234
    DC $48F8    ; MOVEM.L   D1-D7,$1234
    DC $00FE
    DC $1234
    DC $48B8    ; MOVEM.W   A1/D7,$1234
    DC $0280
    DC $1234
    DC $48F8    ; MOVEM.L   A1/D7,$1234
    DC $0290
    DC $1234
    DC $48B9    ; MOVEM.W   A1-A7,$12345678
    DC $FE00
    DC $1234
    DC $5678
    DC $48F9    ; MOVEM.L   D1-D7,$12345678
    DC $00FE
    DC $1234
    DC $5678
    DC $48B9    ; MOVEM.W   A1/D7,$12345678
    DC $0280
    DC $1234
    DC $5678
    DC $48F9    ; MOVEM.L   A1/D7,$12345678
    DC $0280
    DC $1234
    DC $5678
    DC $4CBB    ; MOVEM.W   $12,A1-A7
    DC $FE00
    DC $0012
    DC $4CF8    ; MOVEM.L   $12,D1-D7
    DC $00FE
    DC $0012
    DC $4CB8    ; MOVEM.W   $12,A1/D7
    DC $0280
    DC $0012
    DC $4CF8    ; MOVEM.L   $12,A1/D7
    DC $0280
    DC $0012
    DC $4CB8    ; MOVEM.W   $1234,A1-A7
    DC $FE00
    DC $1234
    DC $4CF8    ; MOVEM.L   $1234,D1-D7
    DC $00FE
    DC $1234
    DC $4CB8    ; MOVEM.W   $1234,A1/D7
    DC $0280
    DC $1234
    DC $4CF8    ; MOVEM.L   $1234,A1/D7
    DC $0280
    DC $1234
    DC $4CB9    ; MOVEM.W   $12345678,A1-A7
    DC $FE00
    DC $1234
    DC $5678
    DC $4CF9    ; MOVEM.L   $12345678,D1-D7
    DC $00FE
    DC $1234
    DC $5678
    DC $4CB9    ; MOVEM.W   $12345678,A1/D7
    DC $0280
    DC $1234
    DC $5678
    DC $4CF9    ; MOVEM.L   $12345678,A1/D7
    DC $0280
    DC $1234
    DC $5678
    
ADDA_TESTS:
    DC $D4F8    ; ADDA.W    $12,A2
    DC $0012
    DC $D458    ; ADDA.W    $1234,A2
    DC $1234
    DC $D4F9    ; ADDA.W    $12345678,A2
    DC $1234
    DC $5678
    DC $D4FC    ; ADDA.W    #$1234,A2
    DC $1234
    DC $D5F8    ; ADDA.L    $12,A2
    DC $0012
    DC $D5F8    ; ADDA.L    $1234,A2
    DC $1234
    DC $D5F9    ; ADDA.L    $12345678,A2
    DC $1234
    DC $5678
    DC $D5FC    ; ADDA.L    #$12345678,A2
    DC $1234
    DC $5678

MULS_TESTS:
    DC $C3F8    ; MULS.W    $12,D1
    DC $0012
    DC $C3F8    ; MULS.W    $1234,D1
    DC $1234
    DC $C3F9    ; MULS.W    $12345678,D1
    DC $1234
    DC $5678
    DC $C3FC    ; MULS.W    #$1234,D1
    DC $1234
    
DIVU_TESTS:
    DC $82F8    ; DIVU.W    $12,D1
    DC $0012
    DC $82F8    ; DIVU.W    $1234,D1
    DC $1234
    DC $82F9    ; DIVU.W    $12345678,D1
    DC $1234
    DC $5678
    DC $82FC    ; DIVU.W    #$1234,D1
    DC $1234
    
AND_TESTS:
    DC $C338    ; AND.B     D1,$12
    DC $0012
    DC $C338    ; AND.B     D1,$1234
    DC $1234
    DC $C339    ; AND.B     D1,$12345678
    DC $1234
    DC $5678
    DC $C238    ; AND.B     $12,D1
    DC $0012
    DC $C238    ; AND.B     $1234,D1
    DC $1234
    DC $C239    ; AND.B     $12345678,D1
    DC $1234
    DC $5678
    DC $C23C    ; AND.B     #$12,D1
    DC $0012
    DC $C378    ; AND.W     D1,$12
    DC $0012
    DC $C378    ; AND.W     D1,$1234
    DC $1234
    DC $C379    ; AND.W     D1,$12345678
    DC $1234
    DC $5678
    DC $C278    ; AND.W     $12,D1
    DC $0012
    DC $C278    ; AND.W     $1234,D1
    DC $1234
    DC $C279    ; AND.W     $12345678,D1
    DC $1234
    DC $5678
    DC $C27C    ; AND.W     #$1234,D1
    DC $1234
    DC $C3B8    ; AND.L     D1,$12
    DC $0012
    DC $C3B8    ; AND.L     D1,$1234
    DC $1234
    DC $C3B9    ; AND.L     D1,$12345678
    DC $1234
    DC $5678
    DC $C2B8    ; AND.L     $12,D1
    DC $0012
    DC $C2B8    ; AND.L     $1234,D1
    DC $1234
    DC $C2B9    ; AND.L     $12345678,D1
    DC $1234
    DC $5678
    DC $C2BC    ; AND.L     #$12345678,D1
    DC $1234
    DC $5678
    
LSL_TESTS:
    DC $E30A    ; LSL.B     #$1,D2
    DC $E54A    ; LSL.W     #$2,D2
    DC $E78A    ; LSL.L     #$3,D2
    DC $E3F8    ; LSL.W     $12
    DC $0012
    DC $E3F8    ; LSL.W     $1234
    DC $1234
    DC $E3F9    ; LSL.W     $12345678
    DC $1234
    DC $5678
    
ASR_TESTS:
    DC $E202    ; ASR.B     #$1,D2
    DC $E442    ; ASR.W     #$2,D2
    DC $E682    ; ASR.L     #$3,D2
    DC $E0F8    ; ASR.W     $12
    DC $0012
    DC $E0F8    ; ASR.W     $1234
    DC $1234
    DC $E0F9    ; ASR.W     $12345678
    DC $1234
    DC $5678
label4

BRANCH_TESTS2:
    DC $6EFE    ; BGT.B     label4
    DC $6EFC    ; BGT.B     label4
    DC $6EFA    ; BGT.B     label4
    
    DC $6F00    ; BLE.W     label1
    DC $FE6C
    DC $6F00    ; BLE.W     label2
    DC $FE7A
    DC $6F00    ; BLE.W     label3
    DC $FE7C
    
    DC $6700    ; BEQ.W     label1
    DC $FE60
    DC $6700    ; BEQ.W     label2
    DC $FE6E
    DC $6700    ; BEQ.W     label3
    DC $FE70
    
JSR_TESTS2:
    DC $4EB9    ; JSR       label1
    DC $0000
    DC $9208
    DC $4EB9    ; JSR       label2
    DC $0000
    DC $921A
    DC $4EB9    ; JSR       label3
    DC $0000
    DC $9220
    
END_TESTS:
    DC $FFFF    ; SIMHALT
    DC $FFFF


    SIMHALT             ; halt simulator
    END    START        ; last line of source


