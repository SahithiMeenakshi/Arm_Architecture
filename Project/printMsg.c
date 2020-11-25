#include "stm32f4xx.h"
#include <string.h>

void printMsg(const int a)
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "\t 0x%08X\r\n", a);
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}

void print_encoded(const int a)					
{
	char Msg[100];
	char *ptr;
	sprintf(Msg, "\n Generated 31 bit hamming code is : 0x%08X\r\n", a);
	ptr = Msg ;
	while(*ptr != '\0'){
		ITM_SendChar(*ptr);
		++ptr;
		}
}
void print_error_before(const int a)					
{
	char Msg[100];
	char *ptr;
	sprintf(Msg, "\n 31 bit hamming code with error bit introduced is :  0x%08X\r\n", a);
	ptr = Msg ;
	while(*ptr != '\0'){
		ITM_SendChar(*ptr);
		++ptr;
		}
}
void print_errorcorrection(const int a)					
{
	char Msg[100];
	char *ptr;
	sprintf(Msg, "\n Corrected 31 bit hamming code is : 0x%08X\r\n", a);
	ptr = Msg ;
	while(*ptr != '\0'){
		ITM_SendChar(*ptr);
		++ptr;
		}
}

void print_error_msg(const int a)					
{
	char Msg[100];
	char *ptr;
	sprintf(Msg, "\n Detected more than 1 error bit  \n");
	ptr = Msg ;
	while(*ptr != '\0'){
		ITM_SendChar(*ptr);
		++ptr;
		}
}

void print_noerror(const int a)					
{
	char Msg[100];
	char *ptr;
	sprintf(Msg, "\n No error is detected  \n");
	ptr = Msg ;
	while(*ptr != '\0'){
		ITM_SendChar(*ptr);
		++ptr;
		}
}
