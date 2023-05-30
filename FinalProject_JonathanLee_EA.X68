*-----------------------------------------------------------
* Title      : EA
* Written by : Jonathan Lee
* Date       : 5/30/2023
*------------------------------------------------------------
* MESSAGE VARIABLES ******************************

* ASCII values for respective characters
ADDRESS         DC.B    $41
DATA            DC.B    $44

PTHSIS_OPEN     DC.B    $28
PTHSIS_CLSD     DC.B    $29
HEX_SIGN        DC.B    $24
IMMDTE_VALU     DC.B    $23
PLUS_SIGN       DC.B    $2B
MINUS_SIGN      DC.B    $2D

COMMA           DC.B    $2C
SPACE           DC.B    $20

* EA Specific variables
TRAILING_SIZE   DS.W    1 									;Size of any immediate or
															;address values. Immediate or address
															;value of a BYTE is still processed as
															;WORD because the trailing bytes
															;are represented as a word regardless.
															;$1 = BYTE, $2 = WORD, $4 = LONG
															
MOVEM_FIRST_VAR				DS.B	1						;MOVEM constant
MOVEM_SECOND_VAR			DS.B	1 						;Always MOVEM_FIRST_VAR-> MOVEM_SECOND_VAR
MOVEM_FIRST_VAR_COUNTER		DS.B	1						;MOVEM counter constant
MOVEM_SECOND_VAR_COUNTER	DS.B	1						;MOVEM counter constant
FIRST_VAR_MOVEM				DS.B	1 						;Refers to the first X var assuming Dx1-Dx2/Ay1-Ay2
															;Refers to the second X var assuming Dx1-Dx2/Ay1-Ay2
SECOND_VAR_MOVEM			DS.B	1 						;Refers to the first Y var assuming Dx1-Dx2/Ay1-Ay2
															;Refers to the second Y var assuming Dx1-Dx2/Ay1-Ay2



* EA Execution:
* G_BUFFER should be loaded in A4
* READING FROM START_ADDRESS should be loaded in A5
* ALL variables should have the same name with OP code person.
* CUR_OP_CODE, MNEMONIC, FIRST_3, SECOND_3, THIRD_3, and FOURTH_3.
* Some routine names may seem jarring at first. Please read the 
* associated description in the routine for better understanding.

main_EA:
    JSR PARSE_EA_CONSTANT_BITS 								;Parses and initializes all EA necessary values   


* EXECUTION 
    JSR     CHECK_XXXX
EXT                        									;End point for EA address
    JMP check_print 										;Jumps to IO's main printing method after finishing


*** CHECK_MNEMONIC FUNCTIONS

* <EA>
* Checks the MNEMONIC starting from XXXX
*
* Precondition: MNEMONIC has been loaded
*
* Postcondition: Verified value for MNEMONIC
CHECK_XXXX:
    CMPI.B  #$8, MNEMONIC									;Check if MNEMONIC is $8
    BLT     CHECK_0XXX										;If so it's in the 0XXX group
    JMP     CHECK_1XXX										;If not it's in 1XXX
    
* <EA>
* Description: Checks the MNEMONIC starting from 0XXX
*
* Precondition: MNEMONIC has been loaded
*
* Postcondition: Verified value for MNEMONIC
CHECK_0XXX:
    CMPI.B  #$4, MNEMONIC									;Check if MNEMONIC is in $4
    BLT     CHECK_00XX										;If so it's in the 00XX group
    JMP     CHECK_01XX										;If not it's in 01XX

* <EA>
* Description: Checks the MNEMONIC starting from 1XXX
*
* Precondition: MNEMONIC has been loaded
*
* Postcondition: Verified value for MNEMONIC
CHECK_1XXX:
    CMPI.B  #$8, MNEMONIC									;Check if MNEMONIC is $8
    BEQ     LOAD_1000										;If so load equivalent value into it
    CMPI.B  #$9, MNEMONIC									;Check if MNEMONIC is $8
    BEQ     LOAD_1001										;If so load equivalent value into it
    CMPI.B  #$B, MNEMONIC									;Check if MNEMONIC is $8
    BEQ     LOAD_1011										;If so load equivalent value into it
    CMPI.B  #$C, MNEMONIC									;Check if MNEMONIC is $8
    BEQ     LOAD_1100										;If so load equivalent value into it
    CMPI.B  #$D, MNEMONIC									;Check if MNEMONIC is $8
    BEQ     LOAD_1101										;If so load equivalent value into it
    CMPI.B  #$E, MNEMONIC									;Check if MNEMONIC is $8
    BEQ     LOAD_1110										;If so load equivalent value into it
    
    JMP     INVALID											;Otherwise value is INVALID
    
    RTS														;Return to stack

* <EA>
* Description: Checks the MNEMONIC starting from 00XX
*
* Precondition: MNEMONIC is loaded
*
* Postcondition: Verified MNEMONIC value
CHECK_00XX:
    CMPI.B  #$1, MNEMONIC									;Check if MNEMONIC is equal to $1
    BLT     LOAD_0000										;If so then it's 0000
    BGE     LOAD_00XX										;Otherwise it's 00XX

* <EA>
* Description: Checks the MNEMONIC starting from 01XX
*
* Precondition: MNEMONIC is loaded
*
* Postcondition: Verified value for MNEMONIC
CHECK_01XX:
    CMPI.B  #%0100, MNEMONIC									;Check if MNEMONIC is $4
    BEQ     LOAD_0100											;Load equivalent value
    CMPI.B  #%0101, MNEMONIC									;Check if MNEMONIC is $5
    BEQ     LOAD_0101											;Load equivalent value
    CMPI.B  #%0110, MNEMONIC									;Check if MNEMONIC is $6
    BEQ     LOAD_0110											;Load equivalent value
    RTS															;Return to stack


* LOAD_THIS FUNCTIONS (HIGHEST LEVEL) ************

* <EA>
* Description: Once the MNEMONIC is 1110, it is either ASd, LSd, or ROd.
*
* Registers used: Whether if it is ASd, LSd, or ROd, they all share the same
*                 EA algorithm. D5 for calculation, A2 and A3 for returning from subbranches.
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition: Identified which type of shift it is
LOAD_1110:
            MOVEA.L #0, A2					
            MOVEA.L #0, A3
            CLR.L   D5
    
            MOVE.B  SECOND_3, D5
            ANDI.B  #%011, D5
    
            CMPI.B  #%11, D5
            BEQ     MYBE_ASd_1
            BNE     MYBE_ASd_2

***ASd <ea>***
MYBE_ASd_1  CMPI.B  #%000, FIRST_3
            BEQ     ASd_1
            CMPI.B  #%001, FIRST_3
            BEQ     ASd_1 * LSd
            CMPI.B  #%011, FIRST_3
            BEQ     ASd_1 * ROd
            JMP     INVALID

ASd_1       CMPI.B  #%111, THIRD_3
            BNE     MOVEON  
            CMPI.B  #%100, FOURTH_3
            BEQ     INVALID

MOVEON      MOVEA.W #ASd_1_BACK, A3           
            CMPI.B  #%000, FOURTH_3
            BEQ     SIZE_W
            CMPI.B  #%001, FOURTH_3
            BEQ     SIZE_L

ASd_1_BACK  MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS


***ASd X, Y***
MYBE_ASd_2  CLR.L   D5

            MOVE.B  THIRD_3, D5
            ANDI.B  #%011, D5
            CMPI.B  #%10, D5
            BNE     ASd_2 * or LSd or ROd
            BEQ     INVALID
            
ASd_2       CLR.L   D5

            MOVE.B  THIRD_3, D5
            ANDI.B  #%100, D5
            CMPI.B  #%100, D5
            BEQ     ASd_2_REG
            BNE     ASd_2_IMD
            
***ASd #<data>, Dy***
ASd_2_IMD   MOVEA.W #ASd_2_IMD_B, A2
            CMPI.B  #%000, FIRST_3
            BEQ     LOAD_8
            BNE     LOAD_FIRST3
            
LOAD_8      MOVE.B  #8, D4
            JMP     LOAD_IMMDTE

LOAD_FIRST3 MOVE.B  FIRST_3, D4
            JMP     LOAD_IMMDTE

ASd_2_IMD_B JSR     LOAD_COMMA_SPACE

            MOVE.B  #%000, D3
            MOVE.B  FOURTH_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS

***ASd Dx, Dy***
ASd_2_REG   MOVE.B  #%000, D3
            MOVE.B  FIRST_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_COMMA_SPACE
            
            MOVE.B  #%000, D3
            MOVE.B  FOURTH_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS
***ASd Dx, Dy***

***ASd X, Y ***



* <EA>
* Description: Once the MNEMONIC is 0110, it is either BRA or Bcc.
*
* Registers used: Whether if it is BRA or Bcc, in terms of EA, both instructions
*                 share the same EA algorithm. D4 for the displacement, D5 for calculation,
*                 D6 for checking the current opcode, A2 and A3 for returning from subbranches.
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition: Determine if operand is BRA or Bcc, and loads EA values into G_BUFFER
LOAD_0110:
            MOVEA.L #0, A2
            MOVEA.L #0, A3
            CLR.L   D5
            CLR.L   D6
            CLR.L   D4

            CMPI.B  #%000, FIRST_3
            BEQ     MYBE_BRA
            BNE     NOT_BRA
MYBE_BRA    CMPI.B  #%100, SECOND_3
            BLT     BRA
            BGE     NOT_BRA
            
NOT_BRA     MOVE.B  FIRST_3, D5
            ASL.B   #1, D5
            MOVE.B  SECOND_3, D6
            ASR.B   #2, D6
            ADD.B   D6, D5
            
            CMPI.B  #%0101, D5
            BEQ     BRA * CS
            CMPI.B  #%1000, D5
            BEQ     BRA * VC
            CMPI.B  #%1100, D5
            BEQ     BRA * GE
            CMPI.B  #%1101, D5
            BEQ     BRA * LT
            
            JMP     INVALID
            
            
BRA         CLR.L   D5
            CLR.L   D6

            MOVE.W  A5, D5 * D5 has $1002 (Starting + MNEMONICS)
            MOVE.W  CUR_OP_CODE, D6
            ANDI.W  #$00FF, D6 * D6 now has $E
            CMPI.B  #$00, D6
            BEQ     BRA_WORD * word. there is 4 hex trailing bits (word)

            CMPI.B  #$FF, D6
            BEQ     BRA_BYTE
            CMPI.B  #$FE, D6
            BEQ     BRA_BYTE

            JMP     INVALID
            
***BRA_BYTE***
BRA_BYTE    CMPI.B  #$FE, D6
            BEQ     DOWN_ZERO
            CMPI.B  #$FF, D6
            BEQ     DOWN_ONE
            
            JMP     INVALID
            
DOWN_ZERO   SUBI.B  #$2, D5 * D5 has $1000 (Starting)
            JMP     BRA_BYTE2
            
DOWN_ONE    SUBI.B  #$1, D5 * D5 has $1001 (Starting + 1)
            JMP     BRA_BYTE2
            
BRA_BYTE2   MOVE.W  #BRA_BYTE3, A2
            MOVE.W  D5, D4
            JMP     LOAD_ABS_SHORT
BRA_BYTE3   JSR     LOAD_NEW_LINE
            RTS

***BRA_WORD***
BRA_WORD    MOVE.W  (A5)+, D4 * D4 now has $000E

            CMPI.L  #$8000, D4
            BGE     NEG_WORD
            BLT     POS_WORD
            
***BRA_WORD_POSITIVE ***
POS_WORD    MOVE.W  #BRA_WORD_BK, A2
            ADD.W   D5, D4 * D4 now has $100E
            JMP     LOAD_ABS_SHORT
BRA_WORD_BK JSR     LOAD_NEW_LINE
            RTS

***BRA_WORD_NEGATIVE ***
NEG_WORD    MOVE.W  #BRA_WRD_BK2, A2
            NEG     D4
            
            CMP.L   D5, D4 * $4002 vs DISPLACEMENT
            BGT     INVALID
            
            SUB.W   D4, D5 * D5 now has $1000 - 2cmp'ed $000E
            MOVE.W  D5, D4
            JMP     LOAD_ABS_SHORT
BRA_WRD_BK2 JSR     LOAD_NEW_LINE
            RTS


* <EA>
* Description: Once the MNEMONIC is 1001, it is either ADD or ADDA.
*
* Registers used: If ADDA, D3 for SRC/DST mod, D2 for SRC/DST reg, A3 to get back from the subbranch,
*				  D1 for size calculation.
*                 If ADD, basically recycling the algorithm for DIVS/OR
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition: Determine if operand is ADD or ADDA, and loads EA values into G_BUFFER
LOAD_1101:
            CMPI.B  #%011, SECOND_3
            BEQ     ADDA
            CMPI.B  #%111, SECOND_3
            BEQ     ADDA
            
            JMP     LOAD_1000
            
ADDA        MOVEA.W #ADDA_BACK, A3
            CLR.L   D1
            MOVE.B  SECOND_3, D1
            ANDI.B  #%100, D1
            
            CMPI.B  #%000, D1
            BEQ     SIZE_W
            CMPI.B  #%100, D1
            BEQ     SIZE_L
            
ADDA_BACK   MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2

            JSR     LOAD_EA
            JSR     LOAD_COMMA_SPACE
            
            MOVE.B  #%001, D3
            MOVE.B  FIRST_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS

* <EA>
* Description: Once the MNEMONIC is 1001, it is MULS.
*
* Registers used: Basically recycling the algorithm for DIVS/OR
*
* Precondition: MNEMONIC is 1001
*
* Postcondition: Goes to check if it's DIVS or OR
LOAD_1100:
    JMP     LOAD_1000
    
* <EA>
* Description: Once the MNEMONIC is 1001, it is either EOR or CMP.
*
* Registers used: Basically recycling the algorithm for DIVS/OR
*
* Precondition: MNEMONIC is 1001
*
* Postcondition: Goes to check if it's DIVS or OR
LOAD_1011:
    JMP     LOAD_1000


* <EA>
* Description: Once the MNEMONIC is 1001, it is SUB.
*
* Registers used: Basically recycling the algorithm for DIVS/OR
*
* Precondition: MNEMONIC is 1001
*
* Postcondition: Goes to check if it's DIVS or OR
LOAD_1001:
    JMP     LOAD_1000


* <EA>
* Description: Once the MNEMONIC is 1000, it is either DIVS or OR.
*
* Registers used: D3 for SRC/DST mod, D2 for SRC/DST reg, A3 to get back from the subbranch.
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition:Determine if operand is DIVS or OR, and loads EA values into G_BUFFER
LOAD_1000:
            CLR.L   D3
            CLR.L   D2
            MOVEA.L #0, A3
            
            CMPI.B  #%111, SECOND_3
            BEQ     DIVS
            
            CMPI.B  #%011, SECOND_3
            BEQ     INVALID
            
            CMPI.B  #%100, SECOND_3
            BLT     DIR_0 									;direction bit 0
            BGE     DIR_1 									;direction bit 1
            
DIR_0       CLR.L   D1
            MOVE.B  SECOND_3, D1
            ANDI.B  #%011, D1
    
            MOVEA.W #OR_BACK, A3
            CMPI.B  #%00, D1
            BEQ     SIZE_B
            CMPI.B  #%01, D1
            BEQ     SIZE_W
            CMPI.B  #%10, D1
            BEQ     SIZE_L
            
OR_BACK     MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2

            JSR     LOAD_EA
            JSR     LOAD_COMMA_SPACE
            
            MOVE.B  #%000, D3
            MOVE.B  FIRST_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS
            
DIR_1       MOVE.B  #%000, D3
            MOVE.B  FIRST_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_COMMA_SPACE
            
            CLR.L   D1
            MOVE.B  SECOND_3, D1
            ANDI.B  #%011, D1
    
            MOVEA.W #OR_BACK2, A3
            CMPI.B  #%00, D1
            BEQ     SIZE_B
            CMPI.B  #%01, D1
            BEQ     SIZE_W
            CMPI.B  #%10, D1
            BEQ     SIZE_L
            
OR_BACK2    MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2

            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS    
            
            
DIVS        MOVEA.W #DIVS_BACK, A3
            CMPI.B  #%000, FOURTH_3
            BEQ     SIZE_W
            CMPI.B  #%001, FOURTH_3
            BEQ     INVALID
            CMPI.B  #%100, FOURTH_3
            BEQ     SIZE_W
            
DIVS_BACK   MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2

            JSR     LOAD_EA
            JSR     LOAD_COMMA_SPACE

            MOVE.B  #%000, D3
            MOVE.B  FIRST_3, D2

            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS


* <EA>
* Description: Once the MNEMONIC is 0101, it is SUBQ
*
* Registers used: D4 to load the data within the EA bits, and A2 to come back
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition: Determine if operand is SUBQ, and loads EA values into G_BUFFER
LOAD_0101:
            CLR.L   D3
            CLR.L   D2
            MOVEA.L #0, A3

            CMPI.B  #%111, FIRST_3
            BLE     MYBE_SUBQ1
            JMP     INVALID
            
MYBE_SUBQ1  CMPI.B  #%011, SECOND_3
            BGT     MYBE_SUBQ2
            JMP     INVALID

MYBE_SUBQ2  CMPI.B  #%111, SECOND_3
            BLT     SUBQ
            JMP     INVALID

SUBQ        ADDI.B  #%1, FIRST_3
            MOVE.B  FIRST_3, D4
            
            MOVEA.W #SUBQ_SAVED, A2
            JMP     LOAD_IMMDTE
            
SUBQ_SAVED  JSR     LOAD_COMMA_SPACE

            MOVEA.W #SUBQ_BACK, A3
            CMPI.B  #%100, SECOND_3
            BEQ     SIZE_B
            CMPI.B  #%101, SECOND_3
            BEQ     SIZE_W
            CMPI.B  #%110, SECOND_3
            BEQ     SIZE_L
            
SUBQ_BACK   MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2

            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS

* <EA>
* Description: Once the MNEMONIC is 0100, it is either NEG, RTS, JSR, MOVEM, or LEA.
*
* Registers used: D3 for SRC/DST mod, D2 for SRC/DST reg, A3 to get back from the subbranch,
*                 D5, D4 for BCLR, D6 for recognizing MOVEM
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition: Determine if operand is NEG,RTS,JSR,MOVEM, or LEA,
* and loads EA values into G_BUFFER
LOAD_0100:
            CLR.L   D3
            CLR.L   D2
            MOVEA.L #0, A3

            CMPI.B  #%010, FIRST_3
            BEQ     MYBE_NEG
            BNE     NOT_NEG
MYBE_NEG    CMPI.B  #%011, SECOND_3
            BLT     NEG

NOT_NEG     CMPI.B  #%111, FIRST_3
            BEQ     MYBE_RTS1
            BNE     NOT_RTS
MYBE_RTS1   CMPI.B  #%001, SECOND_3
            BEQ     MYBE_RTS2
            BNE     NOT_RTS
MYBE_RTS2   CMPI.B  #%110, THIRD_3
            BEQ     MYBE_RTS3
            BNE     NOT_RTS
MYBE_RTS3   CMPI.B  #%101, FOURTH_3
            BEQ     RTS
            CMPI.B  #%001, FOURTH_3 
            BEQ     RTS										;It's actually NOP but it's the same in EA perspective
            
NOT_RTS     CMPI.B  #%111, FIRST_3
            BEQ     MYBE_JSR
            BNE     NOT_JSR
MYBE_JSR    CMPI.B  #%010, SECOND_3
            BEQ     JSR

NOT_JSR     CLR.L   D6
            MOVE.B  FIRST_3, D6
            ANDI.B  #%101, D6 								;Making %1X0 -> %100
            CMPI.B  #%100, D6
            BEQ     MYBE_MOVEM
            BNE     NOT_MOVEM
            
MYBE_MOVEM  MOVE.B  SECOND_3, D6
            ANDI.B  #%110, D6
            CMPI.B  #%010, D6
            BEQ     MOVEM
            
NOT_MOVEM   CMPI.B  #%111, SECOND_3
            BEQ     LEA
            
            JMP     INVALID

NEG:
            MOVEA.W #NEG_BACK, A3
            CMPI.B  #%000, SECOND_3
            BEQ     SIZE_B
            CMPI.B  #%001, SECOND_3
            BEQ     SIZE_W
            CMPI.B  #%010, SECOND_3
            BEQ     SIZE_L
            
NEG_BACK    MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2

            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS
            
RTS:
            JSR     LOAD_NEW_LINE
            RTS

JSR:
            MOVEA.W #JSR_BACK, A3
            CMPI.B  #%000, FOURTH_3
            BEQ     SIZE_W
            CMPI.B  #%001, FOURTH_3
            BEQ     SIZE_L
            
JSR_BACK    MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS

MOVEM:
            JSR     RUN_MOVEM
            JSR     LOAD_NEW_LINE
            RTS
    
LEA:
            MOVEA.W #LEA_BACK, A3
            CMPI.B  #%000, FOURTH_3
            BEQ     SIZE_W
            CMPI.B  #%001, FOURTH_3
            BEQ     SIZE_L
            CMPI.B  #%100, FOURTH_3
            BEQ     INVALID 
            
LEA_BACK    MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_COMMA_SPACE
            
            MOVE.B  #%001, D3
            MOVE.B  FIRST_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS 

* <EA>
* Description: Helper function for MOVEM.
*
* Registers used: D3 for SRC/DST mod, D2 for SRC/DST reg, A3 to get back from the subbranch,
*                 D4, D5, and D6 for calculations
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition: MOVEM decoding has been successful
RUN_MOVEM:
			CLR.L	D4
			CLR.L	D5
			CLR.L	D6
			MOVEA.L	#0, A3
			
			MOVE.B	FIRST_3, D6
			ANDI.B	#%010, D6
			CMPI.B	#%010, D6
			BEQ		MOVEM_POST
			BNE		MOVEM_PRE

MOVEM_POST	CMPI.B	#%011, THIRD_3
			BEQ		MOVEM_POST2
			CMPI.B	#%010, THIRD_3
			BEQ		MOVEM_POST2
			CMPI.B	#%111, THIRD_3
			BEQ		MOVEM_POST3
			JMP		INVALID

MOVEM_POST2	MOVE.B	THIRD_3, D3
			MOVE.B	FOURTH_3, D2
			JSR		LOAD_EA
			JSR		LOAD_COMMA_SPACE

			JSR		MOVEM_PARSE
            RTS

MOVEM_POST3	* see if new displacement doesn't exceed END_ADDRESS or A6
			CLR.L	D6
			MOVE.W	A5, D6
			ADDI.B	#2, D6
			CMP.W	A6, D6
			BGT		INVALID									;Displacement exceeded address
			
			* push A5 pointer +2
			ADDA.W	#2, A5
			CMPI.B	#%000, FOURTH_3
			BEQ		MOVEM_POSTW
			CMPI.B	#%001, FOURTH_3
			BEQ		MOVEM_POSTL
			JMP		INVALID									;Displacement exceeded address
			
MOVEM_POSTW * see if new displacement doesn't exceed END_ADDRESS or A6
			CLR.L	D6
			MOVE.W	A5, D6
			ADDI.B	#2, D6
			CMP.W	A6, D6
			BGT		INVALID									;Displacement exceeded address
			
			* munch 2
			MOVE.W  #$2, TRAILING_SIZE
			MOVE.B	THIRD_3, D3
			MOVE.B	FOURTH_3, D2
			JSR		LOAD_EA
			JSR		LOAD_COMMA_SPACE
			
			* push back -4
			SUBA.W	#4, A5
			JSR		MOVEM_PARSE
			* push 2
			ADDA.W	#2, A5
			RTS

MOVEM_POSTL * see if new displacement doesn't exceed END_ADDRESS or A6
			CLR.L	D6
			MOVE.W	A5, D6
			ADDI.B	#2, D6
			CMP.W	A6, D6
			BGT		INVALID									;Displacement exceeded address
			
			* munch 4
			MOVE.W  #$4, TRAILING_SIZE
			MOVE.B	THIRD_3, D3
			MOVE.B	FOURTH_3, D2
			JSR		LOAD_EA
			JSR		LOAD_COMMA_SPACE

			* push back -6
			SUBA.W	#6, A5
			JSR		MOVEM_PARSE
			* push 4
			ADDA.W	#4, A5
			RTS

MOVEM_PRE	JSR		MOVEM_PARSE
			JSR		LOAD_COMMA_SPACE

			MOVEA.W #MOVEM_PRE_B, A3
            CMPI.B  #%000, FOURTH_3
            BEQ     SIZE_W
            CMPI.B  #%001, FOURTH_3
            BEQ     SIZE_L
            JMP     INVALID									;Displacement exceeded address
			
MOVEM_PRE_B	CMPI.B	#%000, THIRD_3
			BEQ		INVALID									;Displacement exceeded address
			CMPI.B	#%011, THIRD_3
			BEQ		INVALID
			CMPI.B	#%001, THIRD_3
			BEQ		INVALID
			
			MOVE.B	THIRD_3, D3
			MOVE.B	FOURTH_3, D2
			
			JSR		LOAD_EA
			JSR		LOAD_NEW_LINE
			RTS
			
* <EA>
* Description: Helper function for RUN_MOVEM. MOVEM_PARSE is responsible for loading the list (D0-D7/A0-A7)
*
* Registers used: D3 for SRC/DST mod, D2 for SRC/DST reg, A3 to get back from the subbranch,
*                 D4 for calculations.
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition: RUN_MOVEM is able to decode MOVEM
MOVEM_PARSE:
			CLR.L	D4
			MOVE.W	(A5)+, D4 * D4 has $00FF
						
			CMPI.B	#%100, THIRD_3
			BNE		ADDRESS_TO_DATA
			BEQ		DATA_TO_ADDRESS

ADDRESS_TO_DATA		MOVE.B	#%001, MOVEM_FIRST_VAR			; MOVEM_FIRST_VAR= A
			MOVE.B	#%000, MOVEM_SECOND_VAR					; MOVEM_SECOND_VAR= D
			MOVE.B	#$8, MOVEM_FIRST_VAR_COUNTER 			; start from 8
			MOVE.B	#$8, MOVEM_SECOND_VAR_COUNTER 			; start from 8
			MOVE.B	#0, FIRST_VAR_MOVEM
			MOVE.B	#0, SECOND_VAR_MOVEM

			JMP		GO_ADDRESS_TO_DATA
			
DATA_TO_ADDRESS		MOVE.B	#%000, MOVEM_FIRST_VAR			; MOVEM_FIRST_VAR= D
			MOVE.B	#%001, MOVEM_SECOND_VAR					; MOVEM_SECOND_VAR= A
			MOVE.B	#$FF, MOVEM_FIRST_VAR_COUNTER 			; start from -1
			MOVE.B	#$FF, MOVEM_SECOND_VAR_COUNTER 			; start from -1
			MOVE.B	#0, FIRST_VAR_MOVEM
			MOVE.B	#0, SECOND_VAR_MOVEM
			
			JMP		GO_DATA_TO_ADDRESS

***MOVEM D->A***
GO_DATA_TO_ADDRESS	ROL.W	#1, D4
			MOVE.W	D4, D5
			ANDI.W	#$1, D5
			
			CMPI.B	#7, MOVEM_FIRST_VAR_COUNTER
			BGE		ADD_Y
			BLT		ADD_X
			
ADD_X		ADDI.B	#1, MOVEM_FIRST_VAR_COUNTER
			JMP		KEEP_GOING0

ADD_Y		ADDI.B	#1, MOVEM_SECOND_VAR_COUNTER
            MOVE.B  #8, MOVEM_FIRST_VAR_COUNTER
			JMP		KEEP_GOING0
			
KEEP_GOING0	CMPI.W	#$1, D5
			BEQ		BIT_ON
			BNE		KEEP_GOING
			
BIT_ON		CMPI.B	#8, MOVEM_FIRST_VAR_COUNTER
			BNE		ITS_X
			BEQ		MYBE_Y
			
ITS_X		MOVE.B	MOVEM_FIRST_VAR, D3 * LOAD[XX COUNTER]
			MOVE.B	MOVEM_FIRST_VAR_COUNTER, D2
			JSR		LOAD_EA
			CMPI.B	#0, FIRST_VAR_MOVEM
			BEQ		FST_X
			BNE		SND_X

FST_X		MOVE.B  #$2D, (A4)+ * LOAD '-'
			MOVE.B	#1, FIRST_VAR_MOVEM						;FIRST_VAR_MOVEM = 1
			JMP		KEEP_GOING
			
SND_X		SUBA.W	#2, A4 * push back G_BUFFER pointer by 2
			JMP		KEEP_GOING

MYBE_Y		CMPI.B	#8, MOVEM_SECOND_VAR_COUNTER
			BNE		ITS_Y
			BEQ		KEEP_GOING

ITS_Y		CMPI.B	#0, SECOND_VAR_MOVEM
			BEQ		FST_Y1
ITS_Y_BACK	MOVE.B	MOVEM_SECOND_VAR, D3 * LOAD[YY COUNTER]
			MOVE.B	MOVEM_SECOND_VAR_COUNTER, D2
			JSR		LOAD_EA
			CMPI.B	#0, SECOND_VAR_MOVEM
			BEQ		FST_Y2
			BNE		SND_Y

FST_Y1		CMPI.B	#1, FIRST_VAR_MOVEM
			BNE		SKIP_HERE
			;ADDA.W	#2, A4 * push G_BUFFER pointer by 2
						
			MOVE.B	#$20, (A4)+
			MOVE.B	#$20, (A4)+

			MOVE.B  #$2F, (A4)+ * LOAD '/'
SKIP_HERE	JMP		ITS_Y_BACK

FST_Y2		MOVE.B  #$2D, (A4)+ * LOAD '-'
			MOVE.B	#1, SECOND_VAR_MOVEM				; SECOND_VAR_MOVEM= 1
			JMP		KEEP_GOING

SND_Y		SUBA.W	#2, A4 * push back G_BUFFER pointer by 2
			JMP		KEEP_GOING

KEEP_GOING	CMPI.B	#8, MOVEM_SECOND_VAR_COUNTER
			BNE		GO_DATA_TO_ADDRESS
			
			ADDA.W	#2, A4 * push G_BUFFER pointer by 2
			RTS


***MOVEM A->D***
GO_ADDRESS_TO_DATA	ROL.W	#1, D4
			MOVE.W	D4, D5
			ANDI.W	#$1, D5
			
			CMPI.B	#0, MOVEM_FIRST_VAR_COUNTER
			BGT     SUBTRACT_X 
			BLE 	SUBTRACT_Y 
			
SUBTRACT_X	SUBI.B	#1, MOVEM_FIRST_VAR_COUNTER
			JMP		KEEP_GOING1

SUBTRACT_Y	SUBI.B	#1, MOVEM_SECOND_VAR_COUNTER
            MOVE.B  #$FF, MOVEM_FIRST_VAR_COUNTER
			JMP		KEEP_GOING1
			
KEEP_GOING1	CMPI.W	#$1, D5
			BEQ		BIT_ON2
			BNE		KEEP_GOING2
			
BIT_ON2		CMPI.B	#$FF, MOVEM_FIRST_VAR_COUNTER
			BNE		ITS_X2
			BEQ		MYBE_Y2
			
ITS_X2		MOVE.B	MOVEM_FIRST_VAR, D3 * LOAD[XX COUNTER]
			MOVE.B	MOVEM_FIRST_VAR_COUNTER, D2
			JSR		LOAD_EA
			CMPI.B	#0, FIRST_VAR_MOVEM
			BEQ		FST_X2
			BNE		SND_X2

FST_X2		MOVE.B  #$2D, (A4)+ * LOAD '-'
			MOVE.B	#1, FIRST_VAR_MOVEM				; FIRST_VAR_MOVEM = 1
			JMP		KEEP_GOING2
			
SND_X2		SUBA.W	#2, A4 * push back G_BUFFER pointer by 2
			JMP		KEEP_GOING2

MYBE_Y2		CMPI.B	#$FF, MOVEM_SECOND_VAR_COUNTER
			BNE		ITS_Y2
			BEQ		KEEP_GOING2

ITS_Y2		CMPI.B	#0, SECOND_VAR_MOVEM
			BEQ		FST_Y3
ITS_Y2_BACK	MOVE.B	MOVEM_SECOND_VAR, D3 * LOAD[YY COUNTER]
			MOVE.B	MOVEM_SECOND_VAR_COUNTER, D2
			JSR		LOAD_EA
			CMPI.B	#0, SECOND_VAR_MOVEM
			BEQ		FST_Y4
			BNE		SND_Y2

FST_Y3		CMPI.B	#1, FIRST_VAR_MOVEM
			BNE		SKIP_HERE2
			;ADDA.W	#2, A4 * push G_BUFFER pointer by 2
			
			MOVE.B	#$20, (A4)+
			MOVE.B	#$20, (A4)+
			
			MOVE.B  #$2F, (A4)+ * LOAD '/'
SKIP_HERE2	JMP		ITS_Y2_BACK

FST_Y4		MOVE.B  #$2D, (A4)+ * LOAD '-'
			MOVE.B	#1, SECOND_VAR_MOVEM					; SECOND_VAR_MOVEM= 1
			JMP		KEEP_GOING2

SND_Y2		SUBA.W	#2, A4 * push back G_BUFFER pointer by 2
			JMP		KEEP_GOING2

KEEP_GOING2	CMPI.B	#$FF, MOVEM_SECOND_VAR_COUNTER
			BNE		GO_ADDRESS_TO_DATA   
			
			ADDA.W	#2, A4 * push G_BUFFER pointer by 2
			RTS
			
			
* <EA>
* Description: Once the MNEMONIC is 0000, it is either BCLR, CMPI, ORI, or Dynamic BCLR.
*
* Registers used: D3 for SRC/DST mod, D2 for SRC/DST reg, A3 to get back from the subbranch,
*                 D5, D4 for BCLR
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition: Determine if operand is BCLR,CMPI,ORI,Dynamic BCLR
* and loads EA values into G_BUFFER
LOAD_0000:
            CLR.L   D3
            CLR.L   D2
            MOVEA.L #0, A3

            CMPI.B  #%000, FIRST_3
            BEQ     MYBE_ORI
            BNE     NOT_ORI
MYBE_ORI    CMPI.B  #%011, SECOND_3
            BLT     ORI_CMPI            

NOT_ORI     CMPI.B  #%110, FIRST_3
            BEQ     MYBE_CMPI
            BNE     NOT_CMPI
MYBE_CMPI   CMPI.B  #%011, SECOND_3
            BLT     ORI_CMPI
            
NOT_CMPI    CMPI.B  #%100, FIRST_3
            BEQ     MYBE_BCLR
            BNE     NOT_BCLR
MYBE_BCLR   CMPI.B  #%010, SECOND_3
            BEQ     BCLR

NOT_BCLR    CMPI.B  #%110, SECOND_3
            BEQ     DYNMC_BCLR
            
            JMP     INVALID
            

ORI_CMPI    MOVEA.W #BACK, A3
            CMPI.B  #%000, SECOND_3
            BEQ     SIZE_B
            CMPI.B  #%001, SECOND_3
            BEQ     SIZE_W
            CMPI.B  #%010, SECOND_3
            BEQ     SIZE_L

BACK        MOVE.B  #%111, D3
            MOVE.B  #%100, D2
            
            JSR     LOAD_EA
            JSR     LOAD_COMMA_SPACE
            
            MOVEA.W #BACK2, A3   
            CMPI.B  #%000, FOURTH_3
            BEQ     SIZE_W
            CMPI.B  #%001, FOURTH_3
            BEQ     SIZE_L
            CMPI.B  #%100, FOURTH_3 
            BEQ     INVALID 

BACK2       MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2
        
            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            RTS


BCLR        CLR.L   D5
            CLR.L   D4
            MOVEA.L #0, A2

            MOVE.W  A6, D5
            SUB.W   A5, D5
            CMPI.W  #$2, D5
            BLT     INVALID

            MOVE.W  (A5)+, D4
            CLR.L   D4
            MOVE.W  (A5)+, D4
            ANDI.W  #$00FF, D4
            MOVEA.L #BACK4, A2
            JMP     LOAD_IMMDTE
            
BACK4       JSR     LOAD_COMMA_SPACE
            
            MOVEA.W #BACK3, A3
            CMPI.B  #%000, FOURTH_3
            BEQ     SIZE_W
            CMPI.B  #%001, FOURTH_3
            BEQ     SIZE_L
            CMPI.B  #%100, FOURTH_3 
            BEQ     INVALID 

BACK3       MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2

            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE

            RTS


DYNMC_BCLR  MOVE.B  #%000, D3
            MOVE.B  FIRST_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_COMMA_SPACE

            MOVEA.W #BACK5, A3
            CMPI.B  #%000, FOURTH_3
            BEQ     SIZE_W
            CMPI.B  #%001, FOURTH_3
            BEQ     SIZE_L
            CMPI.B  #%100, FOURTH_3 
            BEQ     INVALID 
            
BACK5       MOVE.B  THIRD_3, D3
            MOVE.B  FOURTH_3, D2
            
            JSR     LOAD_EA
            JSR     LOAD_NEW_LINE
            
            RTS


* <EA>
* Description: Once the MNEMONIC is 00XX, it is either MOVE or MOVEA. Checks the 3-bit bundles and
*              the size of immediate/address values if necessary.
*
* Registers used: D3 for SRC/DST mod, D2 for SRC/DST reg, A3 to get back from the subbranch
*
* Precondition: FIRST_3, SECOND_3, THIRD_3, FOURTH_3
*
* Postcondition: MOVE or MOVEA is identified and decoded for EA
LOAD_00XX:
        CLR.L   D3
        CLR.L   D2
        MOVEA.L #0, A3
        
        MOVEA.W #GOO, A3
        CMPI.B  #%0011, MNEMONIC
        BEQ     SIZE_W
        CMPI.B  #%0010, MNEMONIC
        BEQ     SIZE_L

GOO     MOVE.B  THIRD_3, D3
        MOVE.B  FOURTH_3, D2
    
        JSR     LOAD_EA
        JSR     LOAD_COMMA_SPACE
    
        MOVEA.W #GOO2, A3
        CMPI.B  #%000, FIRST_3
        BEQ     SIZE_W
        CMPI.B  #%001, FIRST_3
        BEQ     SIZE_L
    
GOO2    MOVE.B  SECOND_3, D3
        MOVE.B  FIRST_3, D2
            
        JSR     LOAD_EA
        JSR     LOAD_NEW_LINE
    
        RTS



*** LOAD_THIS FUNCTIONS (HIGH LEVEL)

* <EA>
* Description: Checks the SRC/DST mod
*
* Registers used: A2 for branching back from subbranches
*
* Precondition: D3 for SRC/DST mod
*
* Postcondition: SRC or DST modes have been initialized
LOAD_EA:
        MOVEA.W #SAVED, A2 * remember to come back!

        CMPI    #%111, D3
        BLT     LOAD_LT_111
        BGE     LOAD_GE_111
    
SAVED   RTS


* <EA>
* Description: Checks the SRC/DST mod where it is not immediate/address value
*
* Registers used: X
*
* Precondition: D3 for SRC/DST mod
*
* Postcondition: SRC or DST modes have been initialized for non immediate values
LOAD_LT_111:
    CMPI    #%000, D3 * e.g. D3
    BEQ     LOAD_DATA_REGISTER
    CMPI    #%001, D3 * e.g. A3
    BEQ     LOAD_ADDR_REGISTER
    CMPI    #%010, D3 * e.g. (A3)
    BEQ     LOAD_ADDRESS
    CMPI    #%011, D3 * e.g. (A3)+
    BEQ     LOAD_ADDRESS_W_POST_INC
    CMPI    #%100, D3 * e.g. -(A3)
    BEQ     LOAD_ADDRESS_W_PRE_DEC
    
    JMP     INVALID


* <EA>
* Description: Checks the SRC/DST mod where it is immediate/address value
*
* Registers used: D5 for SUB.W, D4 for immediate/address value extraction
*
* Precondition: A5 for START_ADDRESS iteration, TRAILING_SIZE for size of the immediate/address value
*
* Postcondition: IS_INVALID flag set if EA bit not valid
LOAD_GE_111:
            CLR.L   D5
            CLR.L   D4

            MOVE.W  A6, D5
            SUB.W   A5, D5
            CMP.W   TRAILING_SIZE, D5
            BLT     INVALID

            CMPI.W  #$1, TRAILING_SIZE
            BEQ     CHUMP_BYTE
            CMPI.W  #$2, TRAILING_SIZE
            BEQ     CHUMP_WORD
            CMPI.W  #$4, TRAILING_SIZE
            BEQ     CHUMP_LONG

CHUMP_BYTE  MOVE.W  (A5)+, D4 * Minimum 4 hex (e.g. MOVE.B #1, $2 = XXXX 0001 0002)
            JMP     GO

CHUMP_WORD  MOVE.W  (A5)+, D4
            JMP     GO
            
CHUMP_LONG  MOVE.L  (A5)+, D4
            JMP     GO

GO          CMPI    #%000, D2
            BEQ     LOAD_ABS_SHORT
            CMPI    #%001, D2
            BEQ     LOAD_ABS_LONG
            CMPI    #%100, D2
            BEQ     LOAD_IMMDTE
    
            JMP     INVALID
            
            
* <EA>
* Description: Puts in the proper value in TRAILING_SIZE based on the immediate/address value size
*
* Registers used: A3
*
* Precondition: Immediate value exists
*
* Postcondition: Set up TRAILING_SIZE
TRAILING_HELPER:            
SIZE_B  MOVE.W  #$2, TRAILING_SIZE
        JMP     (A3)

SIZE_W  MOVE.W  #$2, TRAILING_SIZE
        JMP     (A3)
        
SIZE_L  MOVE.W  #$4, TRAILING_SIZE
        JMP     (A3)


*** LOAD_THIS FUNCTIONS (INTERMEDIATE LEVEL

* <EA>
* Description: Loads ASCII for e.g. D3 in G_BUFFER
*
* Registers used: D0 for actually loading
*
* Precondition: D2 for SRC/DST reg
*
* Postcondition: Loads ASCII for G_BUFFER data register
LOAD_DATA_REGISTER:
    CLR.L   D0
    
    JSR     LOAD_D
    MOVE.B  D2, D0
    JSR     LOAD_NUM
    JMP     (A2)
    
    
* <EA>
* Description: Loads ASCII for e.g. A3 in G_BUFFER
*
* Registers used: D0 for actually loading
*
* Precondition: D2 for SRC/DST reg
*
* Postcondition: Loads ASCII for G_BUFFER addres register
LOAD_ADDR_REGISTER:
    CLR.L   D0

    JSR     LOAD_A
    MOVE.B  D2, D0
    JSR     LOAD_NUM
    JMP     (A2)


* <EA>
* Description: Loads ASCII for e.g. (A3) in G_BUFFER
*
* Registers used: A2
*
* Precondition: Operand has been identified
*
* Postcondition: Regular address register has been loaded for the buffer
LOAD_ADDRESS:
    JSR     LOAD_PTHSIS_OPEN
    JSR     LOAD_ADDR_REGISTER
    JSR     LOAD_PTHSIS_CLSD
    JMP     (A2)


* <EA>
* Description: Loads ASCII for e.g. (A3)+ in G_BUFFER
*
* Registers used: A2
*
* Precondition: Operand has been identified
*
* Postcondition: Post increment address register has been loaded for the buffer
LOAD_ADDRESS_W_POST_INC:
    JSR     LOAD_ADDRESS
    JSR     LOAD_PLUS_SIGN
    JMP     (A2)


* <EA>
* Description: Loads ASCII for e.g. -(A3) in G_BUFFER
*
* Registers used: A2
*
* Precondition: Operand has been identified
*
* Postcondition: Post decrement address register has been loaded for the buffer
LOAD_ADDRESS_W_PRE_DEC:
    JSR     LOAD_MINUS_SIGN
    JSR     LOAD_ADDRESS
    JMP     (A2)


* <EA>
* Description: Loads ASCII for e.g. $1234 in G_BUFFER
*
* Registers used: D0 for actually loading
*
* Precondition: D4 for immediate/address value  
*
* Postcondition: ABS Short value has been loaded in G_BUFFER
LOAD_ABS_SHORT:
    CLR.L   D0

    JSR     LOAD_HEX_SIGN
    MOVE.W  D4, D0
    JSR     LOAD_BYTES
    JMP     (A2)


* <EA>
* Description: Loads ASCII for e.g. $12345678 in G_BUFFER
*
* Registers used: D0 for actually loading
*
* Precondition: D4 for immediate/address value  
*
* Postcondition: ABS_LONG value has been loaded in G_BUFFER
LOAD_ABS_LONG:
    CLR.L   D0

    JSR     LOAD_HEX_SIGN
    MOVE.L  D4, D0
    JSR     LOAD_BYTES
    JMP     (A2)


* <EA>
* Description: Loads ASCII for e.g. #$1234 in G_BUFFER
*
* Registers used: None
*
* Precondition: Immediate value found
*
* Postcondition: Immediate value is loaded in G_BUFFER
LOAD_IMMDTE:
    JSR     LOAD_IMMDTE_VALU
    JMP     LOAD_ABS_LONG


*** LOAD_THIS FUNCTIONS (LOW LEVEL

* <EA>
* Description: Shifts the hex to the left and loads from the left-most hex to G_BUFFER in ASCII
*
* Registers used: D5 for the loop counter, D1 for loop assist
*
* Precondition: D0 for the immediate/address value  
*
* Postcondition: Loads the hex value into G_BUFFER for immediate
LOAD_BYTES:
        CLR.L   D5
        CLR.L   D1

        MOVE.L  D0, D1
        MOVE.B  #8, D5
LOOP    CMPI    #0, D5
        BGT     ROTATE
        RTS
    
ROTATE  ROL.L   #$04, D1
        MOVE.B  D1, D0
        ANDI.L  #$0000000F, D0
        JSR     LOAD_NUM
        SUBI    #1, D5
        JMP     LOOP        


* <EA>
* Description: Loads ASCII for CR, LF 
*
* Registers used: D0 for actually loading
*
* Precondition: CR, LF 
*
* Postcondition: NEW LINE has been loaded.
*
* This routine has been depreciated as IO defines newlines.
LOAD_NEW_LINE:
    RTS


* <EA>
* Description: Loads ASCII for ', ' 
*
* Registers used: D0 for actually loading
*
* Precondition: COMMA, SPACE
*
* Postcondition: ',' and ' ' is loaded into G_BUFFER
LOAD_COMMA_SPACE:
    CLR.L   D0

    MOVE.B  COMMA, D0
    JSR     LOAD_THIS_THING
    MOVE.B  SPACE, D0
    JSR     LOAD_THIS_THING
    
    RTS


* <EA>
* Description: Loads ASCII for D 
*
* Registers used: D0 for actually loading
*
* Precondition: DATA
*
* Postcondition: 'D' is loaded into G_BUFFER
LOAD_D:
    CLR.L   D0

    MOVE.B  DATA, D0
    JSR     LOAD_THIS_THING
    RTS


* <EA>
* Description: Loads ASCII for A
*
* Registers used: D0 for actually loading
*
* Precondition: ADDRESS
*
* Postcondition: 'A' is loaded into G_BUFFER
LOAD_A:
    CLR.L   D0

    MOVE.B  ADDRESS, D0
    JSR     LOAD_THIS_THING
    RTS


* <EA>
* Description: Loads ASCII for (
*
* Registers used: D0 for actually loading
*
* Precondition: PTHSIS_OPEN
*
* Postcondition: '(' is loaded into G_BUFFER
LOAD_PTHSIS_OPEN:
    CLR.L   D0

    MOVE.B  PTHSIS_OPEN, D0
    JSR     LOAD_THIS_THING
    RTS


* <EA>
* Description: Loads ASCII for )
*
* Registers used: D0 for actually loading
*
* Precondition: PTHSIS_CLSD
*
* Postcondition: ')' is loaded into G_BUFFER
LOAD_PTHSIS_CLSD:
    CLR.L   D0

    MOVE.B  PTHSIS_CLSD, D0
    JSR     LOAD_THIS_THING
    RTS


* <EA>
* Description: Loads ASCII for $
*
* Registers used: D0 for actually loading
*
* Precondition: HEX_SIGN
*
* Postcondition: '$' is loaded into G_BUFFER
LOAD_HEX_SIGN:
    CLR.L   D0

    MOVE.B  HEX_SIGN, D0
    JSR     LOAD_THIS_THING
    RTS


* <EA>
* Description: Loads ASCII for #
*
* Registers used: D0 for actually loading
*
* Precondition: IMMDTE_VALU
*
* Postcondition: '#' is loaded into G_BUFFER
LOAD_IMMDTE_VALU:
    CLR.L   D0

    MOVE.B  IMMDTE_VALU, D0
    JSR     LOAD_THIS_THING
    RTS


* <EA>
* Description: Loads ASCII for +
*
* Registers used: D0 for actually loading
*
* Precondition: PLUS_SIGN
*
* Postcondition: '+' is loaded into G_BUFFER
LOAD_PLUS_SIGN:
    CLR.L   D0

    MOVE.B  PLUS_SIGN, D0
    JSR     LOAD_THIS_THING
    RTS


* <EA>
* Description: Loads ASCII for -
*
* Registers used: D0 for actually loading
*
* Precondition: MINUS_SIGN
*
* Postcondition: '-' is loaded into G_BUFFER
LOAD_MINUS_SIGN:
    CLR.L   D0

    MOVE.B  MINUS_SIGN, D0
    JSR     LOAD_THIS_THING
    RTS


*** LOAD_THIS FUNCTIONS (LOWEST LEVEL

* <EA>
* Description: Loads the hex value from D0 to G_BUFFER in ASCII.
*
* Registers used: D0,A4
*
* Precondition: Some value is placed in D0 to load
*
* Postcondition: Loads value from D0 to G_BUFFER
LOAD_THIS_THING:
    MOVE.B  D0, (A4)+										;Post-increment G_BUFFER and load value into it
    RTS														;Return to stack
    
    
* <EA>
* Description: Adds $30 to a number in D0 to make it a hex. If the number is greater
*              than 9 (A~F), then adds $37. Then moves the hex value from D0 to G_BUFFER in ASCII
*
* Registers used: D0,A4
*
* Precondition: Value in D0 has been loaded to some value
*
* Postcondition: Converted D0 value to hex and move it to G_BUFFER
LOAD_NUM:
    CMPI.B  #$9, D0
    BGT     GT
    BLE     LE
    
GT  ADDI.B  #$37, D0 * A~F
    JMP     END
LE  ADDI.B  #$30, D0 * 0~9
    JMP     END

END MOVE.B  D0, (A4)+
    RTS


* <EA>
* Description: Execution goes here if even one of the EA bit is invalid. Flags the invalid-bit and
*              entirely exits the EA process.
*
* Registers used: None
*
* Precondition: INVALID EA mode or OP has been found
*
* Postcondition: Sets IS_VALID to 0 and finishes routine
INVALID:
            MOVE.B  #%0, IS_VALID
            JMP     EXT
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
