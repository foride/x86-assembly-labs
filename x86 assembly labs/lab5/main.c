#include <stdio.h>

float calka(int n, float xp, float xk);

int main(void){
	
	int precyzja;
	float A, B;
	
	printf("Wpisz wartosc n: \n");
	scanf("%d", &precyzja);
	printf("wpisz wartodsc A: \n");
	scanf("%f", &A);
	printf("Wpisz wartosc B: \n");
	scanf("%f", &B);

 	float calka_result = calka(precyzja, A, B);

    printf("Wynik calki FPU:\t%f, calka_result);

	return 0;
}
