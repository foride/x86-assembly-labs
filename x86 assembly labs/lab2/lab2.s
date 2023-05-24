# Created by foride
# The program reads the input from the user, reverses the whole input then converts
# upper letters to small letters and conversely, also converts decimal digits to space chars

.data
  SYS_EXIT = 1
  SYS_WRITE = 4
  SYS_READ = 3
  STDIN = 0
  STDOUT = 1
  EXIT_SUCCES = 0

  bufferSize = 2048
  textLength: .long 0

.bss

  .comm input, bufferSize
  .comm reversed, bufferSize
  .comm converted, bufferSize

.text

  .global _start

_start:
  call _read_word
  call _reverseWord
  call _convert_to_upper_case
  call _end

_read_word:

  movl $SYS_READ, %eax
  movl $STDIN, %ebx
  movl $input, %ecx
  movl $bufferSize, %edx
  int $0x80

  movl %eax, textLength
  ret

_reverseWord:

  mov textLength, %edx
  dec %edx
  dec %edx
  mov $0, %ebx
  
  _reverseLoop:

	mov input( , %edx, 1), %ah
	mov %ah, reversed( , %ebx, 1)
	cmp $0, %edx
	je _endReverse
	dec %edx
	inc %ebx
	jmp _reverseLoop

  _endReverse:
	
	ret
	
_convert_to_upper_case:
  movl $0, %edi

  _loop:
    cmpl %edi, textLength
    je _print_converted_word
    movb reversed(, %edi, 1), %ah
    cmpb $97, %ah
    jb _isUpperCase
    cmpb $122, %ah
    ja _write_leter_to_output
    subb $32, %ah
    jmp _write_leter_to_output

_isUpperCase:
	
	cmpb $65, %ah
	jb _isDigit
	cmpb $90, %ah
	ja _write_leter_to_output
	addb $32, %ah
	jmp _write_leter_to_output

_isDigit:

	cmpb $48, %ah
	jb _write_leter_to_output
	cmpb $57, %ah
	ja _write_leter_to_output
	mov $32, %ah
	jmp _write_leter_to_output

_write_leter_to_output:
  movb %ah, converted(, %edi, 1)
  incl %edi
  jmp _loop

_print_converted_word:
  # adds new line at the end of the text output
  mov textLength, %eax
  dec %eax
  movb $10, converted( , %eax, 1)

  movl $SYS_WRITE, %eax
  movl $STDOUT, %ebx
  movl $converted, %ecx
  movl textLength, %edx
  int $0x80
  ret

_end:

  movl $SYS_EXIT, %eax
  movl $EXIT_SUCCES, %ebx
  int $0x80

