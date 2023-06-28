.bss
.comm precyzja, 8
.comm poczatekCalkowania, 8
.comm koniecCalkowania, 8
.comm suma, 8
.comm _dx, 8
.comm input, 8
.comm xp, 8
.comm i, 8
.comm dx, 8
.comm result, 8
.comm temp, 8

.data
cztery: .float 4
siedem: .float 7

.text
.global calka

.type calka, @function

calka:
        pushq %rbp
        movq %rsp, %rbp

        movq $0, %rsi
        movq %rdi, precyzja(,%rsi,4)	
        movss %xmm0, poczatekCalkowania      		
        movss %xmm1, koniecCalkowania        		

        flds koniecCalkowania        			#xk
        fsub poczatekCalkowania      			#(xk - xp)
        fidiv precyzja      				#((xk - xp)/n

        fstps _dx       			


        fldz    				

        petla:
                movss poczatekCalkowania, %xmm0    
                        			
                movss _dx, %xmm1        	

	        movq %rdi, precyzja(,%rsi,4)
	        movss %xmm0, xp
	        movss %xmm1, dx

	        fild precyzja                   # i
	        fmul dx                         # i*dx
	        fadd xp                         # xp + i*dx

		fstps result
	        movss result, %xmm0            

		movss %xmm0, input  

	        flds input
	        fmul input              # x^2
	        fmul input              # x^3
	        fdiv siedem             # x^3/7
	        fadd cztery             # ( 1/7 * x^3 ) + 4

        fstps result            

        movss result, %xmm0     


                movss %xmm0, result

                fadd result     	

                dec %rdi        		
                cmp $0, %rdi    			
                je koniec
                jmp petla

        koniec:    

                fmul _dx
                fstps result    
                movss result, %xmm0

                movq %rbp, %rsp
                popq %rbp
                ret


