matmul:

   push dword 0       ; w32FrStck(9) - local placeholder for the element to be inserted into matrixC
   push dword l       ; w32FrStck(8) - 300
   push dword n       ; w32FrStck(7) - 50
   push dword m       ; w32FrStck(6) - 500
   push dword matrixC ; w32FrStck(5) - memory address of matrixC
   push dword matrixB ; w32FrStck(4) - memory address of matrixB
   push dword matrixB ; w32FrStck(3) - memory address of matrixB
   push dword matrixA ; w32FrStck(2) - memory address of matrixA
   push dword matrixA ; w32FrStck(1) - memory address of matrixA
   push dword matrixB ; w32FrStck(0) - memory address of matrixB

matrixmul:
   ;first section
                           ; We will refer to w32FrStck(x) as stack(x).
   mov edx, w32FrStck(2)   ; moving the matrixA address into the edx register.
   mov ecx, w32FrStck(4)   ; moving the matrixB address into the edx register.
   mov eax, [edx]          ; moving the value from the matrixA address into the eax register. the first element of matrixA.
   mov ebx, [ecx]          ; moving the value from the matrixB address into the eax register. the first element of matrixB.
   mul ebx                 ; multiplying the ebx register with the eax register. The first element of both matrixes.

   mov edx, w32FrStck(9)   ; moving the value 0 from the stack(9) into the edx register.
   add edx, eax            ; adding the eax register to the edx register. adding the product of the element in matrixA                        ; and matrixB.
   mov w32FrStck(9), edx   ; moving the edx into stack(9). Updating the stack with the added value.

   mov edx, w32FrStck(2)   ; moving stack(2) into edx register. Preparing to update the adress to matrixA to point
   add edx, 4              ; to the next element in the row
   mov w32FrStck(2), edx   ; updating the stack(2) with the new address

   mov edx, w32FrStck(4)   ; moving stack(4) into edx register. Preparing to update the adress to matrixB to point to
   add edx, 500*4          ; the next element in the first column.
   mov w32FrStck(4),edx    ; updating the stack(4) with the new matrixB address.

                           ; will refer to the registers only as eax,ebx,ecx and edx from now on.
   
   mov ecx, w32FrStck(7)   ; moving stack(7) into the ecx. Preparing to run the first section 50 times.
   dec ecx                 ; decrement ecx. the value n. The number of elements in the first row in matrixA.
   mov w32FrStck(7), ecx   ; updating the stack(7) with the new value
   cmp ecx, 0              ; comparing the value to 0 and 
   jg matrixmul            ; jumping back to matrixmul if greater than 0

   ;the section/loop above multiplies all the elements in the first row of matrixA with all the elements in the first column
   ;of matrixB, adding all products together and storing them into the stack(9).

   ;next section
   mov eax, w32FrStck(9)   ; moving stack(9) into the eax. the value to be stored into matrixC.

   mov edx, w32FrStck(5)   ; moving stack(5) into the edx. 
   add [edx], eax          ; adding eax into [edx]. when using brackets it adds into the value of the address. 
                           ; adding the next element into matrixC
   add edx, 4              ; adding 4 to edx. Increasing the memory address by 4 to prepare for the next input
   mov w32FrStck(5),edx    ; updating the stack(5) with the new memory address for matrixC.

   mov eax, 0              ; setting the eax to 0.
   mov w32FrStck(9), eax   ; setting stack(9) to 0. resetting the placeholder for elements to be put into matrixC

   mov edx, w32FrStck(1)   ; moving stack(1) into edx. A "fresh" matrixA address.
   mov w32FrStck(2), edx   ; updating stack(2) with the matrixA address pointing to the first element.

   mov edx, w32FrStck(3)   ; moving stack(3) into edx. A "fresh" matrixB address.
   mov w32FrStck(4), edx   ; updating stack(4) with the matrixB address pointing to the first element.
   add edx, 4              ; adding 4 to edx. Making matrixB point to the next element in the next column.
   mov w32FrStck(4),edx    ; updating stack(4) with the new matrixB address
   mov w32FrStck(3),edx    ; updating stack(3) with the new matrixB address

   mov ecx, n              ; moving the value 50 (from n) into ecx. Preparing to reset the counter used in the first section
   mov w32FrStck(7), ecx   ; moving ecx into stack(7). resetting the counter used in the first loop.

   mov ecx, w32FrStck(6)   ; moving stack(6) into ecx. the value m = 500. The number of columns in matrixB.
   dec ecx                 ; decreasing ecx by 1
   mov w32FrStck(6), ecx   ; updating stack(6) after decrementation
   cmp ecx, 0              ; comparing ecx with 0 and
   jg matrixmul            ; jumping back to matrixmul if greater than 0.

   ; the section/loop above multiplies the first row of matrixA with the next columns of matrixB.

   ;last section
   mov edx, w32FrStck(0)   ; moving stack(0) into edx. A "fresh" matrixB address.
   mov w32FrStck(4), edx   ; updating both stacks with the "fresh" one.
   mov w32FrStck(3), edx   ; 

   mov edx, w32FrStck(2)   ; moving stack(2) into edx. The address of the first element in matrixA.
   add edx, 50*4           ; adding 50*4 to reach the first element in the next row of matrixA.
   mov w32FrStck(2), edx   ; updating stack(2) and stack(1) with the new matrixA address.
   mov w32FrStck(1), edx   ; 

   mov edx, m              ; setting edx to 300
   mov w32FrStck(6), edx   ; updating stack(6) with 300
   mov ecx,  w32FrStck(8)  ; moving stack(8) into ecx. the value l = 300. The number of rows in matrixA.
   dec ecx                 ; decreasing ecx by 1
   mov  w32FrStck(8), ecx  ; updating stack(8) after decrementation
   cmp ecx, 0              ; jumping back to matrixmul if greater than 0.
   jg matrixmul

   ; the last section/loop multiplies the next rows of matrixA with all the columns of matrixB.

   ; in total the iterations will be 50*500*300 = 7.5million

   ; cleaning up the stack to prevent segmentation error after ret

   pop eax  ; pop w32FrStck(0)   matrixB
   pop eax  ; pop w32FrStck(1)   matrixA
   pop eax  ; pop w32FrStck(2)   matrixA
   pop eax  ; pop w32FrStck(3)   matrixB
   pop eax  ; pop w32FrStck(4)   matrixB
   pop eax  ; pop w32FrStck(5)   matrixC
   pop eax  ; pop w32FrStck(6)   m
   pop eax  ; pop w32FrStck(7)   n
   pop eax  ; pop w32FrStck(8)   l
   pop eax  ; pop w32FrStck(9)   acc

   ret