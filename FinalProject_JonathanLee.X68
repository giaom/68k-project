*-----------------------------------------------------------
* Title      : Disassembler EA Jump Table
* Written by : Jonathan Lee
* Date       :
* Description: Perform EA Jump Table based on the input (000 to 111)
*-----------------------------------------------------------
            OPT     CRE                 
badFlag     EQU     0                   * Bad flag
goodFlag    EQU     1                   * Good flag
shift4      EQU     4                   * Shift 4 bits
shift8      EQU     8                   * Shift 8 bits 
shift12     EQU     12                  * Shift 12 bits
shift16     EQU     16                  * Shift 16 bits
CR          EQU     $0D                 * carriage return
LF          EQU     $0A                 * line feed    

    ORG    $1000
START:                  ; first instruction of program

* Put program code here

* EA Routine
getEA
            LEA         ea_mode_table,A5        * load EA_mode jump table
            CLR.L       D2
            CLR.L       D3
            CLR.L       D4           
            CLR.L       D6
            MOVE.W      D7,D6                   * move word into D6 for manipulation
            ANDI.W      #$003F,D6               * leave only the mode bits
            MOVE.B      #3,D1                   * Store number of bits we wish to shift            
            LSR.W       D1,D6                   * Shift to the Right to isolate mode bits            

            MULU        #6,D6                   * Form Offset for passing to Jump Index table            
            JSR         00(A5,D6)               * Now we have the index, back to Index table        

            RTS                                 * return from EA routine
        
            JMP         END                     * Return

***EA_mode jump table ***   
ea_mode_table                                   * table holds the different EA modes
            JMP         EAcode000               * CMP.B
            JMP         EAcode001               * CMP.W
            JMP         EAcode010               * CMP.L
            JMP         EAcode011               * CMPA.W
            JMP         EAcode100               * EOR.B
            JMP         EAcode101               * EOR.W
            JMP         EAcode110               * EOR.L
            JMP         EAcode111               * CMPA.L

*CMP.B
EAcode000
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$43, (A2)+             * C
            MOVE.B      #$4D, (A2)+             * M
            MOVE.B      #$50, (A2)+             * P
            
                
            
        RTS                                     * Return

*CMP.W
EAcode001
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$43, (A2)+             * C
            MOVE.B      #$4D, (A2)+             * M
            MOVE.B      #$50, (A2)+             * P

              
        RTS                                     * Return

*CMP.L
EAcode010
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$43, (A2)+             * C
            MOVE.B      #$4D, (A2)+             * M
            MOVE.B      #$50, (A2)+             * P


        RTS                                     * Return

*CMPA.W
EAcode011
            
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$43, (A2)+             * C
            MOVE.B      #$4D, (A2)+             * M
            MOVE.B      #$50, (A2)+             * P
            MOVE.B      #$41, (A2)+             * A


        RTS                                     * Return

*EOR.B
EAcode100
           
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$45, (A2)+             * E
            MOVE.B      #$4F, (A2)+             * O
            MOVE.B      #$52, (A2)+             * R
            
            
        RTS                                     * Return



*EOR.W
EAcode101
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$45, (A2)+             * E
            MOVE.B      #$4F, (A2)+             * O
            MOVE.B      #$52, (A2)+             * R



*EOR.L
EAcode110
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$45, (A2)+             * E
            MOVE.B      #$4F, (A2)+             * O
            MOVE.B      #$52, (A2)+             * R



*CMPA.L
EAcode111
            
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$43, (A2)+             * C
            MOVE.B      #$4D, (A2)+             * M
            MOVE.B      #$50, (A2)+             * P
            MOVE.B      #$41, (A2)+             * A

*regBits
regBits     MOVE.W  D7,D6     * change D2 to A0  (simulating address)
            ANDI.W  #$07,D6
            RTS

*Hex to ASCII Routine
Hex2ASCII   CMP.B   #$A,D6                      * Confirm hex character?
            BGE     letter                      * Is it a letter or number?
            ADDI.B  #$30,D6                     * Convert decimal to ASCII
            BRA     write2Buff                  * save to good buffer
letter      ADDI.B  #$37,D6
write2Buff  MOVE.B  D6,(A2)+
            RTS
                   

*Bad Instruction
getBadWord  MOVEQ   #$0,D6                      * clear out D6 to use for copying word
            MOVE.W  D7,D6                       * copy word instruction to D6
            MOVE.B  #shift12,D4                 * load shifter
            LSR.L   D4,D6                       * Shift D6
            ANDI.W  #$000F,D6                   * isolate last 4 bits
            JSR     Hex2ASCII                   * add 1st character to buffer
            MOVE.W  D7,D6
            MOVE.B  #shift8,D4
            LSR.L   D4,D6
            ANDI.W  #$000F,D6
            JSR     Hex2ASCII                   * add 2nd character to buffer
            MOVE.W  D7,D6
            MOVE.B  #shift4,D4
            LSR.L   D4,D6
            ANDI.W  #$000F,D6
            JSR     Hex2ASCII                   * add 3rd character to buffer
            MOVE.W  D7,D6
            ANDI.W  #$000F,D6
            JSR     Hex2ASCII                   * add 4th character to buffer
            RTS

    SIMHALT             ; halt simulator

* Put variables and constants here
END         STOP    #$2700
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
