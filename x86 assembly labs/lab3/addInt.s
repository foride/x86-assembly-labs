# Created by foride
# The program adds integers by itself (performs 32bit addition each time) and
# takes care of possible overflow ( overflow storaged in overflow label )
.data
  # Declaring four values, 4 bytes each
  values: .long 0xfA3B4CD8, 0x121134FF, 0xABCDEF12, 0x7FFFFFFF
  # Calculates a number of bytes occupied by the values array
  values_len = .-values
  # Calculates how many 32 bit integers in the array
  quantity = values_len / 4 

.bss

  overflow: .skip values_len
  result: .skip values_len

.text

.global _start

_start:
	# loop index ( used also as result and overflow index )
	movl $quantity, %ecx

add_loop:

	dec %ecx

	movl values(, %ecx, 4), %eax
	adcl values(, %ecx, 4), %eax
	jc integer_overflow
	movl %eax, result(, %ecx, 4)

	cmp $0, %ecx
	jz print
	jmp add_loop	#powrot na poczatek petli

integer_overflow:

	movl %eax, result(, %ecx, 4)
        movl $1, overflow( , %ecx, 4)
        
	cmp $0, %ecx
	jz print
	jmp add_loop

print:
  mov $4, %ecx
  print_loop:

        dec %ecx
        movl result( , %ecx, 4), %eax
        movl overflow( , %ecx, 4), %ebx

        cmp $0, %ecx
        je end
        jmp print_loop

end:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
