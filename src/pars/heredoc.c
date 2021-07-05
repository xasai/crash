#include "minishell.h"

#define SHOW_DEBUG 1

static	char *_get_hdoc_filename(void)
{
	static int		num = 0;
	const char		*part1= "/tmp/hdoc";
	char			*part2;
	char			*filename;
	
	num++;
	if (num < 0)
		num = 0;
	part2 = ft_itoa(num);
	filename = ft_strjoin(part1, part2);
	free(part2);
	if (NULL == filename)
		exit_message("Memory allocation failure", SYS_ERROR);
	return (filename);
}

static	char *_hdoc_expand_str(char *str)
{
	//TODO
	return (str);
}

static char *_read_n_write_hdoc(char *delim, int hdoc_fd)
{
	char	*str;
	size_t	str_len;
	size_t	delim_len;

	DEBUG("DELIM is \"%s\"\n", delim);
	delim_len = ft_strlen(delim);
	if (!delim_len)
		return (NULL);
	str = readline(">");
	while (str)
	{
		DEBUG("STR is \"%s\"\n", str);
		str_len = ft_strlen(str);
		if (str_len < delim_len)
			str_len = delim_len;
		if (!ft_strncmp(delim, str, str_len))
			break ;
		str = _hdoc_expand_str(str);
		putendl_fd(str, hdoc_fd);
		str = readline(">");
	}
	return (NULL);
}

char	*get_hdoc(char *delim)
{	
	int		hdoc_fd;
	char	*filename;

	if (!ft_strlen(delim))
		return (NULL);		
	filename = _get_hdoc_filename();
	hdoc_fd = open(filename, O_CREAT | O_TRUNC | O_WRONLY, 0600);
	if (-1 == hdoc_fd)
	{
		print_errno("crash");
		putstr_fd("Can't open /tmp directory\n", STDOUT_FILENO);
		free(filename);
		return (NULL);
	}
	_read_n_write_hdoc(delim, hdoc_fd);
	close(hdoc_fd);
	free(delim);
	return (filename);
}
