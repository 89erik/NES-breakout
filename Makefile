.PHONY: all clean

####################################################################
# Definitions                                                      #
####################################################################
SHELL = C:/Windows/System32/cmd.exe
PROJECTNAME = $(notdir $(CURDIR))

CC       = ca65.exe
LD       = ld65.exe

RM       = rm -rf
SRC 	 = main.asm
L_SCRIPT = linker_config.cfg


####################################################################
# Rules                                                            #
####################################################################


# Default build is debug build
all: clean
all: $(PROJECTNAME).nes

# Create objects from asm source file
main.o: $(SRC)
	$(CC) $<

# Link
$(PROJECTNAME).nes: main.o
	$(LD) -C $(L_SCRIPT) main.o -o $(PROJECTNAME).nes

clean:
	$(RM) main.o

