#	$Id: Makefile,v 1.7 2004/03/23 20:33:18 henry Exp $

DISTRIBDIR = mldvi-1.0

include ../Makefile.config
include $(CAMLJAVADIR)/Makefile.config

# Pour ne pas compiler les modules spécifique à X11
DISTRIB_MODULES  = table pkfont search font glyph devfont dvi driver \
	     units dviview

DISTRIB_CMO_OBJS = $(addsuffix .cmo, $(DISTRIB_MODULES))
DISTRIB_CMX_OBJS = $(addsuffix .cmx, $(DISTRIB_MODULES))

MLINCDIRS =  $(CAMLJAVADIR) $(DISTRIBDIR) $(OJACAREDIR)
CLIBDIRS  = /usr/X11R6/lib

EXEC = ojdvi

IDL       = jGraphics
MODULES   = javadev export main
LIBRARIES = unix jni jnihelpers
CLIBS     = unix
CLASS     = mypack/MlDvi mypack/GrControler mypack/GrView mypack/CamlEvent \
	mypack/DviFrame 
CBCLASS = mypack/MlDvi

CMO_OBJS   = $(addsuffix .cmo, $(IDL)) \
	$(addprefix $(DISTRIBDIR)/, $(addsuffix .cmo, $(DISTRIB_MODULES))) \
	$(addsuffix .cmo, $(MODULES))
CMX_OBJS   = $(addsuffix .cmx, $(IDL)) \
	$(addprefix $(DISTRIBDIR)/, $(addsuffix .cmx, $(DISTRIB_MODULES))) \
	$(addsuffix .cmx, $(MODULES))
CMA_OBJS   = $(addsuffix .cma, $(LIBRARIES))
CMXA_OBJS  = $(addsuffix .cmxa, $(LIBRARIES))
CLASS_FILE = $(addsuffix .class, $(CLASS))
CBCLASS_FILE = $(addprefix callback/,$(addsuffix .class, $(CBCLASS)))

BYTE_OBJS = $(CMA_OBJS) $(CMO_OBJS)
OPT_OBJS  = $(CMXA_OBJS) $(CMX_OBJS)

INCLUDES  = $(addprefix -I , $(MLINCDIRS))
LINK_OPTS = $(addprefix -ccopt -L, $(CLIBDIRS)) \
	    $(addprefix -cclib -l, $(CLIBS))


all: distrib-all byte opt
byte: distrib-byte $(CLASS_FILE) $(CBCLASS_FILE) $(EXEC)
opt: distrib-opt $(CLASS_FILE) $(CBCLASS_FILE) $(EXEC).opt

distrib-byte: mldvi-1.0
	make -C $(DISTRIBDIR) $(DISTRIB_CMO_OBJS)
distrib-opt: mldvi-1.0
	make -C $(DISTRIBDIR) $(DISTRIB_CMX_OBJS)
distrib-all: distrib-byte distrib-opt

$(EXEC): $(CMO_OBJS)
	$(OCAMLC) -custom $(INCLUDES) $(BYTE_OBJS) $(LINK_OPTS) -o $(EXEC)

$(EXEC).opt: $(CMX_OBJS)
	$(OCAMLOPT) $(INCLUDES) $(OPT_OBJS) $(LINK_OPTS) -o $(EXEC).opt -cclib "$(JNILIBOPTS)" -cclib "$(JNILIBS)"

# Test
.PHONY: test.byte test
run-byte:
	./$(EXEC)
run-opt:
	./$(EXEC).opt

# Règles générales
.SUFFIXES: .idl .ml
.idl.ml:
	$(OJACARE) $< 
.idl.mli:
	$(OJACARE) $< 
$(CBCLASS_FILE:.class=.java): jGraphics.idl
	$(OJACARE) jGraphics.idl

.SUFFIXES: .ml .mli .java .cmo .cmi .cmx .class
.mli.cmi:
	$(OCAMLC) -c $(INCLUDES) $<
.ml.cmo:
	$(OCAMLC) -c $(INCLUDES) $<
.ml.cmx:
	$(OCAMLOPT) -c $(INCLUDES) $< 
.java.class:
	CLASSPATH=`pwd`:$(CAMLJAVADIR)/camljava.jar $(JAVAC) $<

clean:: 
	rm -f *.cm[iox] *.[so] *~ *.annot
	rm -f mypack/*.class mypack/*~

partialclean::
	rm -rf callback
	rm -f $(addsuffix .ml,$(IDL)) $(addsuffix .mli,$(IDL))
	rm -f $(EXEC) $(EXEC).opt

# Admin
mldvi-1.0:
	@curl -O http://pauillac.inria.fr/~miquel/mldvi-1.0.tar.gz || \
		echo "Pour compiler jdvi, veuillez téléchérger mldvi à l'adresse suivante :\n  http://pauillac.inria.fr/~miquel/mldvi-1.0.tar.gz"
	tar xzf mldvi-1.0.tar.gz

clean:: partialclean
	test ! -d $(DISTRIBDIR) || make -C $(DISTRIBDIR) clean
	rm -f *~

realclean:: clean
	rm -rf $(DISTRIBDIR).tar.gz $(DISTRIBDIR) missfont.log

$(addsuffix .cmo,$(IDL)): $(addsuffix .cmi,$(IDL))
$(addsuffix .cmx,$(IDL)): $(addsuffix .cmi,$(IDL))
