#include <stdio.h>

float calka(int n, float xp, float xk);
float calka_simd(int n, float xp, float xk);
unsigned long long int rdtsc(char n);

int main(void){
	
	int precyzja;
	float A, B;
	
	printf("Wpisz wartosc n: \n");
	scanf("%d", &precyzja);
	printf("wpisz wartodsc A: \n");
	scanf("%f", &A);
	printf("Wpisz wartosc B: \n");
	scanf("%f", &B);


	unsigned long long int calka_start = rdtsc(1);
 	float calka_result = calka(precyzja, A, B);
	unsigned long long int calka_end = rdtsc(1);

	unsigned long long int calka_simd_start = rdtsc(1);
 	float calka_simd_result = calka_simd(precyzja, A, B);
	unsigned long long int calka_simd_end = rdtsc(1);

	unsigned long long int calka_time = calka_end - calka_start;
        unsigned long long int calka_simd_time = calka_simd_end - calka_simd_start;


        printf("Wynik calki FPU:\t%f\tliczba cykli:\t%llu\n", calka_result, calka_time);
	printf("Wynik calki SSE:\t%f\tliczba cykli:\t%llu\n", calka_simd_result, calka_simd_time);

	int x = calka_time / calka_simd_time;	
	
	printf("\nSSE szybsze %d razy\n", x);

	return 0;
}
