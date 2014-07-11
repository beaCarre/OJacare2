PACK=mypack
IDL=jGraphics
MAIN=export.ml javadev.ml main.ml

# Pour ne pas compiler les modules spécifique à X11
DISTRIB_MODULES  = table pkfont search font glyph devfont dvi driver \
	     units dviview

DISTRIB_REP=mldvi-1.0
DISTRIB_CMJ_OBJS = $(addprefix $(DISTRIB_REP)/, $(addsuffix .cmj, $(DISTRIB_MODULES)))

LIBRARIES = unix

CBCLASSES = 
CLASSES=GrControler MlDvi GrView CamlEvent DviFrame

JAVA_CLASSES=$(addprefix $(PACK)/, $(addsuffix .class,$(CLASSES)))
JAVA_SOURCES=$(addprefix $(PACK)/, $(addsuffix .java,$(CLASSES)))

JAVA_CB_CLASSES=$(addprefix callback/$(PACK)/, $(addsuffix .class,$(CBCLASSES)))
JAVA_CB_SOURCES=$(addprefix callback/$(PACK)/, $(addsuffix .java,$(CBCLASSES)))
INCLUDES=-I $(DISTRIB_REP)

#HOME
#JAVA_PATH=/usr/lib/jvm/java-7-oracle
#ARI :
#JAVA_PATH=/usr/lib/jvm/jdk1.7.0_07
#IRILL :
JAVA_PATH=/usr/lib/jvm/jdk1.7.0_55

JAVA=$(JAVA_PATH)/bin/java
JAVAC=$(JAVA_PATH)/bin/javac
OCAMLJAVA=ocamljava -java-extensions javalib.cmja
OCAMLDEP=ocamldep

ifeq ($(CBCLASSES),)
  CP=-annot -cp $(JAVA_PATH)/lib/ct.sym -cp $(PACK)
else
  CP=-annot -cp $(JAVA_PATH)/lib/ct.sym -cp $(PACK) -cp callback/$(PACK)
endif

default: clean compile run

compile: camlprog.jar

%.cmi: %.mli
	$(OCAMLJAVA) $(CP) $(INCLUDES) -c $<

%.cmj: %.ml 
	$(OCAMLJAVA) $(CP) $(INCLUDES) -c $<

$(IDL).cmj: $(IDL).cmi
$(MAIN:%.ml=%.cmj): $(IDL).cmi

$(IDL).cmj: $(JAVA_CLASSES) $(JAVA_CB_CLASSES)

$(JAVA_CLASSES): $(JAVA_SOURCES)
	$(JAVAC) $(JAVA_SOURCES)

camlprog.jar: $(IDL).cmj $(DISTRIB_CMJ_OBJS) $(MAIN:%.ml=%.cmj)
	$(OCAMLJAVA) $(LIBRARIES:=.cmja) $^

run:
	$(JAVA) -cp camlprog.jar:. pack.ocamljavaMain

clean:
	rm -f camlprog.jar *.cm* *.jo $(PACK)/*.class *.annot $(DISTRIB_REP)/*.cm* $(DISTRIB_REP)/*.jo

.PHONY: default compile run clean


.depend: *.mli *.ml $(DISTRIB_REP)/*.ml $(DISTRIB_REP)/*.mli
	$(OCAMLDEP) $(INCLUDES) $^ > .depend

include .depend
