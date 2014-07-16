
MAIN      := export javadev main
IDL       := jGraphics
MLINCDIRS := mldvi-1.0
DISTRIB_MODULES := table pkfont search font glyph devfont dvi driver \
	           units dviview
LIBRARIES  := unix
PACK       := mypack
CLASSES    := GrControler MlDvi GrView CamlEvent DviFrame
CBCLASSES  :=

EXTRA_OBJS := $(addprefix mldvi-1.0/,${DISTRIB_MODULES:=.cmj})
EXTRA_ARGS :=

all: mldvi-1.0 camlprog.jar

include $(shell ocamlfind query ojacare)/Makefile.ojacare

mldvi-1.0.tar.gz:
	wget http://www.pps.=univ-paris-diderot.fr/~miquel/soft/mldvi-1.0.tar.gz

mldvi-1.0: mldvi-1.0.tar.gz
	tar xf $^

clean::
	rm -rf mldvi-1.0

