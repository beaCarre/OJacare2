#	$Id: Makefile,v 1.3 2004/03/19 20:42:56 henry Exp $	

TOP= ../..
include $(TOP)/Makefile.config

CAMLP4= camlp4orf

MLINCDIRS = ../common ../check +camlp4
MODULES = p4helper mlType mlGen mlMethod mlInit mlClass idl_camlgen

CMO_OBJS = $(addsuffix .cmo, $(MODULES))
CMX_OBJS = $(addsuffix .cmx, $(MODULES))

INCLUDES = $(addprefix -I , $(MLINCDIRS))

all: byte opt
byte: $(CMO_OBJS)
opt: $(CMX_OBJS)

# Règles générales
.SUFFIXES: .ml .mli .cmo .cmi .cmx
.mli.cmi:
	$(OCAMLC) -c -pp "$(CAMLP4)" $(INCLUDES) $<
.ml.cmo:
	$(OCAMLC) -c -pp "$(CAMLP4)" $(INCLUDES) $<
.ml.cmx:
	$(OCAMLOPT) -c -pp "$(CAMLP4)" $(INCLUDES) $< 
clean::
	rm -f *.cm[iox] *.[so] *~ *.annot
realclean::
	echo -n > .depend

# Dépendances
depend:
	$(OCAMLDEP) -pp "$(CAMLP4)" $(INCLUDES) *.mli *.ml > .depend

include .depend