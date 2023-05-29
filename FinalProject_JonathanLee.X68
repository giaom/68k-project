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
 LEA        ea_mode_table,A5 * load EA_mode jump table
            CLR.L   D2
            CLR.L   D3
            CLR.L   D4           
            CLR.L   D6
            MOVE.W  D7,D6                       * move word into D6 for manipulation
            ANDI.W  #$003F,D6                   * leave only the mode bits
            MOVE.B      #3,D1                   * Store number of bits we wish to shift            
            LSR.W       D1,D6                   * Shift to the Right to isolate mode bits            

            MULU      #6,D6                     * Form Offset for passing to Jump Index table            
            JSR         00(A5,D6)               * Now we have the index, back to Index table        

            RTS                                 * return from EA routine
        
            JMP         END                     * Return

***EA_mode jump table ***   
ea_mode_table                                   * table holds the different EA modes
            JMP     EAcode000                   * Direct Data Register
            JMP     EAcode001                   * Direct Address Register
            JMP     EAcode010                   * Indirect Address Register
            JMP     EAcode011                   * Indirect Address Register with Post Increment
            JMP     EAcode100                   * Indirect Address Register with Pre Decrement
            JMP     EAcode101                   * Indirect Address Register using Index
            JMP     EAcode110                   * 
            JMP     EAcode111                   * Absolute or Immediate EA

*Data Register Direct Dn
EAcode000
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$44,(A2)+              * add "D" to buffer
            ADD.B       #$30,D6                 * convert data register # to hex digit
            MOVE.B      D6,(A2)+                * register # to buffer                  
            
        RTS                                     * Return

*Address Register Direct An
EAcode001
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$41,(A2)+              * add "A" to buffer
            ADD.B       #$30,D6                 * convert data register # to hex digit
            MOVE.B      D6,(A2)+                * register # to buffer
              
        RTS                                     * Return

*Address Register Indirect (An)
EAcode010
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$28,(A2)+              * add "(" to buffer            
            MOVE.B      #$41,(A2)+              * add "A" to buffer
            ADD.B       #$30,D6                 * convert data register # to hex digit
            MOVE.B      D6,(A2)+                * register # to buffer
            MOVE.B      #$29,(A2)+              * add ")" to buffer
             
        RTS                                     * Return

*Address Register Indirect w/ Post-Increment (An)+
EAcode011
            
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$28,(A2)+              * add "(" to buffer            
            MOVE.B      #$41,(A2)+              * add "A" to buffer
            ADD.B       #$30,D6                 * convert data register # to hex digit
            MOVE.B      D6,(A2)+                * register # to buffer
            MOVE.B      #$29,(A2)+              * add ")" to buffer
            MOVE.B      #$2B,(A2)+              * add "+" to buffer
                 
        RTS                                     * Return

*Address Register Indirect w/ Pre-Decrement -(An)
EAcode100
           
            MOVE.W      D7,D6                   * move current working word into temp storage
            ANDI.W      #$7,D6                  * isolate register bits (last 3)
            MOVE.B      #$2D,(A2)+              * add "-" to buffer
            MOVE.B      #$28,(A2)+              * add "(" to buffer            
            MOVE.B      #$41,(A2)+              * add "A" to buffer
            ADD.B       #$30,D6                 * convert data register # to hex digit
            MOVE.B      D6,(A2)+                * register # to buffer
            MOVE.B      #$29,(A2)+              * add ")" to buffer
            
        RTS                                     * Return



*Address Register Indirect w/ Displacement
EAcode101
             JMP    badInst                     * set bad instruction flag


*Address Register w/ Index
EAcode110
            JMP       badInst                   * set bad instruction flag



*Absolute (.W | .L) | Immediate | PC w/ Index | PC w/ Displacement
EAcode111
            JSR      regBits                    * Get Register bits
            CMPI.B   #$0,D6                     * compare to determine if it's a word
            BEQ      word2Buffer                * put word address in buffer
            CMPI.B   #$1,D6                     * compare to determine if it's a long
            BEQ      long2Buffer                * put long address in buffer
            CMPI.B   #$2,D6

            CMPI.B   #$2,D6                     * compare to determine if it's PC w/ Displacement
            BEQ      PCwDisp             
            CMPI.B   #$4,D6                     * compare to determine if it's Immediate
            BEQ      imm2Buffer                            
            RTS



* EA SubRoutines   


*regBits
regBits     MOVE.W  D7,D6                       * change D2 to A0  (simulating address)
            ANDI.W  #$07,D6
            RTS
            
*imm2Buffer
imm2Buffer
            MOVE.B      #'#',(A2)+
            JSR         moveSize
            CMPI.B      #$1,D6                  * compare to determine if it's a word
            BEQ         byte2Buffer             * put word address in buffer
            CMPI.B      #$3,D6                  * compare to determine if it's a long
            BEQ         word2Buffer             * put long address in buffer.            
            CMPI.B      #$2,D6
            BEQ         long2Buffer
            RTS
            
*PCwDisp
PCwDisp
            JSR         word2Buffer
            MOVE.B      #$28,(A2)+              * add "(" to buffer            
            MOVE.B      #$50,(A2)+              * add "P" to buffer
            MOVE.B      #$43,(A2)+              * add "C" to buffer
            MOVE.B      #$29,(A2)+              * add ")" to buffer                        
            RTS
            
*byte2Buffer
byte2Buffer   
            MOVE.B  #'$',(A2)+
            CLR.L   D4                          * pre-emptive clearout
            MOVE.W  (A0),D2                     * move current word into D2 for rolling purposes
            CLR.L   D4                          * pre-emptive clearout
            MOVE.B  #2,D4                       * load a counter

b2bLoop                 
            CMP.B   #$00,D4                     * compare counter with 0
            BEQ     rtnEA0                      * if zero, return
            ROL.B   #4,D2                       * roll the bits in D2 to the left
            MOVE.W  D2,D6                       * move rolled bits into temp storage
            ANDI.W  #$000F,D6                   * and the bits to isolate ascii char   
            JSR     Hex2ASCII                   * load ascii char into buffer            
            SUBQ.B  #$1,D4                      * subtract from counter
            JMP     b2bLoop                     * keep looping until counter hits zero
            
rtnEA0      MOVE.W  D7,D6                       * re-load current word for temp storage            
            ADDQ.W  #2,A0                       * advancing memory pointer by word   
            RTS                                 * return from subroutine
            
*word2Buffer
word2Buffer 
            MOVE.B  #'$',(A2)+  
            CLR.L   D4                          * pre-emptive clearout
            MOVE.B  #$24,(A2)+                  * put dollar sign in buffer (before address)
            MOVE.W  (A0),D2                     * move current word into D2 for rolling purposes
            CLR.L   D4                          * pre-emptive clearout
            MOVE.B  #4,D4                       * load a counter

w2bLoop                 
            CMP.B   #$00,D4                     * compare counter with 0
            BEQ     rtnEA1                      * if zero, return
            ROL.W   #4,D2                       * roll the bits in D2 to the left
            MOVE.W  D2,D6                       * move rolled bits into temp storage
            ANDI.W  #$000F,D6                   * and the bits to isolate ascii char   
            JSR     Hex2ASCII                   * load ascii char into buffer            
            SUBQ.B  #$1,D4                      * subtract from counter
            JMP     w2bLoop                     * keep looping until counter hits zero
            
rtnEA1      MOVE.W  D7,D6                       * re-load current word for temp storage            
            ADDQ.W  #2,A0                       * advancing memory pointer by word   
            RTS                                 * return from subroutine

*long2Buffer
long2Buffer
            MOVE.B  #'$',(A2)+
            CLR.L   D4                          * pre-emptive clearout
            MOVE.L  (A0),D2                     * move current word into D2 for rolling purposes
            CLR.L   D4                          * pre-emptive clearout
            MOVE.B  #8,D4                       * load a counter

l2bLoop                 
            CMP.B   #$00,D4                     * compare counter with 0
            BEQ     rtnEA2                      * if zero, return
            ROL.L   #4,D2                       * roll the bits in D2 to the left
            MOVE.W  D2,D6                       * move rolled bits into temp storage
            ANDI.W  #$000F,D6                   * and the bits to isolate ascii char   
            JSR     Hex2ASCII                   * load ascii char into buffer            
            SUBQ.B  #$1,D4                      * subtract from counter
            JMP     l2bLoop                     * keep looping until counter hits zero
            
rtnEA2      MOVE.W  D7,D6                       * re-load current word for temp storage
            ADDQ.W  #4,A0                       * advancing memory pointer by long
            RTS                                 * return from subroutine

*Hex to ASCII Routine
Hex2ASCII   CMP.B   #$A,D6                      * Confirm hex character?
            BGE     letter                      * Is it a letter or number?
            ADDI.B  #$30,D6                     * Convert decimal to ASCII
            BRA     write2Buff                  * save to good buffer
letter      ADDI.B  #$37,D6
write2Buff  MOVE.B  D6,(A2)+
            RTS
            
badInst     MOVE.B  #badFlag,D5                 * set bad flag
            MOVEA.L A3,A2                       * reset the buffer pointer 
            MOVE.B  #'D',(A2)+                  * add bad syntax to goodBuff
            MOVE.B  #'A',(A2)+
            MOVE.B  #'T',(A2)+
            MOVE.B  #'A',(A2)+
            MOVE.B  #$09,(A2)+
            MOVE.B  #'$',(A2)+                  * add in shift/pad
            JSR     getBadWord                  * add the bad word to the buffer
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
            
moveSize    MOVE.W  D7,D6                       * get fresh copy to determine MOVE size
            LSR.W   #shift8,D6                  * shift move size bits 12-13 to LSB
            LSR.W   #shift4,D6          
            ANDI.W  #$0003,D6                   * Isolate move bits
            CMP.B   #$1,D6                      * is this a byte?
            BEQ     mSizeEnd                    * yes - byte size already in bits 6-7 of D3
            CMP.B   #$2,D6                      * is this a L?
            BEQ     moveSizeL                   * yes - Or L size to D3 bits 6-7
            CMP.B   #$3,D6                      * is this a W?
            BNE     badInst                     * No- then badInst        
moveSizeW   ORI.W   #$0040,D3                   * add size 01 in bits 6-7 (4) into D3
            JMP     mSizeEnd                    * skip to end once done
moveSizeL   ORI.W   #$0080,D3                   * add size 10 in bits 6-7 (4) into D3
mSizeEnd    RTS 

    SIMHALT             ; halt simulator

* Put variables and constants here
END         STOP    #$2700
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
