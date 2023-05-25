*-----------------------------------------------------------
* Title      : Reverse Assmebler
* Written by : Lok Yin Wong
* Date       : 5/11/2023
* Description:
*-----------------------------------------------------------
CR  EQU $0D
LF  EQU $0A
stack            EQU      $A000
example          EQU      $E7F8   *made up bits       
shift            EQU     12                   *Shift 12 bits 
START: ORG $1000
*------------Use A0, d1,d0,d2,A2,A1
               LEA     jmp_table,A0    *Index into the table
               CLR.L   D0              *Zero it
               MOVE.W  #example,D0     *We'll play with it here
               MOVE.B  #shift,D1       *Shift 12 bits to the right  
               LSR.W   D1,D0           *Move the bits
               MOVE.L   #example,D1    *Store that full 16 bits at d1 
               CMP      #0,D0
jmp_table      BEQ.L     code0000
               CMP      #1,D0
               BEQ.L      code0001
               CMP      #2,D0     
               BEQ.L        code0010
               CMP      #3,D0
               BEQ.L         code0011
               CMP      #4,D0
               BEQ.L         code0100
               CMP      #5,D0
               BEQ.L         code0101
               CMP      #6,D0
               BEQ.L         code0110
               CMP      #7,D0
               BEQ.L         code0111
               CMP      #8,D0
               BEQ.L         code1000
               CMP      #9,D0
               BEQ.L         code1001
               CMP      #10,D0
               BEQ.L         code1010
               CMP      #11,D0
               BEQ.L         code1011
               CMP      #12,D0
               BEQ.L         code1100
               CMP      #13,D0
               BEQ.L         code1101
               CMP      #14,D0
               BEQ.L         code1110
               CMP      #15,D0
               BEQ.L         code1111
               

code0000       JMP         data

code0001       MOVE.B      #1,D0            ;MOVE.B
               MOVE.B      #1,D1  
               JMP         DONE

code0010       
               MOVE.L   #example,D1    *Store that full 16 bits at d1 
               BTST        #6,D1
               BEQ         MOVEL
               BTST        #7,D1
               BNE         MOVEL    
               BTST        #8,D1
               BNE         MOVEL
               MOVE.L      #3,D0
               MOVE.L      #1,D1            ;MOVEA.L
               JMP         DONE
               
MOVEL          MOVE.L      #2,D0
               MOVE.L      #1,D1            ;MOVE.L
               JMP         DONE

code0011
               MOVE.L   #example,D1    *Store that full 16 bits at d1 
               BTST        #6,D1
               BEQ         MOVEW
               BTST        #7,D1
               BNE         MOVEW    
               BTST        #8,D1
               BNE         MOVEW
               MOVE.L      #5,D0
               MOVE.L      #1,D1            ;MOVEA.W
               JMP         DONE
               
MOVEW          MOVE.L      #4,D0
               MOVE.L      #1,D1            ;MOVE.W
               JMP         DONE


code0100       CMP         #$4E75,D1
               BEQ         RTS
               CMP         #$4E71,D1
               BEQ         NOP
               BTST        #8,D1
               BEQ         MOVEMJSRNOT
               MOVE.L      #7,D0        ;LEA
               MOVE.L      #1,D1
               JMP         DONE   
               
NOT            BTST        #7,D1
               BEQ         NOTBW
               MOVE.L      #8,D0        ;NOT.L
               MOVE.L      #1,D1
               JMP         DONE
               
NOTBW          BTST        #6,D1
               BEQ         NOTB
               MOVE.L      #10,D0       ;NOT.W
               MOVE.L      #1,D1
               JMP          DONE

NOTB          MOVE.L       #11,D0
              MOVE.L       #1,D1        ;NOT.B
              JMP          DONE
               
NOP            MOVE.L      #9,D0        ;NOP
               MOVE.L      #0,D1
               JMP         DONE

MOVEMJSRNOT    BTST        #9,D1
               BEQ         MOVEM
               BTST        #11,D1
               BEQ         NOT
               MOVE.L      #12,D0
               MOVE.L      #1,D1        ;JSR
               JMP         DONE
               
MOVEM          BTST        #6,D1
               BEQ         MOVEMW
               MOVE.L      #13,D0       ;MOVEM.L
               MOVE.L      #1,D1
               JMP         DONE
               
MOVEMW         MOVE.L      #14,D0       ;MOVEM.W
               MOVE.L      #1,D1
               JMP         DONE 

RTS            MOVE.L      #6,D0
               MOVE.L      #0,D1
               JMP         DONE
               
code0101       BTST        #8,D1
               BNE         data
               BTST        #7,D1
               BNE         ADDQL
               BTST         #6,D1
               BEQ         ADDQB
               MOVE.L      #15,D0       ;ADDQ.W
               MOVE.L      #1,D1
               JMP         DONE
               
ADDQL          BTST        #6,D1
               BNE.L        DATA
               MOVE.L      #16,D0      ;ADDQ.L
               MOVE.L      #1,D1
               JMP         DONE
               
ADDQB          MOVE.L      #17,D0   ;ADDQ.B
               MOVE.L      #1,D1
               JMP         DONE     

               
code0110       BTST        #11,D1
               BNE         BGTBLE
               BTST        #10,D1
               BEQ         BRA1
               BTST        #9,D1
               BEQ         BCC1
               BTST        #8,D1
               BEQ         data
               MOVE.L      #36,D0           ;BEQ
               MOVE.L      #1,D1
               JMP         DONE
               
               
BCC1           BTST        #8,D1
               BNE         data
               MOVE.L      #37,D0           ;BCC
               MOVE.L      #1,D1
               JMP         DONE

BRA1           BTST        #9,D1
               BNE         data
               BTST        #8,D1
               BNE         data
               MOVE.L      #35,D0           ;BRA
               MOVE.L      #1,D1        
               JMP         DONE
               
BGTBLE         BTST        #10,D1
               BEQ         data
               BTST        #9,D1
               BEQ         data
               BTST        #8,D1
               BNE         BLE1
               MOVE.L      #33,D0       ;BGT
               MOVE.L      #1,D1
               JMP         DONE

BLE1           MOVE.L      #34,D0
               MOVE.L      #1,D1        ;BLE
               JMP         DONE
               

code0111       BTST        #8,D1
               BNE         DATA
               MOVE.L      #18,D0   ;MOVEQ
               MOVE.L      #1,D1
               JMP         DONE
               
code1000       BTST        #8,D1
               BEQ         OR
               BTST        #7,D1
               BEQ         OR
               BTST        #6,D1
               BEQ         OR
               JMP         DATA
               
               
OR             BTST        #7,D1
               BNE         ORL
               BTST        #6,D1
               BNE         ORW
               MOVE.L      #19,D0
               MOVE.L      #1,D1        OR.B
               JMP         DONE 
               
ORW            MOVE.L      #20,D0   ;OR.W
               MOVE.L      #1,D1
               JMP         DONE
               
ORL            MOVE.L      #21,D0   ;OR.L
               MOVE.L      #1,D1
               JMP         DONE 
       

code1001       
               BTST        #8,D1
               BEQ         SUB
               BTST        #7,D1
               BEQ         SUB
               BTST        #6,D1
               BEQ         SUB
               JMP         DATA
               
               
SUB            BTST        #7,D1
               BNE         SUBL
               BTST        #6,D1
               BNE         SUBW
               MOVE.L      #22,D0
               MOVE.L      #1,D1        SUB.B
               JMP         DONE 
               
SUBW           MOVE.L      #23,D0   ;SUB.W
               MOVE.L      #1,D1
               JMP         DONE
               
SUBL           MOVE.L      #24,D0   ;SUB.L
               MOVE.L      #1,D1
               JMP         DONE

code1010       JMP         data

code1011       JMP         data

code1100       
               BTST        #8,D1
               BEQ         AND
               BTST        #7,D1
               BEQ         AND
               BTST        #6,D1
               BEQ         AND
               JMP         DATA
               
               
AND            BTST        #7,D1
               BNE         ANDL
               BTST        #6,D1
               BNE         ANDW
               MOVE.L      #25,D0
               MOVE.L      #1,D1      AND.B
               JMP         DONE 
               
ANDW            MOVE.L      #26,D0   ;AND.W
               MOVE.L      #1,D1
               JMP         DONE
               
ANDL            MOVE.L      #27,D0   ;AND.L
               MOVE.L      #1,D1
               JMP         DONE 
       

code1101       BTST        #6,D1
               BEQ         ADD
               BTST        #7,D1
               BEQ         ADD
               BTST        #8,D1
               BEQ         ADDAW
               MOVE.L      #28,D0
               MOVE.L      #1,D1    ;ADDA.L
               JMP         DONE
               
ADDAW          MOVE.L      #29,D0
               MOVE.L      #1,D1   ;ADDA.W
               JMP         DONE

               
ADD            BTST        #7,D1
               BNE         ADDL
               BTST        #6,D1
               BNE         ADDW
               MOVE.L      #30,D0   ;ADD.B
               MOVE.L      #1,D1
               JMP         DONE
               
ADDL           MOVE.L      #31,D0   ;ADD.L
               MOVE.L      #1,D1
               JMP         DONE

ADDW           MOVE.L      #32,D0   ;ADD.W
               MOVE.L      #1,D1    
               JMP         DONE

code1110       BTST        #7,D1
               BEQ         REGISTERSHIFT
               BTST        #6,D1
               BEQ         REGISTERSHIFT
               BTST        #11,D1
               BNE         data
               BTST        #10,D1
               BEQ         LORA
               BTST        #9,D1            ;ROR/ROL
               BEQ         data
               BTST        #8,D1
               BEQ         RORM
               MOVE.L      #38,D0           ;ROL(MEMORY SHIFT)
               MOVE.L      #1,D1
               JMP         DONE
               
               
RORM           MOVE.L      #39,D0           ;ROR(MEMORY SHIFT)
               MOVE.L      #1,D1
               JMP         DONE
               
LORA            BTST        #9,D1
               BEQ         ASRM
               BTST        #8,D1
               BEQ         LSRM
               MOVE.L      #40,D0           ;LSL(MEMORY SHIFT)
               MOVE.L      #1,D1
               JMP         DONE

LSRM           MOVE.L      #41,D0
               MOVE.L      #1,D1            ;LSR(MEMROY SHIFT)
               JMP         DONE  
             
             
ASRM           BTST        #8,D1
               BNE         ASLM
               MOVE.L      #42,D0           ;ASR(MEMORY SHIFT)
               MOVE.L      #1,D1
               JMP         DONE

ASLM           MOVE.L      #43,D0
               MOVE.L      #1,D1            ;ASL(MEMORY SHIFT)
               JMP         DONE

REGISTERSHIFT BTST        #4,D1
              BEQ         AORL
              BTST        #3,D1
              BEQ         data
              BTST        #8,D1
              BNE         ROLR              
              BTST        #7,D1            ;ROR(RIGISTER SHIFT)
              BEQ         RORBW
              BTST        #6,D1
              BNE         data
              MOVE.L      #44,D0            ;ROR.L
              MOVE.L      #1,D1
              JMP         DONE

RORBW       BTST         #6,D1
            BEQ          RORB
            MOVE.L       #45,D0
            MOVE.L       #1,D1              ;ROR.W
            JMP          DONE
            
RORB        MOVE.L       #46,D0
            MOVE.L       #1,D1              ;ROR.B
            JMP          DONE
              
              

ROLR       BTST         #7,D1
           BEQ          ROLBW
           BTST         #6,D1
           BNE          data
           MOVE.L       #47,D0              ;ROL.L
           MOVE.L       #1,D1
           JMP          DONE
           
ROLBW      BTST         #6,D1
           BEQ          ROLB                ;ROL.W
           MOVE.L       #48,D0
           MOVE.L       #1,D1
           JMP          DONE
           
ROLB       MOVE.L       #49,D0
           MOVE.L       #1,D1              ;ROL.B
           JMP          DONE

AORL        BTST        #3,D1
            BEQ         ASRR
            BTST        #8,D1
            BEQ         LSRR
            BTST        #7,D1           ;LSL(Register shift)
            BEQ         LSLBW
            BTST        #6,D1
            BNE         data
            MOVE.L      #50,D0          ;LSL.L
            MOVE.L      #1,D1
            JMP         DONE
            
LSLBW       BTST        #6,D1
            BEQ         LSLB
            MOVE.L      #51,D0          ;LSL.W
            MOVE.L      #1,D1
            JMP         DONE
            
LSLB        MOVE.L      #52,D0
            MOVE.L      #1,D1           ;LSL.B
            JMP         DONE
            
LSRR        BTST        #7,D1
            BEQ         LSRBW
            BTST        #6,D1
            BNE         data
            MOVE.L      #53,D0          ;LSR.L
            MOVE.L      #1,D1
            JMP         DONE

LSRBW       BTST        #6,D1
            BEQ         LSRB
            MOVE.L      #54,D0          ;LSR,W
            MOVE.L      #1,D1
            JMP         DONE

LSRB        MOVE.L      #55,D0
            MOVE.L      #1,D1           ;LSR.B
            JMP         DONE
            
ASRR        BTST        #8,D1
            BNE         ASLR
            BTST        #7,D1
            BEQ         ASRBW
            BTST        #6,D1
            BNE         data
            MOVE.L      #56,D0              ;ASR.L
            MOVE.L      #1,D1
            JMP         DONE
            
ASRBW       BTST        #6,D1
            BEQ         ASRB
            MOVE.L      #57,D0              ;ASR.W
            MOVE.L      #1,D1
            JMP         DONE
            
ASRB       MOVE.L       #58,D0              ;ASR.B
           MOVE.L       #1,D1
           JMP          DONE
           
ASLR       BTST         #7,D1
           BEQ          ASLBW
           BTST         #6,D1
           BNE          data
           MOVE.L       #59,D0              ;ASL.L
           MOVE.L       #1,D1
           JMP          DONE
           
           
ASLBW       BTST       #6,D1
            BEQ         ASLB
            MOVE.L      #60,D0              ;ASL.W
            MOVE.L      #1,D1
            JMP         DONE
            
ASLB        MOVE.L      #61,D0
            MOVE.L      #1,D1               ;ASL.B
             JMP         DONE
           

        
code1111      BRA          data

data           MOVE.L      #0,D0
               MOVE.L      #0,D1
               JMP         DONE

DONE           STOP        #$2700
*------------Note:check if the ea is vaild, if it is not vaild then it is data
*------------DO STORES THE OUTPUT (state what kind of instrution it is)
*------------0-DATA
*------------1-MOVE.B
*------------2-MOVE.L
*------------3-MOVEA.L
*------------4-MOVE.W
*------------5-MOVEA.W
*------------6-RTS
*------------7-LEA
*------------8-NOT.L
*------------9-NOP
*------------10-NOT.W
*------------11-NOT.B
*------------12-JSR
*------------13-MOVEM.L
*------------14-MOVEM.W
*------------15-ADDQ.W
*------------16-ADDQ.L
*------------17-ADDQ.B
*------------18-MOVEQ
*------------19-OR.B
*------------20-OR.W
*------------21-OR.L
*------------22-SUB.B
*------------23-SUB.W
*------------24-SUB.L
*------------25-AND.B
*------------26-AND.W
*------------27-AND.L
*------------28-ADDA.L
*------------29-ADDA.W
*------------30-ADD.B
*------------31-ADD.L
*------------32-ADD.W
*------------33-BGT
*------------34-BLE
*------------35-BRA
*------------36-BEQ
*------------37-BCC
*------------38-ROL(memory shift)
*------------39-ROR(memory shift)
*------------40-LSL(memory shift)
*------------41-LSR(memory shift)
*------------42-ASR(memory shift)
*------------43-ASL(memory shift)
*------------44-ROR..L(Register shift)
*------------45-ROR.W
*------------46-ROR.B
*------------47-ROL.L
*------------48-ROL.W
*------------49-ROL.B
*------------50-LSL.L
*------------51-LSL.W
*------------52-LSL.B
*------------53-LSR.L
*------------54-LSR.W
*------------55-LSR.B
*------------56-ASR.L
*------------57-ASR.W
*------------58-ASR.B
*------------59-ASL.L
*------------60-ASL.W
*------------61-ASL.B

*------------D1 STATES DOES IT HAVE AT LEAST ONE EFFECTIVE ADDRESS
*------------0 = NO(NEED TO PRINT THE OPCODE AND MOVE A WORD)
*------------1 = YES
DATASTRING  DC.B    'DATA ',0
            

        END START





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
