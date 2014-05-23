#HOME
JAVA_PATH=/usr/lib/jvm/java-7-oracle
#ARI :
#JAVA_PATH=/usr/lib/jvm/jdk1.7.0_07

JAVA=$(JAVA_PATH)/bin/java
JAVAC=$(JAVA_PATH)/bin/javac
OCAMLJAVA=ocamljava -java-extensions javalib.cmja

CP=-annot -cp $(JAVA_PATH)/lib/ct.sym -cp mypack

default: clean compile run

compile:
	$(JAVAC) mypack/*.java
	$(OCAMLJAVA) $(CP) -c p.mli
	$(OCAMLJAVA) $(CP) -c p.ml
	$(OCAMLJAVA) $(CP) -c main.ml
	$(OCAMLJAVA) p.cmj main.cmj

run:
	$(JAVA) -cp camlprog.jar:. pack.ocamljavaMain

clean:
	rm -f camlprog.jar *.cm* *.jo mypack/*.class *.annot


.PHONY: default compile run clean
