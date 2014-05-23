PACK=mypack
NAME=jdb
MAIN=db
TEST=db_test

#HOME
#JAVA_PATH=/usr/lib/jvm/java-7-oracle
#ARI :
#JAVA_PATH=/usr/lib/jvm/jdk1.7.0_07
#IRILL :
JAVA_PATH=/usr/lib/jvm/jdk1.7.0_55


JAVA=$(JAVA_PATH)/bin/java
JAVAC=$(JAVA_PATH)/bin/javac
OCAMLJAVA=ocamljava -java-extensions javalib.cmja str.cmja

CP=-annot -cp $(JAVA_PATH)/lib/ct.sym -cp $(PACK)

default: clean compile run

compile:
	$(JAVAC) $(PACK)/*.java
	$(OCAMLJAVA) $(CP) -c $(NAME).mli
	$(OCAMLJAVA) $(CP) -c $(NAME).ml
	$(OCAMLJAVA) $(CP) -c $(MAIN).mli
	$(OCAMLJAVA) $(CP) -c $(MAIN).ml
	$(OCAMLJAVA) $(CP) -c $(TEST).ml
	$(OCAMLJAVA) $(NAME).cmj $(MAIN).cmj $(TEST).cmj

run:
	$(JAVA) -cp camlprog.jar:. pack.ocamljavaMain

clean:
	rm -f camlprog.jar *.cm* *.jo $(PACK)/*.class *.annot


.PHONY: default compile run clean
