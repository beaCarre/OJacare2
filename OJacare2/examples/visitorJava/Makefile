
#HOME
#JAVA_PATH=/usr/lib/jvm/java-7-oracle
#ARI :
#JAVA_PATH=/usr/lib/jvm/jdk1.7.0_07
#IRILL :
JAVA_PATH=/usr/lib/jvm/jdk1.7.0_55

LIB=/home/beatrice/.opam/4.01.0+ocamljava/lib/ojacare/

JAVA=$(JAVA_PATH)/bin/java
JAVAC=$(JAVA_PATH)/bin/javac
OCAMLJAVA=ocamljava -java-extensions -I $(LIB)

CP=-cp $(JAVA_PATH)/lib/ct.sym -cp fr/upmc/infop6/mlo -I $(LIB)

default: clean compile run

compile:
	$(JAVAC) fr/upmc/infop6/mlo/Formule.java
	$(JAVAC) fr/upmc/infop6/mlo/Visiteur.java
	$(JAVAC) fr/upmc/infop6/mlo/VisiteurTS.java

	$(OCAMLJAVA) $(CP) -c visiteur.mli
	$(OCAMLJAVA) $(CP) -c visiteur.ml
	$(OCAMLJAVA) $(CP) -c formule.ml
	$(OCAMLJAVA) $(CP) -c main_visiteur.ml
	$(OCAMLJAVA) javalib.cmja ojhelpers.cmja visiteur.cmj formule.cmj main_visiteur.cmj

run:
	$(JAVA) -cp camlprog.jar:. pack.ocamljavaMain

clean:
	rm -rf camlprog.jar *.cm* *.jo fr/upmc/infop6/mlo/*.class *.annot callback

.PHONY: default compile run clean
