
### Specific to your application

MAIN      := main-visitorML
IDL       := formule
MLINCDIRS :=
MODULES   :=
LIBRARIES :=
PACK      := fr/upmc/infop6/mlo
CLASSES   := $(addprefix ${PACK}/,Formule Constante Var Non OpBin Et Ou Visiteur VisiteurTS VisiteurML MainML MainJava)
CBCLASSES :=

EXTRA_JAR_CLASSES := ${CLASSES}

include $(shell ocamlfind query ojacare)/Makefile.ojacare
