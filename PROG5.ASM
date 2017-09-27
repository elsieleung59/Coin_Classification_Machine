TITLE PROG5: PROGRAM ASSIGNMENT FIVE
;Output a prompt chatacter '?'
;Read in a decimal number C (0<C<=99),go to the next line
;Output the number of quarters, dimes, nickels and pennies
;Move the cursor to a new line and Repeat step 1 until a single <CR> is typed.
;Yifan Liang
;wy9368
;11-21-2016
.MODEL SMALL
.386
.STACK
.DATA
CR      EQU     0DH
LF      EQU     0AH
MSG     DB      '? $'
;define the non-zero print out msg
MSGQ1   DB      'The number of quarters = $'    
MSGD1   DB      CR,LF,'The number of dimes = $'
MSGN1   DB      CR,LF,'The number of nickels = $'
MSGP1   DB      CR,LF,'The number of pennies = $'
;define the zero print out msg
MSGQ0   DB      'The number of quarters = 0$'
MSGD0   DB      CR,LF,'The number of dimes = 0$'
MSGN0   DB      CR,LF,'The number of nickels = 0$'
MSGP0   DB      CR,LF,'The number of pennies = 0$'
;define the divisor values
DIV25   DW      25D
DIV10   DW      10D
DIV5    DW      5D
DIV1    DW      1D
;other variables
REM     DW      ?
QUO     DW      ?
COPY    DW      ?
.CODE
MAIN   PROC
;initialize DS
    MOV     AX,@DATA     ;get data segment 
    MOV     DS,AX        ;initialize DS
REPEAT_:
;input a number
    MOV     AH,2
    MOV     DL,'?'
    INT     21H          ;print '?' 
    CALL	INDEC1		 ;number in AX
    CMP	DH,1
	JL	EXIT
;AX>=25?
CASE1:
    MOV     COPY,AX      ;store the current AX
    CMP     AX,DIV25
    JGE     QUARTERS    ;yes,continue to calculate quarter numbers
    LEA     DX,MSGQ0    ;no,print out zero for quarters then proceed to case2
    MOV     AH,9
    INT     21H
    MOV     AX,COPY     ;AX hasn't change, still the original input
    JMP     CASE2
;calculate quarters
QUARTERS:
    MOV     DX,0D
    IDIV    DIV25
    MOV     REM,DX    
    MOV     QUO,AX
;output
    LEA     DX,MSGQ1
    MOV     AH,9
    INT     21H
    MOV     AX,QUO      ;the number to print out
    CALL 	OUTDEC
    MOV     AX,REM      ;update AX -> remainder from the previous case
;AX>=10?
CASE2:
    MOV     COPY,AX
    CMP     AX,DIV10
    JGE     DIMES
    LEA     DX,MSGD0
    MOV     AH,9
    INT     21H
    MOV     AX,COPY
    JMP     CASE3
;calculate dimes
DIMES:
    MOV     DX,0D
    IDIV    DIV10
    MOV     REM,DX    
    MOV     QUO,AX
;output
    LEA     DX,MSGD1
    MOV     AH,9
    INT     21H
    MOV     AX,QUO
    CALL 	OUTDEC
    MOV     AX,REM
;AX>=5?
CASE3:
    MOV     COPY,AX
    CMP     AX,DIV5
    JGE     NICKLES
    LEA     DX,MSGN0
    MOV     AH,9
    INT     21H
    MOV     AX,COPY
    JMP     CASE4
;calculate nickles
NICKLES:
    MOV     DX,0D
    IDIV    DIV5
    MOV     REM,DX    
    MOV     QUO,AX
;output
    LEA     DX,MSGN1
    MOV     AH,9
    INT     21H
    MOV     AX,QUO
    CALL 	OUTDEC
    MOV     AX,REM
;AX>=1?
CASE4:
    MOV     COPY,AX
    CMP     AX,DIV1
    JGE     PENNIES
    LEA     DX,MSGP0
    MOV     AH,9
    INT     21H
    INC     CX
    MOV     AX,COPY
    JMP     END_
;calculate pennies
PENNIES:
    MOV     DX,0D
    IDIV    DIV1
    MOV     REM,DX    
    MOV     QUO,AX
;output
    LEA     DX,MSGP1
    MOV     AH,9
    INT     21H
    MOV     AX,QUO
    CALL 	OUTDEC
    INC     CX
END_:
    MOV     AH,2            ;go to a new line
    MOV     DL,0DH
    INT     21H
    MOV     DL,0AH
    INT     21H
    JMP     REPEAT_
EXIT:
;return to DOS    
    MOV     AH,4CH      ;DOS exit function
    INT     21H         ;exit to DOS
MAIN    ENDP
INCLUDE PGM9_1.ASM
INCLUDE PGM9_3a.ASM
        END     MAIN