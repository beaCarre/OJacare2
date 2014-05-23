#	$Id: Makefile,v 1.3 2004/03/19 20:42:57 henry Exp $	

TOP= ../..
include $(TOP)/Makefile.config

MLINCDIRS = 
MODULES =  loc syntax_error lexer parser idl_parser

CMO_OBJS = $(addsuffix .cmo, $(MODULES))
CMX_OBJS = $(addsuffix .cmx, $(MODULES))

INCLUDES = $(addprefix -I , $(MLINCDIRS))

all: byte opt
byte: $(CMO_OBJS)
opt: $(CMX_OBJS)

# Spécifique
parser.ml parser.mli: parser.mly
	$(OCAMLYACC) $(YACCFLAGS) parser.mly

lexer.ml: lexer.mll
	$(OCAMLLEX) lexer.mll

partialclean::
	rm -f lexer.ml parser.ml parser.mli 

clean::
	rm -f parser.output

beforedepend:: parser.ml lexer.ml

# Règles générales
.SUFFIXES: .ml .mli .cmo .cmi .cmx
.mli.cmi:
	$(OCAMLC) -c $(INCLUDES) $<
.ml.cmo:
	$(OCAMLC) -c $(INCLUDES) $<
.ml.cmx:
	$(OCAMLOPT) -c $(INCLUDES) $< 
clean:: partialclean
	rm -f *.cm[iox] *.[so] *~ *.annot
realclean::
	echo -n > .depend

# Dépendances
depend: beforedepend
	$(OCAMLDEP) $(INCLUDES) *.mli *.ml > .depend

include .depend
