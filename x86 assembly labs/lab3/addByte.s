# Created by foride
# The program adds integers by itself, looping through each integer byte and adding them
# separately with potential overflow handle

.data
  # Declaring four values, 4 bytes each
  values: .long 0xFDA32123, 0x705F4F5F, 0x7F051234, 0xFFAD6A50
  # Calculates a number of bytes occupied by the values array
  values_len = .-values
  # Calculates how many 32 bit integers in the array
  quantity = values_len / 4 
  
.bss
  # Allocate 16 bytes for the result of addition and possible overflow ( 4 bytes for each value)
  result: .skip values_len
  overflow: .skip values_len

.text

  .global _start

_start:
  # %ecx is an index of values memory and the loop index simultaneously
  mov $values_len, %ecx
  jmp loop

loop:
  dec %ecx
  # add a byte value with itself, with carry
  movsbl values( , %ecx, 1), %eax
  adcb values( , %ecx, 1), %al
  # if the eigth bit of byte overflows, jump
  jc byte_overflow
  # if not, add with carry to result memory location and jump to finish
  adcb %al, result( , %ecx, 1)
  jmp finish

# checks if loop counter is 0, if so jumps to _print, else jumps to loop
finish:
  cmp $0, %ecx
  je _print
  jmp loop


  byte_overflow:
	# adds with carry the value to the result
	adcb %al, result( , %ecx, 1)
	# checks whether the %ecx register is on the most signifcant byte
	mov %ecx, %edx
	inc %edx     
	andl $3, %edx        # Bitwise AND with 3 to mask the least significant 2 bits
	# if %edx is 0 then the value in the %edx register is divisible by 4 (%ecx on the most signifcant byte)
	cmpl $0, %edx
	# jump to integer (4 byte number) overflow handle label
	je integer_overflow 
	# if not the MSB, add the overflow ( value = 1 ) to more signicant byte
	adcb $1, result( , %edx, 1)
	# if overflow after the addition jump to 
	jc overflow_loop
	jmp finish

  integer_overflow:
	# checks the %ecx to see in which integer the overflow happend and whether it is the MSB
	mov %ecx, %edx
        inc %edx
	shrl $2, %edx       # Logical right shift %edx by 2 bits ( divides the value in %edx by 4 )
	dec %edx
	addl $1, overflow( , %edx, 4)
	jmp finish

  overflow_loop:
	# if the byte after the addition have overflowed ( the byte = 0 ) 
	# add with carry 1 to more signifcant byte and repeat
	mov result( , %edx, 1) , %ebx
	cmp $0, %ebx
	jne finish
	inc %edx
	andl $3, %edx        # Bitwise AND with 3 to mask the least significant 2 bits
        # if %edx is 0 then the value in the %edx register is divisible by 4 (%ecx on the most signifcant byte)
        cmpl $0, %edx
        # jump to integer (4 byte number) overflow handle label
        je integer_overflow

	adcb $1, result( , %edx, 1)
	jmp overflow_loop
	
_print:
  mov $4, %ecx
  _print_loop:
	
	dec %ecx

	movl result( , %ecx, 4), %eax
	movl overflow( , %ecx, 4), %ebx

	cmp $0, %ecx
	je _end
	jmp _print_loop
	
_end:
  
  mov $1, %eax
  mov $0, %ebx
  int $0x80
