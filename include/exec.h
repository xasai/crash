#ifndef EXEC_H
# define EXEC_H

# include "minishell.h"
# include <sys/wait.h>

/*				EXEC.c					*/
void	cmdline_exec(t_cmdlst *cmdlst, t_shell *crash);

/*				PATH.c					*/
char	*get_path(char *pathname, char **env_path);
char	*reltoabs(char *rel_path);

/*				REBUILD_PATH.c			*/
void	rebuild_path(t_shell *crash);

/*				GETCWD.c				*/
char	*_getcwd(void);

#endif /* EXEC_H */
