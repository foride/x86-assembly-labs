# Created by foride
# The program adds integers by itself (performs 64bit addition each time) and
# takes care of possible overflow
.data
  # Declaring 64 bit value located on 8 eight bytes memory addresses
  value: .long 0x80000000 ,0x80000000 ,0x80000000, 0x80000000, 0x80000000, 0x80000000, 0x80000000, 0x80000000
  # Calculates a number of bytes occupied by the value array
  values_len = .-value
  # Memory space needed for the result of addition the value ( possible overflows)
  bytes_needed = values_len + 4
  # Calculates how many memory locations belonging to the array
  quantity = values_len / 4 
  result_quantity = bytes_needed / 4

.bss

  result: .skip bytes_needed

.text

.global _start

_start:
	# loop index ( used also as result and overflow index )
	movl $quantity, %ecx
	movl $result_quantity, %ebx

add_loop:

	dec %ecx
	dec %ebx

	movl value(, %ecx, 4), %eax
	adcl value(, %ecx, 4), %eax
	jc integer_overflow
	adcl %eax, result(, %ebx, 4)
	
	jmp is_finish

integer_overflow:

	addl %eax, result(, %ebx, 4)
	dec %ebx
        adcl $1, result( , %ebx, 4)
	inc %ebx

	jmp is_finish

is_finish:

	cmp $0, %ecx
        jz print
        jmp add_loop


print:
  mov $result_quantity, %ecx
  print_loop:

        dec %ecx
        movl result( , %ecx, 4), %eax

        cmp $0, %ecx
        je end
        jmp print_loop

end:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
