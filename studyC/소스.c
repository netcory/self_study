#include <stdio.h>

int main(void)
{
	int a;					// int형 변수 a 선언
	int b, c;				// int형 변수 b, c를 동시에 선언. 변수의 자료형이 같다면 동시에 둘 이상의 변수 선언 가능.
	double da;				// double형 변수 da 선업
	char ch;				// char형 변수 ch 선업

	a = 10;					// int형 변수 a에 정수 10 대입
	b = a;					// int형 변수 b에 변수 a의 값 대입
	c = a + 20;				// int형 변수 c에 변수 a의 값과 정수 20을 더한 값 대입
	da = 3.5;				// double형 변수 da에 실수 3.5 대입
	ch = 'A';				// char형 변수 ch에 문자 'A' 대입

	printf("변수 a의 값: %d\n", a);
	printf("변수 b의 값: %d\n", b);
	printf("변수 c의 값: %d\n", c);
	printf("변수 da의 값: %.1lf\n", da);
	printf("변수 ch의 값: %.c\n", ch);

	return 0;
}