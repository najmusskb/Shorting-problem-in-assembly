include Irvine32.inc

; Constants
    NUM_INTEGERS = 20
    NUM_RANGE = 99d
    TO_ENSURE_NOT_ZERO = 1d

.data
; Declare Arrays
; Declare Array of 20 Integers
    array byte NUM_INTEGERS dup(?)

; Displayed Annotation for Unsorted Array
    unsortedArrayText byte "Randomly Generated Array, Unsorted: ", 0dh, 0ah, 0

; Displayed Annotation for Sorted Array
    sortedArrayText byte "Randomly Generated Array, Sorted from Lowest to Highest: ", 0dh, 0ah, 0

.code
main PROC
; Get Random Values for Array
    call fillArrayRandomly

; Display Array with Annotation
    mov edx, offset unsortedArrayText
    call WriteString

    mov ecx, offset array
    push ecx
    call displayArray

; Sort Array
    mov esi, offset array
    mov ecx, NUM_INTEGERS
    call findMinimum

    mov edi, offset array
    mov ecx, NUM_INTEGERS
    call selectionSort

; Display Sorted Array with Annotation
    mov edx, offset sortedArrayText
    call WriteString

    mov ecx, offset array
    push ecx
    call displayArray

; Exit Program
    exit
main endp

; Fill Array with Random Values
fillArrayRandomly PROC
; Set Counter to NUM_INTEGERS and Index to 0
    mov eax, 0
    mov ecx, NUM_INTEGERS
    mov esi, 0

getRandomNumber:
; Fill Array with Random Numbers and Increment ESI for Offset
    mov ah, NUM_RANGE
    call RandomRange
    add ah, TO_ENSURE_NOT_ZERO

testUniqueness:
    mov al, array [esi]
    cmp al, ah
    jne uniqueNumber
    loop getRandomNumber

uniqueNumber:
    mov array [esi], ah
    inc esi
    loop getRandomNumber

    ret
fillArrayRandomly ENDP

; Display Array
displayArray PROC
    pushad
    mov eax, 0
    mov ecx, NUM_INTEGERS
    mov esi, 0

display:
    mov al, array[esi]
    call WriteDec
    mov al, TAB
    call WriteChar
    inc esi
    loop display

    popad
    call Crlf
    ret
displayArray ENDP

; Selection Sort
selectionSort PROC
    dec ecx
    mov ebx, edi
    mov edx, ecx

startOuterLoop:
    mov edi, ebx
    mov esi, edi
    inc esi
    push ecx
    mov ecx, edx

startInnerLoop:
    mov al, [esi]
    cmp al, [edi]
    pushf
    inc esi
    inc edi
    popf
    jae doNotSwap
    call swap

doNotSwap:
    loop startInnerLoop
    pop ecx
    loop startOuterLoop

    ret
selectionSort ENDP

; Find Minimum Index
findMinimum PROC
    mov edi, esi

minimumIndex:
    mov al, [esi]
    cmp al, [edi]
    jae skip
    mov edi, esi

skip: 
    inc esi
    loop minimumIndex

    ret
findMinimum ENDP

; Swap
swap PROC
    mov al, [esi - 1]
    mov ah, [edi - 1]
    mov [esi - 1], ah
    mov [edi - 1], al

    ret
swap ENDP

END main