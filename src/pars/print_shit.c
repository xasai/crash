#include "minishell.h"

void print_this_shit(t_cmdlst *l)
{
	while(l->prev)
		l = l->prev;
	write(1, "\033[1;35m", sizeof("\033[1;35m"));
	while(l)
	{
		printf("\tName \"%s\"\n", l->name);
		if (l->arg)
		{
			for (int i = 0; l->arg[i]; ++i)
				printf("\targv[%i] \"%s\"\n", i, l->arg[i]);
		}
		if (l->sepch)
			printf("\tsepch %c\n", l->sepch);
		l = l->next;
	}
	write(1, "\033[1;0m", sizeof("\033[1;0m"));
}
