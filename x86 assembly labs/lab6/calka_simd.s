.bss
.comm   poczatekCalkowania,  4  
.comm   koniecCalkowania,    4  
.comm   dx,     16    
.comm   poczatekV  16     
.comm   wynikV  16      

.data
wysokosciStart: .float  1, 2, 3, 4   
jedynki: .float 1, 1, 1, 1
zera:  .float  0, 0, 0, 0     
czworki: .float 4, 4, 4, 4	
siodemki: .float 7, 7, 7, 7		

.text
.global calka_simd
.type calka_simd, @function

calka_simd:

        pushq %rbp
        movq %rsp, %rbp  

        movss %xmm0, poczatekCalkowania     
        movss %xmm1, koniecCalkowania       
        cvtsi2ss %rdi, %xmm0    	 

   
        subss poczatekCalkowania, %xmm1     
        divss %xmm0, %xmm1      	   

	// dx zapisana na 4 pozycjach dla przyszłego przyspieszenia
	 

        movq $0, %rsi          			 # iterator po wektorze dx
        KopiowanieDX:
                movss %xmm1, dx(,%rsi,4)         # kopiowanie dx na kolejne pozycje
                inc %rsi
                cmp $4, %rsi
                je Dalej
                jmp KopiowanieDX

        Dalej:
                movups dx, %xmm1        	
	

        movq $0, %rsi           	
        movss poczatekCalkowania, %xmm2 
        Wektory:
                movss %xmm2, poczatekV(,%rsi,4) 

                inc %rsi
                cmp $4, %rsi
                je Dalej2
                jmp Wektory


        Dalej2: 

                movups poczatekV, %xmm2
                movups wysokosciStart, %xmm3
		

        shrq $2, %rdi           
        movups zera, %xmm0     		
        Petla:
	
		movups zera, %xmm4
       		addps %xmm3, %xmm4
       		mulps %xmm1, %xmm4
       		addps %xmm2, %xmm4      # %xmm4 = [xp + i*dx]
	     
		movups zera, %xmm5
	        addps %xmm4, %xmm5
	        movups %xmm5, %xmm6
	        mulps %xmm5, %xmm5      # [x,...,x]^2
	        mulps %xmm6, %xmm5      # [x,...,x]^3
	        movups siodemki, %xmm6
	        divps %xmm6, %xmm5      # [x,...,x]^3 / 7
	        movups czworki, %xmm6
	        addps %xmm6, %xmm5      # [x,...,x]^3 / 7 + 4
	        movups zera, %xmm6
          

                movups czworki, %xmm6   
                addps %xmm6, %xmm3      

                addps %xmm5, %xmm0     # suma (xmm0) += biezaca iteracja

                dec %rdi
                cmp $0, %rdi
                je Koniec
                jmp Petla

        Koniec:

                mulps %xmm1, %xmm0  
                movq $0, %rsi   
                movups %xmm0, wynikV  
                movups zera, %xmm0     
                Sumowanie:
                        addss wynikV(,%rsi,4), %xmm0  
                        inc %rsi
                        cmp $4, %rsi
                        je Wynik
                        jmp Sumowanie

        Wynik:

		movq %rbp, %rsp
                popq %rbp
                ret



