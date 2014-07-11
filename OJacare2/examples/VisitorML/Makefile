
#HOME
#JAVA_PATH=/usr/lib/jvm/java-7-oracle
#ARI :
#JAVA_PATH=/usr/lib/jvm/jdk1.7.0_07
#IRILL :
JAVA_PATH=/usr/lib/jvm/jdk1.7.0_55

JAVA=$(JAVA_PATH)/bin/java
JAVAC=$(JAVA_PATH)/bin/javac
OCAMLJAVA=ocamljava -java-extensions javalib.cmja -I /home/beatrice/.opam/4.01.0+ocamljava/lib/ojacare/ ojhelpers.cmja

CP=-annot -cp $(JAVA_PATH)/lib/ct.sym -cp fr/upmc/infop6/mlo

default: clean compile run

compile:
	$(JAVAC) fr/upmc/infop6/mlo/*.java
	$(OCAMLJAVA) $(CP) -c formule.mli
	$(OCAMLJAVA) $(CP) -c formule.ml
	$(OCAMLJAVA) $(CP) -c main-visitorML.ml
	$(OCAMLJAVA) formule.cmj main-visitorML.cmj

run:
	$(JAVA) -cp camlprog.jar:. pack.ocamljavaMain

clean:
	rm -fr camlprog.jar *.cm* *.jo fr/upmc/infop6/mlo/*.class *.annot callback/


.PHONY: default compile run clean
