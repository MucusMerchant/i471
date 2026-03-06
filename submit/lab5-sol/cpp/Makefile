CPP = g++
CPPFLAGS = -g -Wall -std=c++23 -Wno-unused-function

CPP_FILES := $(wildcard *.cpp)
EXES = $(CPP_FILES:%.cpp=%)


all:	 $(EXES) .gitignore

.gitignore: 	$(EXES)
		echo $(EXES) | tr ' ' '\n' > $@

clean:
		rm -f $(EXES) *~
