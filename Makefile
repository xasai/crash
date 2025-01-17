##########################################################################################
NAME :=	minishell

SRCPATH := src
SRC := $(shell find $(SRCPATH) -name *.c)

VPATH := $(SRCPATH) 

OBJPATH := obj
OBJDIR := $(subst $(SRCPATH), $(OBJPATH), $(shell find $(SRCPATH) -type d))
OBJ := $(subst $(SRCPATH), $(OBJPATH), $(SRC:.c=.o))

LIBFT := lib/libft/libft.a

LIB := $(LIBFT)
LIB += -lreadline

ifeq ($(OS), $(shell uname -s))
	LIB += -LUsers/$(shell whoami)/.brew/Cellar/readline/8.1/lib/
endif

INC := -Iinclude/ -Ilib/libft/include 
############################################################################################
 #_____    _____    _____ 
#/ ____|  / ____|  / ____|
#| |  __  | |      | |     
#| | |_ | | |      | |     
#| |__| | | |____  | |____ 
 #\_____|  \____|  \_____|
CC := gcc
CFLAGS := -Wall -Wextra -Werror -MMD -MP#--std=c99 -D_POSIX_SOURCE 
CFLAGS += -g3
#CFLAGS += -Ofast
#CLFAGS += -fsanitize=address 
############################################################################################

ifeq ($(MAKECMDGOALS),re)
MAKEFLAGS=
else
MAKEFLAGS=-j4
endif

all: $(NAME)

ifeq ($(MAKECMDGOALS),clean)
DEPFILES=
else ifeq ($(MAKECMDGOALS),fclean)
DEPFILES=
else
DEPFILES := $(OBJ:.o=.d)
-include $(DEPFILES)
endif

$(NAME): $(OBJPATH) $(LIBFT) $(OBJ)
	@echo -n $(GREEN)
	$(CC) $(CFLAGS) $(INC) $(OBJ) $(LIB) -o $(NAME)
	@echo $(RESET) "\n===========>\t$(NAME) Successfully compiled [+]"

$(OBJPATH)/%.o: %.c
	@echo -n $(GREEN)
	$(CC) $(INC) $(CFLAGS) -c $< -o $@ 

$(OBJPATH):
	@echo -n $(GREEN)
	mkdir -p $(OBJDIR)
	@echo -n $(RESET)

$(LIBFT):
	@echo -n $(GREEN)
	make -C $(dir $(LIBFT))
	@echo -n $(RESET)

clean:
	@echo -n $(RED)
	make clean -C $(dir $(LIBFT))
	rm -rf $(OBJPATH)
	@echo -n $(RESET)

fclean: clean
	@echo -n $(RED)
	make fclean -C $(dir $(LIBFT))
	rm -rf $(NAME)
	@echo -n $(RESET)

re: 
	$(MAKE) fclean
	$(MAKE) all

.PHONY: run re fclean clean all

############################################################################################
run: $(NAME) 
	./$(NAME)

bash:
	bash

VALFLAGS += --leak-check=full 
VALFLAGS += --track-origins=yes
#VALFLAGS += --trace-children=yes
#VALFLAGS += --show-leak-kinds=all 
val: $(NAME)
	valgrind $(VALFLAGS) ./$(NAME)

docker-build:
	@echo building image minishell:latest
	@(docker ps -a | grep minishell) || docker build . --tag minishell 	

docker-run: docker-build
	docker run --name minishell -it --rm minishell 

docker-rm:
	docker rmi -f minishell

debug: $(NAME)
	gdb	./$(NAME)
###########################################################################################
GREEN := "\033[1;32m"
RESET := "\033[1;0m"
RED := "\033[1;31m"
