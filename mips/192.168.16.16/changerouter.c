/**********************************************************************
Time: 2017/3/23
Auther: GYH
Function: This C file is used for tesing the connecting router, if it can communicate
sorce router, return 0, if not, change to another bestrouter in routerlist.txt.
returned value: 0				1			   	2				3
meanning: needn't change   needn change	 can't open file  wrong use function
***********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>	//Regular Expression head file.
#define MAXROUTER 100
#define MAXMAC 20
#define MAXID 100

struct router
{
	char BSS[MAXMAC];
	float signal;
	char SSID[MAXID];
};
struct router badrouter;
struct router bestrouter;
int read_Routers(char filename[],struct router routers[], int max);
int choose_Router_match(struct router routers[], int records_number, struct router badrouter);

int main(int argc, char *argv[])
{
	FILE *fd;
	struct router routers[MAXROUTER] = {0};
	int router_numbers = 0;

	if (argc!=2)
	{
		printf("Usage: %s routerlist\n",argv[0]);
		exit(3);
	}

	while (system("ping 192.168.10.10 -c 5"))	//ping Sorce 10 times
	{											//if fault, return 1
		if ((fd = fopen("/tmp/bestrouter.txt", "r")) == NULL)
		{
			// perror("fopen");
			//file not exist, need creat file.(When First Operation.)
			//printf("%s\n%s\n", bestrouter.SSID, bestrouter.BSS);
			exit(2);
		}
		fscanf(fd, "%s %s", badrouter.SSID, badrouter.BSS);	
		fclose(fd);
		router_numbers = read_Routers(argv[1], routers, MAXROUTER);
		choose_Router_match(routers, router_numbers, badrouter);
		// rewind(fd);
		if ((fd = fopen("/tmp/bestrouter.txt", "wt+")) == NULL)
		{
			exit(2);
		}
		fprintf(fd, "%s\n%s\n", bestrouter.SSID, bestrouter.BSS);
		fclose(fd);
		printf("The bad router is:\n%s\n%s\n", badrouter.SSID, badrouter.BSS);
		printf("Now the best router changed:\n%s\n%s\n", bestrouter.SSID, bestrouter.BSS);
		return 1;
	}
	return 0;
}

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

int choose_Router_match(struct router routers[], int records_number, struct router badrouter)
{
	float min = 99;
	int flag = 0, status,status2;
	int cflags = REG_EXTENDED;
	regmatch_t pmatch[1];
	const size_t nmatch = 1;
	regex_t reg;
	const char* pattern = "^openwrt[0-9]{0,3}";

	for (int i = 0; i < records_number; ++i)
	{
		regcomp(&reg, pattern, cflags);
		status = regexec(&reg, routers[i].SSID, nmatch, pmatch, 0);	//Use Regular Expression
		if ((status == 0) && (strcmp(routers[i].SSID,badrouter.SSID) != 0))	//to match.
		{
			if (min > (routers[i].signal))	//When signal strength is more than the current
			{									//value of 20dBm, go to next.
				min = routers[i].signal;
				flag = i;	//The number of the best router in struct.
			}
		}
		// regfree(&reg);
	}
	//To check whether routers[flag] inappropriate.
	if (regexec(&reg, routers[flag].SSID, nmatch, pmatch, 0))
	{
		regfree(&reg);
		return 0;
	}
	else
	{
		regfree(&reg);
		strcpy(bestrouter.BSS, routers[flag].BSS);	//put the best record to struct"bestrouter"
		bestrouter.signal = routers[flag].signal;
		strcpy(bestrouter.SSID, routers[flag].SSID);
		return 1;
	}
}
