#	$Id: Makefile,v 1.6 2004/03/28 02:45:09 henry Exp $

include ../Makefile.config

# Nom de l'éxécutable
EXEC = point

# Liste des fichiers IDL
IDL       = p

# Liste des répertoires contenant les modules et bibliotèques Caml utilisées
MLINCDIRS = 

# Liste des modules Caml 
MODULES   = 

# Liste des bibliothèques Caml à inclure à l'édition de lien
LIBRARIES = 

# Liste des bibliothèques C à inclure à l'édition de lien
CLIBS     = 

# Liste des classes Java à compiler
CLASS     = mypack/Point mypack/Colored mypack/ColoredPoint mypack/Cloud mypack/Main

# Liste des classes Java ayant l'attribut callback 
CBCLASS   = mypack/ColoredPoint

run: $(addsuffix .class, $(CLASS)) $(addsuffix .class, $(addprefix callback/, $(CBCLASS))) libOCaml.so
	LD_LIBRARY_PATH=.:`ocamlfind printconf destdir`/camljava:`ocamlc -where` CLASSPATH=.:mypack:callback/mypack:`ocamlfind printconf destdir`/camljava/camljava.jar java Main

cmo.o: p.cmo main-point.cmo
	ocamlfind ocamlc -verbose -output-obj -o cmo.o -package camljava,ojacare  -linkpkg     p.cmo  main-point.cmo

libOCaml.so: cmo.o
	ld -shared cmo.o -L`ocamlc -where` -L`ocamlfind printconf destdir`/camljava -lcamljni_shared -lcamlrun_shared -ldl -lm -lncurses -o $@ 

clean::
	rm *.so

include $(OJACAREDIR)/Makefile.include
