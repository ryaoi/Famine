NAME 		    = Famine

CC              = gcc

# in case for 32bit compilation to get the payload add -m32 -D__32BIT__=1

CFLAGS	        = -Wall -Wextra -Werror -masm=intel -nostartfiles

DEBUG           = -g -fsanitize=address

SRC_C		    = start.c

SRC_SYSCALL	    = write.c

HEADER		    = ./famine.h

SRC_DIR_C  	    = ./src_c/
SRC_DIR_SYSCALL	= ./src_syscall/
OBJ_DIR	        = ./obj/

OBJ_SYSCALL		= $(addprefix $(OBJ_DIR), $(SRC_C:%.c=%.o))

OBJ_FUNCTION	= $(addprefix $(OBJ_DIR), $(SRC_SYSCALL:%.c=%.o))

$(OBJ_DIR)%.o : $(SRC_DIR_SYSCALL)%.c $(HEADER)
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@ -I./

$(OBJ_DIR)%.o : $(SRC_DIR_C)%.c $(HEADER)
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@ -I./

all: $(NAME) 

$(NAME): $(OBJ_SYSCALL) $(OBJ_FUNCTION) $(HEADER)
	$(CC) $(CFLAGS) $(OBJ_SYSCALL) $(OBJ_FUNCTION) -o $(NAME)

debug: $(OBJ_SYSCALL) $(OBJ_FUNCTION) $(HEADER)
	$(CC) $(DEBUG) $(CFLAGS) $(OBJ_SYSCALL) $(OBJ_FUNCTION) -o $(NAME)

clean:
		rm -rf $(OBJ_SYSCALL) $(OBJ_FUNCTION)
	
fclean: clean
		rm -rf $(NAME)

re: fclean all
