#	$Id: Makefile,v 1.6 2004/03/23 22:35:39 henry Exp $

ALLSUBDIRS = $(patsubst %/Makefile,%,$(wildcard */Makefile))
SUBDIRS = point rectangle awt observer visitorML

all:
	@printf "\n\
Don't forget to install O'Jacaré,\n\
and adjust Makefile.config to your installation. \n\
------------------------------------------------ \n\
Usage :\n\
   * make byte       : build examples recursively with bytecode compiler \n\
   * make run-byte   : run recursively bytecode-examples \n\
   * make opt        : build examples recursively with native compiler \n\
   * make run-opt    : run recursively native-examples \n\
------------------------------------------------- \n\
See README for full explanation.\n\n"

byte:
	@$(foreach dir,$(SUBDIRS),\
		echo "#############";\
		echo "#### Building $(dir) (bytecode)####";\
		$(MAKE) -C $(dir) byte;)
opt:
	@$(foreach dir,$(SUBDIRS),\
		echo "#############";\
		echo "#### Building $(dir) (native) ####";\
		$(MAKE) -C $(dir) opt;)

run-byte:
	@$(foreach dir,$(SUBDIRS),\
		echo "#############";\
		echo "#### Running $(dir) (bytecode) ####";\
		$(MAKE) -C $(dir) run-byte CLASSPATH=.;)
run-opt:
	@$(foreach dir,$(SUBDIRS),\
		echo "#############";\
		echo "#### Running $(dir) (native) ####";\
		$(MAKE) -C $(dir) run-opt CLASSPATH=.;)

clean:
	@$(foreach dir,$(ALLSUBDIRS),$(MAKE) -C $(dir) clean;)


