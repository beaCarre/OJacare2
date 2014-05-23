#	$Id: Makefile,v 1.6 2004/07/19 11:29:11 henry Exp $	

TOP= ..
include $(TOP)/Makefile.config

SUBDIRS = jnihelpers common parser check camlgen javagen
MLINCDIRS = $(SUBDIRS)

COMMON_MODULES = filesystem utilities
PARSER_MODULES = loc syntax_error lexer parser idl_parser
CHECK_MODULES = modifiers annot error ident env_idl env_ident type init method field content def idl_check
CAMLGEN_MODULES = p4helper mlType mlGen mlMethod mlInit mlClass idl_camlgen  
JAVAGEN_MODULES = javaType javaArgs javaInit javaMethod javaClass idl_javagen

COMMON_CMO_OBJS  = $(addprefix common/, $(addsuffix .cmo, $(COMMON_MODULES)))
COMMON_CMX_OBJS  = $(addprefix common/, $(addsuffix .cmx, $(COMMON_MODULES)))
PARSER_CMO_OBJS  = $(addprefix parser/, $(addsuffix .cmo, $(PARSER_MODULES)))
PARSER_CMX_OBJS  = $(addprefix parser/, $(addsuffix .cmx, $(PARSER_MODULES)))
CHECK_CMO_OBJS  = $(addprefix check/, $(addsuffix .cmo, $(CHECK_MODULES)))
CHECK_CMX_OBJS  = $(addprefix check/, $(addsuffix .cmx, $(CHECK_MODULES)))
CAMLGEN_CMO_OBJS  = $(addprefix camlgen/, $(addsuffix .cmo, $(CAMLGEN_MODULES)))
CAMLGEN_CMX_OBJS  = $(addprefix camlgen/, $(addsuffix .cmx, $(CAMLGEN_MODULES)))
JAVAGEN_CMO_OBJS  = $(addprefix javagen/, $(addsuffix .cmo, $(JAVAGEN_MODULES)))
JAVAGEN_CMX_OBJS  = $(addprefix javagen/, $(addsuffix .cmx, $(JAVAGEN_MODULES)))

INCLUDES  = $(addprefix -I , $(MLINCDIRS))

EXEC = ojacare

all: byte opt
byte: srcbyte $(EXEC)
opt: srcopt $(EXEC).opt

# Source
.PHONY: src srcbyte srcopt
src: srcbyte srcopt
srcbyte: 
	$(foreach dir,$(SUBDIRS),$(MAKE) -C $(dir) byte;) 
srcopt: 
	make -C jnihelpers opt
	$(foreach dir,$(SUBDIRS),$(MAKE) -C $(dir) opt;)
clean:: 
	$(foreach dir,$(SUBDIRS),$(MAKE) -C $(dir) clean;)

# Exécutable
$(EXEC): $(COMMON_CMO_OBJS) $(PARSER_CMO_OBJS) $(CHECK_CMO_OBJS) $(JAVAGEN_CMO_OBJS) $(CAMLGEN_CMO_OBJS) main/ojacare.cmo
	$(OCAMLC) -o $@ -I +camlp4 dynlink.cma camlp4lib.cma unix.cma $^
$(EXEC).opt: $(COMMON_CMX_OBJS) $(PARSER_CMX_OBJS) $(CHECK_CMX_OBJS) $(JAVAGEN_CMX_OBJS) $(CAMLGEN_CMX_OBJS) main/ojacare.cmx
	$(OCAMLOPT) -o $@ -I +camlp4 dynlink.cmxa camlp4lib.cmxa unix.cmxa $^ 
partialclean:: 
	rm -f ojacare ojacare.opt
	rm -f main/*.cm[xoi] main/*.[so] main/*~ main/*.annot

install:
	test -d $(BINDIR) || mkdir -p $(BINDIR)
	cp ojacare $(BINDIR) 
	make -C jnihelpers install
	cp main/Makefile.include $(LIBDIR)

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
realclean:: clean
	$(foreach dir,$(SUBDIRS),$(MAKE) -C $(dir) realclean;)
	echo -n > .depend

# Dépendances
depend:
	$(foreach dir,$(SUBDIRS),$(MAKE) -C $(dir) depend;)
	$(OCAMLDEP) $(INCLUDES) main/*.mli main/*.ml > .depend

include .depend
