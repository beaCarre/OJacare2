#	$Id: Makefile,v 1.4 2004/03/28 02:45:09 henry Exp $

include ../Makefile.config

EXEC       = visitorML
MLINCDIRS  = 
IDL        = formule
MODULES    = 
LIBRARIES  = 
CLIBS      = 
MLOCLASS   = Formule Constante Var Non OpBin Et Ou Visiteur \
		VisiteurTS VisiteurML MainML MainJava
CLASS      = $(addprefix fr/upmc/infop6/mlo/,$(MLOCLASS))
MLOCBCLASS = VisiteurML MainML
CBCLASS    = $(addprefix fr/upmc/infop6/mlo/,$(MLOCBCLASS))

include $(OJACAREDIR)/Makefile.include