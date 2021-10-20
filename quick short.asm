TITLE 'extern "C" void __stdcall qisort(int array[], const unsigned int size);'

;void __stdcall qisort(int array[], const unsigned int size) {
;	if (size > 30) {
;		int pivot = array[size / 2];
;		int *left = array;
;		int *right = array + size - 1;
;		while (1) {
;			while ((left <= right) && (*left < pivot)) left++;
;			while ((left <= right) && (*right > pivot)) right--;
;			if (left > right) break;
;			int temp = *left;
;			*left++ = *right;
;			*right-- = temp;
;		}
;		qisort(array, right - array + 1);
;		qisort(left, array + size - left);
;	}
;	else {
;		for (unsigned int i = 1; i < size; ++i) {
;			int temp = array[i];
;			unsigned int j = i;
;			while (j > 0 && temp < array[j - 1]) {
;				array[j] = array[j - 1];
;				j--;
;			}
;			array[j] = temp;
;		}
;	}
;}

.386P

.model FLAT

PUBLIC	_qisort@8

QISORT	SEGMENT
_MAX_ISORT_SIZE = 30
_qisort@8 PROC NEAR

push  ebx
push  ebp

;if (size > 30) {

mov  ebp, DWORD PTR [esp+12] ; array
push esi
push edi
mov  edi, DWORD PTR [esp+24] ; size
cmp  edi, _MAX_ISORT_SIZE
jbe  SHORT insertion_sort

quick_sort:

;	int pivot = array[size / 2];

mov  eax, edi
shr  eax, 1
mov  edx, DWORD PTR [ebp+eax*4]

;	int *left = array;
;	int *right = array + size - 1;

shl  edi, 2
mov  esi, ebp
lea  eax, DWORD PTR [edi+ebp-4]

quick_sort_loop:

;	while (1) {
;		while ((left <= right) && (*left < pivot)) left++;

cmp  esi, eax
ja   SHORT label5
  
label1:

cmp  DWORD PTR [esi], edx
jge  SHORT label2
add  esi, 4
cmp  esi, eax
ja   SHORT label5
jmp  SHORT label1
  
label2:

;		while ((left <= right) && (*right > pivot)) right--;

cmp  esi, eax
ja   SHORT label5

label3:

cmp  DWORD PTR [eax], edx
jle  SHORT label4
sub  eax, 4
cmp  esi, eax
ja   SHORT label5
jmp  SHORT label3

label4:

;		if (left > right) break;

cmp  esi, eax
ja   SHORT label5

;		int temp = *left;
;		*left++ = *right;

mov  ebx, DWORD PTR [eax]
mov  ecx, DWORD PTR [esi]
mov  DWORD PTR [esi], ebx
add  esi, 4

;		*right-- = temp;

mov  DWORD PTR [eax], ecx
sub  eax, 4
jmp  SHORT quick_sort_loop

label5:

;	}
;	qisort(array, right - array + 1);

sub  eax, ebp
sar  eax, 2
inc  eax
push eax
push ebp
call _qisort@8

;	qisort(left, array + size - left);

sub  edi, esi
add  edi, ebp
sar  edi, 2
cmp  edi, _MAX_ISORT_SIZE
mov  ebp, esi
ja   SHORT quick_sort

;}
;else {

insertion_sort:

;	for (unsigned int i = 1; i < size; ++i) {

mov  esi, 1
cmp  edi, esi
jbe  SHORT label10
lea  ecx, DWORD PTR [ebp+4]
mov  DWORD PTR 8+[esp+12], ecx

label6:

;		unsigned int j = i;
;		while (j > 0 && temp < array[j - 1]) {

test esi, esi
mov  ebx, DWORD PTR [ecx]
mov  eax, esi
jbe  SHORT label9

;			int temp = array[i];

add  ecx, -4

label7:

;		unsigned int j = i;
;		while (j > 0 && temp < array[j - 1]) {

mov  edx, DWORD PTR [ecx]
cmp  ebx, edx
jge  SHORT label8

;			array[j] = array[j - 1];

mov  DWORD PTR [ecx+4], edx

;			j--;

dec  eax
sub  ecx, 4
test eax, eax
ja   SHORT label7

label8:

;		unsigned int j = i;
;		while (j > 0 && temp < array[j - 1]) {

mov  ecx, DWORD PTR 8+[esp+12]

label9:

;	}
;	else {
;		for (unsigned int i = 1; i < size; ++i) {

inc  esi
add  ecx, 4
cmp  esi, edi

;	}
;	array[j] = temp;

mov  DWORD PTR [ebp+eax*4], ebx
mov  DWORD PTR 8+[esp+12], ecx
jb   SHORT label6

label10:

pop  edi
pop  esi
pop  ebp
pop  ebx

ret  8

_qisort@8 ENDP
QISORT	ENDS
END
