/**********************************************************************
Time: 2017/3/23
Auther: GYH
Function: This C file is used for choose the best router from 
routerlist.txt(from findrouter.sh).It can fix whether the chosen router
is the same as oldrouter that has been writen in 'bestrouter.txt'. Also,
if the 'routerlist.txt' not exit or empty, this file will not return 0.

returned value: 0			1					2					3
meanning: 	 normal	 needn't update	 file not exist or empty  can't open file
***********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>	//Regular Expression head file.
#define LEN 100
#define MAXID 100
#define MAXMAC 20
#define MAXROUTER 100

struct router
{
	char BSS[MAXMAC];
	float signal;
	char SSID[MAXID];
};
struct router bestrouter;
int read_Routers(char filename[],struct router routers[], int max);
int choose_Router(struct router routers[], int records_number);

int main(int argc, char *argv[])
{
	FILE *fd;
	struct router routers[MAXROUTER] = {0};
	struct router oldrouter = {0};
	int router_numbers = 0;

	if (argc!=2)
	{
		printf("Usage: %s in_file\n",argv[0]);
		exit(0);
	}
	router_numbers = read_Routers(argv[1], routers, MAXROUTER);
	choose_Router(routers, router_numbers);


	if ((fd = fopen("/tmp/bestrouter.txt", "r")) == NULL)
	{
		// perror("fopen");
		//file not exist, need creat file.(When First Operation.)
		printf("%s\n%s\n", bestrouter.SSID, bestrouter.BSS);
		exit(0);
	}
	fscanf(fd, "%s", oldrouter.SSID);	//copy file's first line
	fclose(fd);
	if (strcmp(oldrouter.SSID,bestrouter.SSID) != 0)
	{
		printf("%s\n%s\n", bestrouter.SSID, bestrouter.BSS);
		return 0;	//need update
	}
	return 1;	//no need update
}

/*************************************************************************************
Read "max" files from the "filename" file and save it to the array "router routers[]".
This function returns the number of records of actually read.

*************************************************************************************/
int read_Routers(char filename[],struct router routers[], int max)
{
	FILE *fd;
	int i=0;

	if ((fd = fopen(filename, "r")) == NULL)
	{
		// perror("fopen");
		exit(3);	//can't open file "routerlist.txt".
	}
	while(fscanf(fd, "%s %f %s", routers->BSS, &routers->signal, routers->SSID)!=EOF)
	{
		if (++i == max)	//Read at most "max" routers into struct.
			break;
		routers++;
	}
	fclose(fd);
	if (i == 0)
		exit(2);
	//When iwscan.txt or routerlist.txt not exist or empty because of 'iw dev XXX scan'
	//failed or other network problem, i=0, lead to printf bestrouter=0. So this is to
	//deal with this bug.
	return i;
}
/***************************************************************************************
Choose the best dBm from routers[].signal(use Regular Expression),and put put the best
record to a struct 'bestrouter[]'.

***************************************************************************************/
int choose_Router(struct router routers[], int records_number)
{
	float min = 99;
	int flag = 0, status;
	int cflags = REG_EXTENDED;
	regmatch_t pmatch[1];
	const size_t nmatch = 1;
	regex_t reg;
	const char* pattern = "^openwrt[0-9]{0,3}";

	for (int i = 0; i < records_number; ++i)
	{
		regcomp(&reg, pattern, cflags);
		status = regexec(&reg, routers[i].SSID, nmatch, pmatch, 0);	//Use Regular Expression
		if (status == 0)											//to match.
		{
			if (min > (routers[i].signal + 20))	//When signal strength is more than the current
			{									//value of 20dBm, go to next.
				min = routers[i].signal;
				flag = i;	//The number of the best router in struct.
			}
		}
		regfree(&reg);
	}
	// If flag=0, means that no approprite AP or only the connected AP at the top of 'routerlist.txt'
	if (flag != 0)
	{
		strcpy(bestrouter.BSS, routers[flag].BSS);	//put the best record to struct"bestrouter"
		bestrouter.signal = routers[flag].signal;
		strcpy(bestrouter.SSID, routers[flag].SSID);
	}
	else
		exit(1);	//no fitted AP, needn't update

	return 0;
}

