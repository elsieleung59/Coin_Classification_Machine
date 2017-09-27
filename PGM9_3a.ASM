  INDEC1   PROC
  ;modified PGM9_3, does not generate prompt character
  ;reads a decimal number in range -32768 to 32767
  ;terminates when encounters a non-digit character
  ;non-digit character is returned in DL
  ;input: none
  ;output: AX = binary equivalent of number
  ;        DH = number of digits read
  ;        DL = terminating character
           PUSH    BX             ;save registers used            
           PUSH    CX      
 ;total = 0
          XOR     BX,BX           ;BX holds total 
 ;negative = false
          XOR     CX,CX           ;CX holds sign
 ;clear counter
          XOR     DX,DX
 ;read a character
          MOV     AH,1
          INT     21H             ;character in AL
 ;case character of
          CMP     AL,'-'          ;minus sign?
          JE      @MINUS          ;yes, set sign
          CMP     AL,'+'          ;plus sign?
          JE      @PLUS           ;yes, get another char
          JMP     @REPEAT2        ;start processing chars
 @MINUS:
          MOV     CX,1            ;negative = true
 @PLUS:
          INT     21H             ;read a char
 ;end_case
 @REPEAT2:
 ;if character is between '0' and '9'
          CMP     AL,'0'          ;chat >= '0'?
          JNGE    @NON_DIGIT      ;non-digit
          CMP     AL,'9'          ;char <= '9'?
          JNLE    @NON_DIGIT      ;non-digit
 ;then increment counter and convert character to a digit
          INC     DH              ;increment digit count
          AND     AX,000FH        ;convert to digit
 ;total = total * 10 + digit
          IMUL    BX,10           ;BX = total * 10
          ADD     BX,AX           ;total = total * 10 + digit
 ;read a character
          MOV     AH,1
          INT     21H     
          JMP     @REPEAT2        ;keep going
 ;encounter non-digit, end of number
 @NON_DIGIT:
          MOV     DL,AL           ;store character in DL
          MOV     AX,BX           ;store number in AX
 ;if negative
          OR      CX,CX           ;negative number?
          JE      @EXIT           ;no, exit
 ;then
          NEG     AX              ;yes, negate
 ;end_if
 @EXIT:
          POP     CX              ;restore registers
          POP     BX
          RET                     ;and return
 INDEC1   ENDP