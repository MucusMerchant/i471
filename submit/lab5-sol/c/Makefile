CC = gcc
CFLAGS = -g -Wall -std=gnu2x

C_FILES := $(wildcard *.c)
EXES = $(C_FILES:%.c=%)


all:	 $(EXES) .gitignore

.gitignore: $(EXES)
		echo $(EXES) | tr ' ' '\n' > $@

clean:
		rm -f $(EXES) *~
