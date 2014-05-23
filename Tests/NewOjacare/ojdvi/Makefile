PACK=mypack
IDL=jGraphics
MAIN=export.ml javadev.ml main.ml

#HOME
#JAVA_PATH=/usr/lib/jvm/java-7-oracle
#ARI :
#JAVA_PATH=/usr/lib/jvm/jdk1.7.0_07
#IRILL :
JAVA_PATH=/usr/lib/jvm/jdk1.7.0_55

JAVA=$(JAVA_PATH)/bin/java
JAVAC=$(JAVA_PATH)/bin/javac
OCAMLJAVA=ocamljava -java-extensions javalib.cmja

CP=-annot -cp $(JAVA_PATH)/lib/ct.sym -cp $(PACK)

default: clean compile run

compile:
	$(JAVAC) $(PACK)/GrControler.java $(PACK)/MlDvi.java $(PACK)/GrView.java $(PACK)/CamlEvent.java $(PACK)/DviFrame.java
	$(OCAMLJAVA) $(CP) -c $(IDL).mli
	$(OCAMLJAVA) $(CP) -c $(IDL).ml
	$(OCAMLJAVA) $(CP) -c $(MAIN)
	$(OCAMLJAVA) $(IDL).cmj $(MAIN:%.ml=%.cmj)

run:
	$(JAVA) -cp camlprog.jar:. pack.ocamljavaMain

clean:
	rm -f camlprog.jar *.cm* *.jo $(PACK)/*.class *.annot


.PHONY: default compile run clean
