#	$Id: Makefile,v 1.3 2004/03/19 20:42:57 henry Exp $	

TOP= ../..
include $(TOP)/Makefile.config

OCAMLJAVA = ocamljava -java-extensions

MODULES =  ojArray

CMJ_OBJS = $(addsuffix .cmj, $(MODULES))
CMI_OBJS = $(addsuffix .cmi, $(MODULES))
MLI_OBJS = $(addsuffix .mli, $(MODULES))

INCLUDES =

LIB = ojhelpers

all: $(LIB).cmja

$(LIB).cmja: $(CMJ_OBJS) 
	$(OCAMLJAVA) -a -o $(LIB).cmja $(CMJ_OBJS) 

%.cmi: %.mli
	$(OCAMLJAVA) $(CP) $(INCLUDES) -c $<

%.cmj: %.ml
	$(OCAMLJAVA) $(CP) $(INCLUDES) -c $<

install:
	${OCAMLFIND} install ojacare META ojhelpers.cmja ojhelpers.ja $(CMJ_OBJS) $(CMI_OBJS) $(MLI_OBJS)

uninstall:
	${OCAMLFIND} remove ojacare

reinstall:
	${MAKE} uninstall
	${MAKE} install

clean::
	rm -f *.cm[ij] *~ *.ja *.jo *.cmja 

# Dépendances
.depend: *.mli *.ml
	$(OCAMLDEP) *.mli *.ml > .depend

-include .depend
