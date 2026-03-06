RSC = rustc

RS_FILES := $(wildcard *.rs)
EXES = $(RS_FILES:%.rs=%)


all:	 $(EXES) .gitignore

.gitignore: 	$(EXES)
		echo $(EXES) | tr ' ' '\n' > $@

clean:
		rm -f $(EXES) *~

%:		%.rs
		rustc $^
