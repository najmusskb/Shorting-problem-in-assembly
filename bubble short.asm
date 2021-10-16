 .MODEL SMALL
 .STACK 100H

 .DATA
    PROMPT_1  DB  \'The contents of the array before sorting : $\'
    PROMPT_2  DB  0DH,0AH,\'The contents of the array after sorting : $\'

    ARRAY   DB  5,3,9,0,2,6,1,7,8,4   

 .CODE
   MAIN PROC
     MOV AX, @DATA                ; initialize DS
     MOV DS, AX

     MOV BX, 10                   ; set BX=10

     LEA DX, PROMPT_1             ; load and display the string PROMPT_1
     MOV AH, 9
     INT 21H

     LEA SI, ARRAY                ; set SI=offset address of ARRAY

     CALL PRINT_ARRAY             ; call the procedure PRINT_ARRAY

     LEA SI, ARRAY                ; set SI=offset address of the ARRAY

     CALL BUBBLE_SORT             ; call the procedure BUBBLE_SORT

     LEA DX, PROMPT_2             ; load and display the string PROMPT_2
     MOV AH, 9
     INT 21H

     LEA SI, ARRAY                ; set SI=offset address of ARRAY

     CALL PRINT_ARRAY             ; call the procedure PRINT_ARRAY

     MOV AH, 4CH                  ; return control to DOS
     INT 21H
   MAIN ENDP



 ;-------------------------  Procedure Definitions  ------------------------;




 ;-----------------------------  PRINT_ARRAY  ------------------------------;


 PRINT_ARRAY PROC
   ; this procedure will print the elements of a given array
   ; input : SI=offset address of the array
   ;       : BX=size of the array
   ; output : none

   PUSH AX                        ; push AX onto the STACK   
   PUSH CX                        ; push CX onto the STACK
   PUSH DX                        ; push DX onto the STACK

   MOV CX, BX                     ; set CX=BX

   @PRINT_ARRAY:                  ; loop label
     XOR AH, AH                   ; clear AH
     MOV AL, [SI]                 ; set AL=[SI]

     CALL OUTDEC                  ; call the procedure OUTDEC

     MOV AH, 2                    ; set output function
     MOV DL, 20H                  ; set DL=20H
     INT 21H                      ; print a character

     INC SI                       ; set SI=SI+1
   LOOP @PRINT_ARRAY              ; jump to label @PRINT_ARRAY while CX!=0

   POP DX                         ; pop a value from STACK into DX
   POP CX                         ; pop a value from STACK into CX
   POP AX                         ; pop a value from STACK into AX

   RET                            ; return control to the calling procedure
 PRINT_ARRAY ENDP


 ;----------------------------  BUBBLE_SORT  -------------------------------;


 BUBBLE_SORT PROC
   ; this procedure will sort the array in ascending order
   ; input : SI=offset address of the array
   ;       : BX=array size
   ; output : none

   PUSH AX                        ; push AX onto the STACK  
   PUSH BX                        ; push BX onto the STACK
   PUSH CX                        ; push CX onto the STACK
   PUSH DX                        ; push DX onto the STACK
   PUSH DI                        ; push DI onto the STACK

   MOV AX, SI                     ; set AX=SI
   MOV CX, BX                     ; set CX=BX
   DEC CX                         ; set CX=CX-1

   @OUTER_LOOP:                   ; loop label
     MOV BX, CX                   ; set BX=CX

     MOV SI, AX                   ; set SI=AX
     MOV DI, AX                   ; set DI=AX
     INC DI                       ; set DI=DI+1

     @INNER_LOOP:                 ; loop label 
       MOV DL, [SI]               ; set DL=[SI]

       CMP DL, [DI]               ; compare DL with [DI]
       JNG @SKIP_EXCHANGE         ; jump to label @SKIP_EXCHANGE if DL<[DI]

       XCHG DL, [DI]              ; set DL=[DI], [DI]=DL
       MOV [SI], DL               ; set [SI]=DL

       @SKIP_EXCHANGE:            ; jump label
       INC SI                     ; set SI=SI+1
       INC DI                     ; set DI=DI+1

       DEC BX                     ; set BX=BX-1
     JNZ @INNER_LOOP              ; jump to label @INNER_LOOP if BX!=0
   LOOP @OUTER_LOOP               ; jump to label @OUTER_LOOP while CX!=0

   POP DI                         ; pop a value from STACK into DI
   POP DX                         ; pop a value from STACK into DX
   POP CX                         ; pop a value from STACK into CX
   POP BX                         ; pop a value from STACK into BX
   POP AX                         ; pop a value from STACK into AX

   RET                            ; return control to the calling procedure
 BUBBLE_SORT ENDP


 ;--------------------------------  OUTDEC  --------------------------------;


 OUTDEC PROC
   ; this procedure will display a decimal number
   ; input : AX
   ; output : none

   PUSH BX                        ; push BX onto the STACK
   PUSH CX                        ; push CX onto the STACK
   PUSH DX                        ; push DX onto the STACK

   XOR CX, CX                     ; clear CX
   MOV BX, 10                     ; set BX=10

   @OUTPUT:                       ; loop label
     XOR DX, DX                   ; clear DX
     DIV BX                       ; divide AX by BX
     PUSH DX                      ; push DX onto the STACK
     INC CX                       ; increment CX
     OR AX, AX                    ; take OR of Ax with AX
   JNE @OUTPUT                    ; jump to label @OUTPUT if ZF=0

   MOV AH, 2                      ; set output function

   @DISPLAY:                      ; loop label
     POP DX                       ; pop a value from STACK to DX
     OR DL, 30H                   ; convert decimal to ascii code
     INT 21H                      ; print a character
   LOOP @DISPLAY                  ; jump to label @DISPLAY if CX!=0

   POP DX                         ; pop a value from STACK into DX
   POP CX                         ; pop a value from STACK into CX
   POP BX                         ; pop a value from STACK into BX

   RET                            ; return control to the calling procedure
 OUTDEC ENDP





 END MAIN