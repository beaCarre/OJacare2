#	$Id: Makefile,v 1.3 2004/03/19 20:42:57 henry Exp $	

TOP= ../..
include $(TOP)/Makefile.config

MLINCDIRS = $(CAMLJAVADIR)
MODULES = jniHierarchy jniArray

CMO_OBJS = $(addsuffix .cmo, $(MODULES))
CMX_OBJS = $(addsuffix .cmx, $(MODULES))

INCLUDES = $(addprefix -I , $(MLINCDIRS))

LIB = jnihelpers

all: byte opt
byte: $(LIB).cma #jniInit.cmo
opt: $(LIB).cmxa #jniInit.cmx

$(LIB).cma: $(CMO_OBJS) 
	$(OCAMLC) -a -o $(LIB).cma $(CMO_OBJS) 

$(LIB).cmxa: $(CMX_OBJS)
	$(OCAMLOPT) -a -o $(LIB).cmxa $(CMX_OBJS)

install:
	ocamlfind remove ojacare
	ocamlfind install ojacare META jnihelpers.cma jnihelpers.cmxa jnihelpers.a jniArray.cmi jniHierarchy.cmi jniHierarchy.mli

# Règles générales
.SUFFIXES: .ml .mli .cmo .cmi .cmx
.mli.cmi:
	$(OCAMLC) -c $(INCLUDES) $<
.ml.cmo:
	$(OCAMLC) -c $(INCLUDES) $<
.ml.cmx:
	$(OCAMLOPT) -c $(INCLUDES) $< 
clean::
	rm -f *.cm[iox] *.[soa] *~ *.annot *.cmxa *.cma 
realclean::
	echo -n > .depend

# Dépendances
depend:
	$(OCAMLDEP) *.mli *.ml > .depend

include .depend
