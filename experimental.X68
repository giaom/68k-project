*-----------------------------------------------------------
* Title      : Dissambler store addresses function
* Written by : Aisha M
* Description:  function to store input from user 
* Store starting address at A5, and ending adress at 

*-----------------------------------------------------------


TEST_SUB:
            ; NOP
            DC  $4E71

            ; RTS
            DC  $4E75
            
            ; ROR commands
            DC  $E01D
            DC  $E61D
            DC  $E63D
            DC  $E69D
            DC  $E6BD
            DC  $E6C5
            DC  $E6D5
            DC  $E6DD
            DC  $E6E5
            DC  $E6F8
            DC  $1234
            DC  $E6F9
            DC  $1234
            DC  $5678
            
            ; ROL commands
            DC  $E11D
            DC  $E71D
            DC  $E73D
            DC  $E79D
            DC  $E7BD
            DC  $E7C5
            DC  $E7D5
            DC  $E7E5
            DC  $E7F8
            DC  $1234
            DC  $E7F9
            DC  $1234
            DC  $5678
            
            ; AND commands
            DC  $C847
            ;DC  $C84F
            DC  $C857
            DC  $C85F
            DC  $C867
            DC  $C878
            DC  $1234
            DC  $C879
            DC  $1234
            DC  $5678
            DC  $C907
            DC  $C997
            DC  $C99F
            DC  $C9A7
            DC  $C9B8
            DC  $1234
            DC  $C9B9
            DC  $1234
            DC  $5678

            ; OR commands
            DC  $8807
            ;DC  $880F
            DC  $8817
            DC  $881F
            DC  $8827
            DC  $8838
            DC  $1234
            DC  $8839
            DC  $1234
            DC  $5678
            DC  $8947
            DC  $8957
            DC  $895F
            DC  $8967
            DC  $8978
            DC  $1234
            DC  $8979
            DC  $1234
            DC  $5678
            DC  $8987

            ; ADDQ commands
            DC  $5A04
            DC  $5A1C
            DC  $5A44
            DC  $5A4C
            DC  $5A5C
            DC  $5A84
            DC  $5A8C
            DC  $5A9C

            ; ADDA commands
            DC  $D6C4
            DC  $D6CC
            DC  $D6D4
            DC  $D6DC
            DC  $D6E4
            DC  $D6F8
            DC  $1234
            DC  $D6F9
            DC  $1234
            DC  $5678
            DC  $D7C4
            DC  $D7CC
            DC  $D7F8
            DC  $1234
            DC  $D7F9
            DC  $1234
            DC  $5678
            
            ; ADD commands
            DC  $D604
            DC  $D60C
            DC  $D614
            DC  $D61C
            DC  $D624
            ;DC  $942D
            ;DC  $1234
            ;DC  $9435
            ;DC  $1234
            DC  $D638
            DC  $1234
            DC  $D639
            DC  $1234
            DC  $5678
            ;DC  $D63C
            DC  $D684
            DC  $D794
            DC  $D79C
            DC  $D724
            DC  $D738
            DC  $1234
            DC  $D739
            DC  $1234
            DC  $5678

            ; SUB commands
            DC  $9405
            DC  $940D
            DC  $9415
            DC  $941D
            DC  $9425
            ;DC  $942D
            ;DC  $1234
            ;DC  $9435
            ;DC  $1234
            DC  $9438
            DC  $1234
            DC  $9439
            DC  $1234
            DC  $5678
            ;DC  $943C
            ;DC  $1234
            ;DC  $943A
            ;DC  $1234
            ;DC  $943B
            ;DC  $1200
            DC  $9485
            ;DC  $9545 - illegal instruction
            ;DC  $944D - illegal instruction
            DC  $9555
            DC  $955D
            DC  $9565
            DC  $9578
            DC  $1234
            DC  $9579
            DC  $1234
            DC  $5678
            
      
START:  ORG     $1000 
    MOVE    #0,D5       * Used to track print lines per page

; Code
    BRA STARTADDR

;========================[Request user INPUT]===========================
ENDADDR:    
    ;prompt user
    MOVE    #1,D6       ; keeps track if storing start/end
    LEA     prompt2,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     FORMAT

STARTADDR:
    ;prompt user
    LEA     prompt1,A1
    MOVE.B  #14,D0
    TRAP    #15

FORMAT:    
    ;let user know format
    LEA     examp,A1
    MOVE.B  #14,D0
    TRAP    #15
   
    MOVE.L  #0, D2        ; Initialize subtotal   
    MOVE.L  #7, D3        ; Number of digits
    ; DBRA stops when it becomes -1, so made 8 to 7 to fix
        
LOOP1:
    ;shfit num
    ASL.L   #4,D2
    
    ; read input
    MOVE.B  #5, D0
    TRAP    #15
    
    ; Convert ASCII char to num (-'0')
    CMP.B   #58,D1  ; if greater than 0, then it's A-F
    BLT     ISDIGIT
    SUB.B   #7,D1   ; subtract 'A' - '9'
    
ISDIGIT:
    SUB.B   #48,D1      ; 0 - 9
    
    ADD.B   D1,D2       ; Temp to subtotal     
    DBRA    D3,LOOP1    ; Repeat until end of memory block
        
INPUT_DONE:
    CMP     #1,D6
    BEQ     INPUT_DONE2      ;check if storing start/end
    MOVE.L  D2,A5            ;store starting add at A5
INPUT_DONE2:
    MOVE.L  D2,A6            ;store ending add at A6    
    CMP     #1,D6
    BNE     ENDADDR          ;check if we did end yet


DECODE_LOOP:    
    JSR     DECODE
    
    JSR     OUTPUT
    MOVE.W  (A5)+,D0
    
; After every 10 prints, prompt user to press a key to continue printing
    ADD.B   #1,D5   * D5 used to track prints
    CMP     #10,D5
    BLT     CHECK_END
    
    ; Prompt for [Enter]
    MOVE.B  #0,D5
    LEA     continuation_prompt,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    ; Read single char from keyboard
    MOVE.B  #5,D0
    TRAP    #15
    
CHECK_END
    CMPA.W  A6,A5
    BLE     DECODE_LOOP    
    
; Ask user if loop again:
    LEA     repeat,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    ; Read user's response
    MOVE.B  #5, D0
    TRAP    #15
    
    ; Check user's response
    MOVE    #0,D6     ; Reset ending adress to not set
    CMP.B   #89, D1   ; 'Y' - ASCII value 89
    BEQ     START     ; Branch if equal (user wants to loop)
    
    Simhalt 

    
;=======[TRANSLATE: op-code to operation name and data size]===========
*-----------------------------------------------------------
* Title      : Reverse Assmebler
* Written by : Lok Yin Wong
* Date       : 5/11/2023
* Description:
*-----------------------------------------------------------
stack            EQU      $A000
example          EQU      $E7F8   *made up bits       
shift            EQU      12      *Shift 12 bits 

DECODE:
*------------Use A0, d1,d0,d2,A2,A1
               LEA     jmp_table,A0    *Index into the table
               CLR.L   D0              *Zero it
               ;MOVE.W  #example,D0    *We'll play with it here
               MOVE.W  (A5),D0
               MOVE.B  #shift,D1       *Shift 12 bits to the right  
               LSR.W   D1,D0           *Move the bits
               ;MOVE.L   #example,D1   
               MOVE.W  (A5),D1         *Store that full 16 bits at d1 
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
               BTST        #6,D1
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
               
BGTBLE           BTST        #10,D1
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
               MOVE.L      #1,D1    ;OR.B
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
               MOVE.L      #1,D1    ;SUB.B
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

DONE           RTS        ;STOP        #$2700
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
*------------0 = NO (NEED TO PRINT THE OPCODE AND MOVE A WORD)
*------------1 = YES


;=======[TRANSLATE: Source & destination operand in op-code]===========
; Use first 16-bits to see intruction type. For handling larger instruction types.

;============[OUTPUT: memory location, op-code, operand]===============
OUTPUT:
; Need to use D0 and D2, so move variables
    MOVE.B  D0, D7 * Store op code key
    MOVE.B  D1, D6 * Store bool, does opcode have atleast 1 EA?
    
    ; we use D4 to signal ADDA changes or type of addressing we're doing
    MOVE.L  #0,D4   ; signal that we are doing Dn - <ea> -> Dn case by default

PRINT_MEM_LOC:
; print newline
    LEA     newline, A1
    MOVE.B  #14,D0
    TRAP    #15
    TRAP    #15

    MOVE.W  A5,D1
    MOVE.B  #16,D2
    MOVE.B  #15,D0
    TRAP    #15 

CMPR_OP_KEY:
    CMP.B   #1, D7 
    BEQ     load_mssg_MOVEB
    CMP.B   #2, D7 
    BEQ     load_mssg_MOVEL
    CMP.B   #4, D7 
    BEQ     load_mssg_MOVEW
    
    CMP.B   #3, D7 
    BEQ     load_mssg_MOVEAL
    CMP.B   #5, D7 
    BEQ     load_mssg_MOVEAW
    
    CMP.B   #6, D7 
    BEQ     load_mssg_RTS
    CMP.B   #7, D7 
    BEQ     load_mssg_LEA
    
    CMP.B   #8, D7 
    BEQ     load_mssg_NOTL
    CMP.B   #9, D7 
    BEQ     load_mssg_NOP
    CMP.B   #10, D7 
    BEQ     load_mssg_NOTW
    CMP.B   #11, D7 
    BEQ     load_mssg_NOTB
    
    CMP.B   #12, D7 
    BEQ     load_mssg_JSR
    
    CMP.B   #13, D7
    BEQ     load_mssg_MOVEML
    CMP.B   #14, D7
    BEQ     load_mssg_MOVEMW
    
    CMP.B   #15, D7
    BEQ     load_mssg_ADDQW
    CMP.B   #16, D7
    BEQ     load_mssg_ADDQL
    CMP.B   #17, D7 
    BEQ     load_mssg_ADDQB
    CMP.B   #18, D7 
    
    BEQ     load_mssg_MOVEQ
    CMP.B   #19, D7 
    
    BEQ     load_mssg_ORB
    CMP.B   #20, D7 
    BEQ     load_mssg_ORW
    CMP.B   #21, D7 
    BEQ     load_mssg_ORL
    
    CMP.B   #22, D7 
    BEQ     load_mssg_SUBB
    CMP.B   #23, D7 
    BEQ     load_mssg_SUBW
    CMP.B   #24, D7 
    BEQ     load_mssg_SUBL
    
    CMP.B   #25, D7 
    BEQ     load_mssg_ANDB
    CMP.B   #26, D7 
    BEQ     load_mssg_ANDW
    CMP.B   #27, D7 
    BEQ     load_mssg_ANDL
    
    CMP.B   #28, D7 
    BEQ     load_mssg_ADDAL
    CMP.B   #29, D7 
    BEQ     load_mssg_ADDAW
    
    CMP.B   #30, D7 
    BEQ     load_mssg_ADDB
    CMP.B   #31, D7 
    BEQ     load_mssg_ADDW
    CMP.B   #32, D7 
    BEQ     load_mssg_ADDL
    
    CMP.B   #33, D7
    BEQ     load_mssg_BGT
    CMP.B   #34, D7 
    BEQ     load_mssg_BLE
    CMP.B   #35, D7 
    BEQ     load_mssg_BRA
    CMP.B   #36, D7 
    BEQ     load_mssg_BEQ
    CMP.B   #37, D7 
    BEQ     load_mssg_BCC
    
    CMP.B   #38, D7 
    BEQ     load_mssg_ROL
    CMP.B   #39, D7 
    BEQ     load_mssg_ROR
    CMP.B   #40, D7 
    BEQ     load_mssg_LSL
    CMP.B   #41, D7 
    BEQ     load_mssg_LSR
    CMP.B   #42, D7 
    BEQ     load_mssg_ASR
    CMP.B   #43, D7 
    BEQ     load_mssg_ASL
    
    CMP.B   #44, D7
    BEQ     load_mssg_RORL
    CMP.B   #45, D7 
    BEQ     load_mssg_RORW
    CMP.B   #46, D7 
    BEQ     load_mssg_RORB
    
    CMP.B   #47, D7
    BEQ     load_mssg_ROLL
    CMP.B   #48, D7 
    BEQ     load_mssg_ROLW
    CMP.B   #49, D7 
    BEQ     load_mssg_ROLB
    
    CMP.B   #50, D7 
    BEQ     load_mssg_LSLL
    CMP.B   #51, D7 
    BEQ     load_mssg_LSLW
    CMP.B   #52, D7 
    BEQ     load_mssg_LSLB
    
    CMP.B   #53, D7 
    BEQ     load_mssg_LSRL
    CMP.B   #54, D7 
    BEQ     load_mssg_LSRW
    CMP.B   #55, D7 
    BEQ     load_mssg_LSRB
    
    CMP.B   #56, D7 
    BEQ     load_mssg_ASRL
    CMP.B   #57, D7 
    BEQ     load_mssg_ASRW
    CMP.B   #58, D7 
    BEQ     load_mssg_ASRB
   
    CMP.B   #59, D7
    BEQ     load_mssg_ASLL
    CMP.B   #60, D7 
    BEQ     load_mssg_ASLW
    CMP.B   #61, D7 
    BEQ     load_mssg_ASLB

*-----[Load Mssg Start]-----     
load_mssg_MOVEB
     LEA     mssg1, A1
     JMP     PRINT_OPCODE
    
load_mssg_MOVEL
     LEA     mssg1, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEW
     LEA     mssg3, A1
     JMP     PRINT_OPCODE
      
load_mssg_MOVEAL
     LEA     mssg4, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEAW
     LEA     mssg5, A1
     JMP     PRINT_OPCODE
     
load_mssg_RTS
     LEA     mssg6, A1
     JMP     PRINT_OPCODE
     
load_mssg_LEA
     LEA     mssg6, A1
     JMP     PRINT_OPCODE
     
load_mssg_NOTL
     LEA     mssg8, A1
     JMP     PRINT_OPCODE
     
load_mssg_NOP
     LEA     mssg9, A1
     JMP     PRINT_OPCODE
     
load_mssg_NOTW
     LEA     mssg10, A1
     JMP     PRINT_OPCODE
     
load_mssg_NOTB
     LEA     mssg11, A1
     JMP     PRINT_OPCODE
     
load_mssg_JSR
     LEA     mssg12, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEML
     LEA     mssg13, A1
     JMP     PRINT_OPCODE
     
load_mssg_MOVEMW
     LEA     mssg14, A1
     JMP     PRINT_OPCODE
     
load_mssg_ADDQW
     LEA     mssg15, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     ADDQ_ADDRESSING
     
load_mssg_ADDQL
     LEA     mssg16, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     ADDQ_ADDRESSING
     
load_mssg_ADDQB
     LEA     mssg17, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     ADDQ_ADDRESSING
     
load_mssg_MOVEQ
     LEA     mssg18, A1
     JMP     PRINT_OPCODE
     
load_mssg_ORB
     LEA     mssg19, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_ORW
     LEA     mssg20, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_ORL
     LEA     mssg21, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_SUBB
     LEA     mssg22, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
    
     
load_mssg_SUBW
     LEA     mssg23, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_SUBL
     LEA     mssg24, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_ANDB
     LEA     mssg25, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_ANDW
     LEA     mssg26, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_ANDL
     LEA     mssg27, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_ADDAL
     LEA     mssg28, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     
     MOVE.L  #2,D4   ; signal that we are doing ADDA not ADD
     JMP     SUB_ADDRESSING
     
load_mssg_ADDAW
     LEA     mssg29, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     
     MOVE.L  #2,D4   ; signal that we are doing ADDA not ADD
     JMP     SUB_ADDRESSING
     
load_mssg_ADDB
     LEA     mssg30, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_ADDW
     LEA     mssg31, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_ADDL
     LEA     mssg31b, A1
     MOVE.B  #14,D0      
     TRAP    #15         * Displays Message
     JMP     SUB_ADDRESSING
     
load_mssg_BGT
     LEA     mssg32, A1
     JMP     PRINT_OPCODE
     
load_mssg_BLE
     LEA     mssg33, A1
     JMP     PRINT_OPCODE
     
load_mssg_BRA
     LEA     mssg34, A1
     JMP     PRINT_OPCODE
     JMP     PRINT_OPCODE
     
load_mssg_BEQ
        LEA     mssg35, A1
        JMP     PRINT_OPCODE
     
load_mssg_BCC
        LEA     mssg36, A1
        JMP     PRINT_OPCODE
     
load_mssg_ROL
        LEA     mssg37, A1
        MOVE.B  #14,D0      
        TRAP    #15         * Displays Message
        
        JMP     ROR_HANDLING
     
load_mssg_ROR
        LEA     mssg38, A1
        MOVE.B  #14,D0      
        TRAP    #15         * Displays Message
        
ROR_HANDLING:
        MOVE.B  #$9,D1  ; print tab after opcode
        MOVE.B  #6,D0
        TRAP    #15
        
        MOVE.L  #1,D4
        BRA EA_REG
     
load_mssg_LSL
        LEA     mssg39, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSR
        LEA     mssg40, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASR
        LEA     mssg41, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASL
        LEA     mssg42, A1
        JMP     PRINT_OPCODE
     
load_mssg_RORL
        LEA     mssg43, A1
        MOVE.B  #14,D0      
        TRAP    #15         * Displays Message
        JMP ROc_COMMON
     
load_mssg_RORW
        LEA     mssg44, A1
        MOVE.B  #14,D0      
        TRAP    #15         * Displays Message
        JMP ROc_COMMON
     
load_mssg_RORB
        LEA     mssg45, A1
        MOVE.B  #14,D0      
        TRAP    #15         * Displays Message
        JMP ROc_COMMON
     
load_mssg_ROLL
        LEA     mssg46, A1
        MOVE.B  #14,D0      
        TRAP    #15         * Displays Message
        JMP ROc_COMMON
     
load_mssg_ROLW
        LEA     mssg47, A1
        MOVE.B  #14,D0      
        TRAP    #15         * Displays Message
        JMP ROc_COMMON
     
load_mssg_ROLB
        LEA     mssg48, A1
        MOVE.B  #14,D0      
        TRAP    #15         * Displays Message

ROc_COMMON:
        MOVE.B  #$9,D1  ; print tab after opcode
        MOVE.B  #6,D0
        TRAP    #15
    
        ; move i/r to D2
        MOVE.W  (A5), D2
        LSR.W   #5,D2
        AND.W   #$1,D2
     
        CMP     #0,D2
        BEQ     IMMEDIATE_NUM

        JSR     PRINT_DREG
        JMP     AFTER_I_NUM
        
IMMEDIATE_NUM:

        LEA     premssg_tag, A1
        MOVE.B  #14,D0
        TRAP    #15
        
        ; can't call PRINT_DREG as we have to convert 0 to 8
        MOVE.L  #0,D1
        MOVE.W  (A5), D1
        LSR.W   #8, D1
        LSR.W   #1, D1
        AND.W   #7, D1
        CMP     #0, D1
        BNE     I_NUM_NOT_ZERO
        
        MOVE.B  #8, D1  ; if immediate num is 0, it implies 8
        
I_NUM_NOT_ZERO:
        MOVE.B  #3, D0
        TRAP    #15
        
        
AFTER_I_NUM
        LEA     comma, A1
        MOVE.B  #14,D0
        TRAP    #15
    
        MOVE.B  #$44,D1 ; print D
        MOVE.B  #6,D0
        TRAP    #15
        JSR     PRINT_EA  

        JMP     DONE_LOAD
     
load_mssg_LSLL
        LEA     mssg49, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSLW
        LEA     mssg50, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSLB
        LEA     mssg51, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSRL
        LEA     mssg52, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSRW
        LEA     mssg53, A1
        JMP     PRINT_OPCODE
     
load_mssg_LSRB
        LEA     mssg54, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASRL
        LEA     mssg55, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASRW
        LEA     mssg56, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASRB
        LEA     mssg57, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASLL
        LEA     mssg58, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASLW
        LEA     mssg59, A1
        JMP     PRINT_OPCODE
     
load_mssg_ASLB
        LEA     mssg60, A1
        JMP     PRINT_OPCODE

*-----[Load Mssg End]-----     

PRINT_OPCODE 
    MOVE.B  #14,D0      
    TRAP    #15         * Displays Message
    
    JMP     DONE_LOAD
    
ADDQ_ADDRESSING:
    MOVE.B  #$9,D1  ; print tab after opcode
    MOVE.B  #6,D0
    TRAP    #15

    LEA     premssg_tag, A1
    MOVE.B  #14,D0
    TRAP    #15

    ; move data into D1
    MOVE.W  (A5), D1
    LSR.W   #8,D1
    LSR.W   #1,D1
    AND.W  #$7, D1
    
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA     comma, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.L  #1,D4
    BRA EA_REG
    
    ; BRA DONE_LOAD

    
SUB_ADDRESSING:

    MOVE.B  #$9,D1  ; print tab after opcode
    MOVE.B  #6,D0
    TRAP    #15


    ; move opmode into D2
    MOVE.W  (A5), D2
    LSR.W   #6,D2
    AND.W  #$7, D2
    
    
    CMP.B   #2,D4
    BEQ     EA_REG
    
    ; remember that D4 is 0 by default: signal that we are doing Dn - <ea> -> Dn case
    CMP.B   #4,D2
    BLT     EA_REG
    
    ; if we are here we do: <ea> - Dn -> <ea>
    MOVE.L  #1,D4   ; signal that we are doing <ea> - Dn -> <ea> case
    JSR     PRINT_DREG

    LEA     comma, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    ;BRA DONE_LOAD
    
EA_REG:
    ; move mode into D3
    MOVE.W  (A5), D3
    LSR.W   #3,D3
    AND.W  #$7, D3
    
    CMP.B   #0, D3
    BEQ     PRINT_Dn
    
    CMP     #1, D3
    BEQ     PRINT_An
    
    CMP     #2, D3
    BEQ     PRINT_RAn
    
    CMP     #3, D3
    BEQ     PRINT_RAnI
    
    CMP     #4, D3
    BEQ     PRINT_RAnD
    
    CMP     #7, D3
    BEQ     PRINT_Rxxx
    
    BRA     DONE_LOAD

PRINT_Dn:
    MOVE.B  #$44,D1 ; print D
    MOVE.B  #6,D0
    TRAP    #15

    JSR     PRINT_EA
    
    CMP     #1,D4       ; we're done if in <ea> - Dn -> <ea> mode
    BEQ     DONE_LOAD
    
    LEA     comma, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     PRINT_DREG
    
    BRA     DONE_LOAD
    
PRINT_An:
    MOVE.B  #$41,D1 ; print A
    MOVE.B  #6,D0
    TRAP    #15

    JSR     PRINT_EA
    
    CMP     #1,D4       ; we're done if in <ea> - Dn -> <ea> mode
    BEQ     DONE_LOAD
    
    LEA     comma, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     PRINT_DREG
    BRA     DONE_LOAD

PRINT_RAn:
    LEA     premssg_pA, A1
    MOVE.B  #14,D0
    TRAP    #15

    JSR     PRINT_EA
    
    LEA     postmssg_p, A1
    MOVE.B  #14,D0
    TRAP    #15

    CMP     #1,D4       ; we're done if in <ea> - Dn -> <ea> mode
    BEQ     DONE_LOAD
    
    LEA     comma, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     PRINT_DREG
    BRA     DONE_LOAD
    
PRINT_RAnI:
    LEA     premssg_pA, A1
    MOVE.B  #14,D0
    TRAP    #15

    JSR     PRINT_EA
    
    LEA     postmssg_p_plus, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    CMP     #1,D4       ; we're done if in <ea> - Dn -> <ea> mode
    BEQ     DONE_LOAD
    
    LEA     comma, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     PRINT_DREG
    BRA     DONE_LOAD

PRINT_RAnD:
    LEA     premssg_minus_pA, A1
    MOVE.B  #14,D0
    TRAP    #15

    JSR     PRINT_EA
    
    LEA     postmssg_p, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    CMP     #1,D4       ; we're done if in <ea> - Dn -> <ea> mode
    BEQ     DONE_LOAD
    
    LEA     comma, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     PRINT_DREG
    BRA     DONE_LOAD

PRINT_Rxxx:
    LEA     premssg_hex, A1
    MOVE.B  #14,D0
    TRAP    #15

    MOVE.W  (A5), D2
    AND.W   #7, D2
    MOVE.L  A5, A4
    ADD     #2, A4
    
    CMP.B   #0, D2
    BEQ     WORD_XXX
    
    MOVE.L  #4, D3
    LEA     postmssg_L, A3
    MOVE.W  (A5), D2
    MOVE.L (A4), D1
    BRA POST_WORD_XXX
    
WORD_XXX:
    MOVE.L  #2, D3
   LEA     postmssg_W, A3
    MOVE.W  (A4), D1
    
POST_WORD_XXX:    
    MOVE.B  #15, D0
    MOVE.B  #16, D2
    TRAP    #15
    
    MOVE.L   A3, A1
    MOVE.B  #14,D0
    TRAP    #15

    CMP     #1,D4       ; we're done if in <ea> - Dn -> <ea> mode
    BEQ     POST_WORD_DONE
    
    LEA     comma, A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     PRINT_DREG
POST_WORD_DONE:
    ADD     D3, A5
    BRA     DONE_LOAD

PRINT_EA:
    MOVE.W  (A5), D1
    AND.W   #7, D1
    MOVE.B  #3, D0
    TRAP    #15
    RTS

PRINT_DREG:
    ; hack alert, if D4 is 2 then we are doing ADDA, so we print A instead
    CMP.B   #2,D4
    BNE     PRINT_D
    
    MOVE.B  #$41,D1 ; print A
    MOVE.B  #6,D0
    TRAP    #15
    JMP     PRINT_REG

PRINT_D:
    MOVE.B  #$44,D1 ; print D
    MOVE.B  #6,D0
    TRAP    #15
PRINT_REG:
    MOVE.L  #0,D1
    MOVE.W  (A5), D1
    LSR.W   #8, D1
    LSR.W   #1, D1
    AND.W   #7, D1
    MOVE.B  #3, D0
    TRAP    #15
    RTS


DONE_LOAD ; place-holder
    
PRINT_OPERAND
; to-do

; print newline
    LEA     newline, A1
    MOVE.B  #14,D0
    TRAP    #15

    RTS
    
;=======================[OUTER LOOP condition]==========================
    
   
    SIMHALT           

; Output   
CR       EQU     $0D
LF       EQU     $0A
HT       EQU     $09


prompt1  DC.B CR,LF,'Enter starting adress in hexadecimal: ',CR,LF,0
prompt2  DC.B CR,LF,'Enter ending adress in hexadecimal: ',CR,LF,0
examp    DC.B 'Input should be 8 digits. Put leading 0s on left if needed. ',CR,LF,0
repeat   DC.B CR,LF,'Do you want to loop again? (Y/N): ',CR,LF,0
continuation_prompt DC.B    CR,LF,'Press any key to continue...',CR,LF,0

DATASTRING  DC.B    'DATA ',0

; pre
premssg_hex          DC.B  '$',0
premssg_tag          DC.B  '#',0
premssg_A            DC.B  'A',0
premssg_D            DC.B  'D',0
premssg_p            DC.B  '(',0
premssg_pA           DC.B  '(A',0
premssg_minus_pA     DC.B  '-(A',0

; post
postmssg_astr        DC.B  '*',CR,LF,0
postmssg_p_plus      DC.B  ')+',0
postmssg_p           DC.B  ')',0
postmssg_p_B         DC.B  ').B',0
postmssg_p_W         DC.B  ').W',0
postmssg_p_L         DC.B  ').L',0

postmssg_W           DC.B  '.W',0
postmssg_L           DC.B  '.L',0

comma                DC.B  ',',0
newline              DC.B  '',CR,LF,0

mssg1 DC.B    '     MOVE.B',0
mssg2 DC.B    '     MOVE.L',0
mssg3 DC.B    '     MOVE.W',0
mssg4 DC.B    '     MOVEA.L',0
mssg5 DC.B    '     MOVEA.w',0
mssg6 DC.B    '     RTS',0
mssg7 DC.B    '     LEA',0
mssg8 DC.B    '     NOT.L',0
mssg9 DC.B    '     NOP',0
mssg10 DC.B   '     NOT.W',0
mssg11 DC.B   '     NOT.B',0
mssg12 DC.B   '     JSR',0
mssg13 DC.B   '     MOVEM.L',0
mssg14 DC.B   '     MOVEM.W',0
mssg15 DC.B   '     ADDQ.W',0
mssg16 DC.B   '     ADDQ.L',0
mssg17 DC.B   '     ADDQ.B',0
mssg18 DC.B   '     MOVE.Q',0
mssg19 DC.B   '     OR.B',0
mssg20 DC.B   '     OR.W',0
mssg21 DC.B   '     OR.L',0
mssg22 DC.B   '     SUB.B',0
mssg23 DC.B   '     SUB.W',0
mssg24 DC.B   '     SUB.L',0
mssg25 DC.B   '     AND.B',0
mssg26 DC.B   '     AND.W',0
mssg27 DC.B   '     AND.L',0
mssg28 DC.B   '     ADDA.L',0
mssg29 DC.B   '     ADDA.W',0
mssg30 DC.B   '     ADD.B',0
mssg31 DC.B   '     ADD.W',0
mssg31b DC.B   '     ADD.L',0
mssg32 DC.B   '     BGT',0
mssg33 DC.B   '     BLE',0
mssg34 DC.B   '     BRA',0
mssg35  DC.B  '     BEQ',0
mssg36  DC.B  '     BCC',0
mssg37  DC.B  '     ROL',0
mssg38  DC.B  '     ROR',0
mssg39  DC.B  '     LSL',0
mssg40  DC.B  '     LSR',0
mssg41  DC.B  '     ASR',0
mssg42  DC.B  '     ASL',0
mssg43  DC.B  '     ROR.L',0
mssg44  DC.B  '     ROR.W',0
mssg45  DC.B  '     ROR.B',0
mssg46  DC.B  '     ROL.L',0
mssg47  DC.B  '     ROL.W',0
mssg48  DC.B  '     ROL.B',0
mssg49  DC.B  '     LSL.L',0
mssg50  DC.B  '     LSL.W',0
mssg51  DC.B  '     LSL.B',0
mssg52  DC.B  '     LSR.L',0
mssg53  DC.B  '     LSR.W',0
mssg54  DC.B  '     LSR.B',0
mssg55  DC.B  '     ASR.L',0
mssg56  DC.B  '     ASR.W',0
mssg57  DC.B  '     ASR.B',0
mssg58  DC.B  '     ASL.L',0
mssg59  DC.B  '     ASL.W',0
mssg60  DC.B  '     ASL.B',0

    END    START        

