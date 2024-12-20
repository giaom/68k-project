# 68k-project
# UWB CSS 475 A Spr, Submitted May 29th 2023

## Overview
This repository contains various assembly language files and projects for the 68k microprocessor from a group project. The files include examples, final projects, demos, experimental tests. Each file serves a different purpose, ranging from demonstrating basic concepts to implementing complex functionalities.

## File Descriptions
### Examples
- **Examples.L68**: Example code in L68 format demonstrating various assembly instructions:
  - `MOVE`, `ADD`, `SUB`, `AND`, `OR`, `LSL`, `LSR`, `ASR`, `ROL`, `ROR`, `JSR`, `RTS`, `NOP`.
- **Examples.X68**: Example code in X68 format demonstrating similar instructions as in `Examples.L68`.

### Final Projects
- **FinalProject_JonathanLee_EA.X68**: Final project focusing on Effective Address calculations. Includes functions like `LOAD_NEW_LINE`, `LOAD_COMMA_SPACE`, `LOAD_IMMDTE_VALU`, `LOAD_PLUS_SIGN`, and `LOAD_MINUS_SIGN`.
- **FinalProject_JonathanLee_OPcode.X68**: Final project focusing on Opcode implementations and disassembler routines. Includes functions like various OP code group checks and `OP_JSR_Routine` which catalogs all supported OP codes into groupings based on their hex values and calls underlying subroutines for further identification of the OP code.

### Demo Tests
- **demo_test.S68**: Demo test code in S68 format demonstrating basic input/output operations and various assembly instructions:
  - `MOVE`, `ADD`, `SUB`, `AND`, `OR`, `LSL`, `LSR`, `ASR`, `ROL`, `ROR`, `JSR`, `RTS`, `NOP`.
- **demo_test.X68**: Demo test code in X68 format demonstrating similar instructions as in `demo_test.S68`:
  - `MOVEA`, `ADDA`, `MULS`, `DIVU`, `MOVEQ`, `MOVEM`, `LEA`.
- **demo_test_code.X68**: Additional demo test code in X68 format demonstrating more complex operations:
  - `AND`, `OR`, `ADD`, `SUB`, `LSL`, `LSR`, `ASR`, `ROL`, `ROR`, `JSR`, `RTS`, `NOP`.

### Experimental
- **experimental.X68**: Experimental code in X68 format, including various functions and routines for testing new features and instructions:
  - `LOAD_NEW_LINE`, `LOAD_COMMA_SPACE`, `LOAD_IMMDTE_VALU`, `LOAD_PLUS_SIGN`, `LOAD_MINUS_SIGN`, `PRINT_OPCODE`, `PRINT_DREG`, `PRINT_AREG`, `PRINT_EA`, `HANDLE_DISPLACEMENT`, `DECODE`.
- **experimental_tests_code.X68**: Experimental test code in X68 format demonstrating various experimental features and instructions:
  - `ADDQ`, `ADDA`, `SUB`, `AND`, `OR`, `LSL`, `LSR`, `ASR`, `ROL`, `ROR`, `JSR`, `RTS`, `NOP`.

### Group Projects
- **group project.L68**: Includes various functions for handling different assembly instructions:`MOVE`, `ADD`, `SUB`, `AND`, `OR`, `LSL`, `LSR`, `ASR`, `ROL`, `ROR`, `JSR`, `RTS`, and `NOP`. Includes a jump table for opcode handling and a handler for unsupported or invalid opcodes.
- **group project.S68**: GContains S-Record formatted data for the group project.
- **group project.X68**: Similar to `group project.L68`, including functions for handling various assembly instructions and a jump table for opcode handling.

### Miscellaneous
- **print.X68**: Code related to printing in X68 format, demonstrating how to print strings and numbers.
- **storeAddresses.X68**: Code for storing addresses in X68 format, demonstrating how to store and retrieve memory addresses.
- **test_codes.L68**: Test codes in L68 format, demonstrating various instructions such as `MOVE`, `ADD`, `SUB`, `AND`, `OR`, `LSL`, `LSR`, `ASR`, `ROL`, `ROR`, `JSR`, `RTS`, and `NOP`.
- **test_codes.S68**: Test codes in S68 format, demonstrating various instructions such as `MOVE`, `ADD`, `SUB`, `AND`, `OR`, `LSL`, `LSR`, `ASR`, `ROL`, `ROR`, `JSR`, `RTS`, and `NOP`.
- **test_codes.X68**: Test codes in X68 format, demonstrating various instructions such as `MOVE`, `ADD`, `SUB`, `AND`, `OR`, `LSL`, `LSR`, `ASR`, `ROL`, `ROR`, `JSR`, `RTS`, and `NOP`.

## Usage
To run any of the assembly files, you will need an appropriate assembler and emulator for the 68k microprocessor. 

## Contributors: 
- Group members:  @ganebe (Lok Yin Wong), @MaryamM4 (Maryam Maabreh), @JonathanLee1217 (Jonathan Lee), and @giaom (Aisha Maabreh).
- Course instructor: Dr. Ahmed Awad

## Assignment Specifications:
1) Write an inverse assembler (disassembler) that will convert a memory image of instructions and data back to 68000 assembly language and output the disassembled code to the display. You will not be required to disassemble all of the instructions and addressing modes. The list of instructions and addressing modes is given at Required Opcodes page. Note that I'm not going to fill the memory with garbage!
2) If you want to see how a disassembler works, just take one of your homework problems and load it in memory at an address after your program. Then open a memory window and see the code in memory. You can also view it as disassembled code in the simulator.
3) DO NOT USE THE TRAP FUNCTION 60 FACILITY OF THE SIMULATOR. You must completely develop your own disassembler algorithm. If I suspect that you used TRAP function 60 I will use a search tool that I designed to scan your source code for the TRAP function 60 calls. You can only use the simulator's text I/O function, Trap Function 15, and you can only use tasks with ID 0 to 14 of Trap Function 15. Task 15 and higher of Trap Function 15 cannot be used.
Please check the available tasks of Trap Function 15: http://www.easy68k.com/QuickStart/TrapTasks.htmLinks to an external site.
4) Your program should be written from the start in 68000 assembly language. Do not write it in C or C++ and then cross-compile it to 68000 code. It is really easy to tell when you've written it in C and it probably won't save you very much time. When you are working at the bit level C is just structured assembly language (or so they say).
5) Your program should be ORG'ed at $1000.
6) At startup, the program should display whatever welcome messages you want to display and then prompt the user for the starting location  and the ending location (in hexadecimal format) of the code to be disassembled. You need to clearly specify the expected input format for user inputs. If it's not clearly specified, then any encountered problems will get your points off.
The program should scan the memory region and output the memory addresses of the instructions and the assembly language instructions contained in that region to the display. You should be able to actually disassemble your own program to the display! DO NOT embed test code into your disassembler code!
7)The display should show one screen of data at a time, hitting the ENTER key should display the next screen of information.
8) The program should be able to realize when it has an illegal instruction ( i.e, data ), and be able to deal with it until it can find instructions again to decode. Instructions that cannot be decoded, either because they do not disassemble as op codes or because you aren't able to decode them should be displayed as:
    1000    DATA    $WXYZ
where $WXYZ is the hexadecimal number that couldn't be decoded. Your program should not crash because it can't decode an instruction. Remember, it is perfectly legal to have data and instructions interspersed, so it is very possible that you will hit data, and not an instruction.
9) Address displacements or offsets should be properly displayed as the address of the branch and display that value. It's the absolute address value, not the displacement value. For example:
  1000          BRA    993         * Branch to address 993
10) You should do a line by line disassembly, displaying the following columns:
            a- Memory location            b- Op-code            c- Operand
11) When it completes the disassembly, the program should prompt the user to disassemble another memory image, or prompt the user to quit.
