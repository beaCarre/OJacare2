# generic minimal Makefile for O'Jacare

# Adjust to your O'Jacare installation

LIBDIR = /home/beatrice/.opam/4.01.0+ocamljava/lib/ojacare/

### Specific to your application

 MAIN      = main-visitorML
 IDL       = formule
 MLINCDIRS = 
 MODULES   = 
 LIBRARIES = javalib ojhelpers
 PACK     = fr/upmc/infop6/mlo
 CLASSES = Formule Constante Var Non OpBin Et Ou Visiteur VisiteurTS VisiteurML MainML MainJava
 CBCLASSES   = 

### include $(LIBDIR)/Makefile.generic


######### Adjust to your installation #########

JAVA_PATH =/usr/lib/jvm/jdk1.7.0_55

OCAMLC      = ocamlfind ocamlc
OCAMLOPT    = ocamlfind ocamlopt
OCAMLDEP    = ocamldep 

OJACARE = ojacare
OCAMLJAVA = ocamljava -java-extensions -I $(LIBDIR)
OJACAREDIR  = $(shell ocamlfind printconf destdir)/ojacare


#########  #########

JAVA=$(JAVA_PATH)/bin/java
JAVAC=$(JAVA_PATH)/bin/javac

JAVA_CLASSES=$(addprefix $(PACK)/, $(addsuffix .class,$(CLASSES)))
JAVA_SOURCES=$(addprefix $(PACK)/, $(addsuffix .java,$(CLASSES)))

JAVA_CB_CLASSES= \
  $(addprefix callback/$(PACK)/CB_, $(addsuffix .class,$(CBCLASSES))) \
  $(addprefix callback/$(PACK)/ICB_, $(addsuffix .class,$(CBCLASSES)))
JAVA_CB_SOURCES= \
  $(addprefix callback/$(PACK)/CB_, $(addsuffix .java,$(CBCLASSES))) \
  $(addprefix callback/$(PACK)/ICB_, $(addsuffix .java,$(CBCLASSES)))


INCLUDES  = $(PACKAGES) $(addprefix -I , $(MLINCDIRS))
LINK_OPTS = -linkpkg $(addprefix -ccopt -L, $(CLIBDIRS)) \
	    $(addprefix -cclib -l, $(CLIBS))

CP := -annot -cp $(JAVA_PATH)/lib/ct.sym -cp $(PACK)
ifneq ($(CBCLASSES),)
  CP += -cp callback/$(PACK)
endif


#########  #########

compile: camlprog.jar

$(IDL).ml $(IDL).mli $(JAVA_CB_SOURCES): $(IDL).idl
	$(OJACARE) $<

%.cmi: %.mli
	$(OCAMLJAVA) $(CP) $(INCLUDES) -c $<

%.cmj: %.ml 
	$(OCAMLJAVA) $(CP) $(INCLUDES) -c $<

$(IDL).cmj: $(IDL).cmi $(JAVA_CLASSES) $(JAVA_CB_CLASSES)
$(MAIN:%.ml=%.cmj): $(IDL).cmi

$(JAVA_CLASSES): $(JAVA_SOURCES)
	$(JAVAC) $^

$(JAVA_CB_CLASSES): $(JAVA_CB_SOURCES)
	$(JAVAC) $^

camlprog.jar: $(IDL).cmj $(MAIN:%=%.cmj)
	$(OCAMLJAVA) $(LIBRARIES:=.cmja) $^

run:
	$(JAVA) -cp camlprog.jar:. pack.ocamljavaMain

clean:
	rm -rf camlprog.jar *.cm* *.jo $(PACK)/*.class callback *.annot $(IDL).ml $(IDL).mli


.PHONY: default compile run clean


.depend: $(wildcard *.mli) $(wildcard *.ml)
	$(OCAMLDEP) $(INCLUDES) $^ > .depend

include .depend
