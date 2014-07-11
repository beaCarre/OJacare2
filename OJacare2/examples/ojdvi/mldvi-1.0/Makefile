# mldvi - A DVI previewer
# Copyright (C) 2000  Alexandre Miquel
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# See the GNU Lesser General Public License version 2.1 for more
# details (enclosed in the file LGPL).

OCAMLC    = ocamlc
OCAMLOPT  = ocamlopt.opt -unsafe -inline 9
OCAMLDEP  = ocamldep

MLINCDIRS =
CLIBDIRS  = /usr/X11R6/lib

EXEC      = mldvi
MODULES   = table pkfont search font glyph devfont dvi driver\
	    grdev units dviview main
LIBRARIES = graphics unix
CLIBS     = unix graphics X11

CMO_OBJS  = $(addsuffix .cmo, $(MODULES))
CMX_OBJS  = $(addsuffix .cmx, $(MODULES))
CMA_OBJS  = $(addsuffix .cma, $(LIBRARIES))
CMXA_OBJS = $(addsuffix .cmxa, $(LIBRARIES))

BYTE_OBJS = $(CMA_OBJS) $(CMO_OBJS)
OPT_OBJS  = $(CMXA_OBJS) $(CMX_OBJS)

INCLUDES  = $(addprefix -I , $(MLINCDIRS))
LINK_OPTS = $(addprefix -ccopt -L, $(CLIBDIRS)) \
	    $(addprefix -cclib -l, $(CLIBS))

byte: $(EXEC)
opt: $(EXEC).opt
all: byte opt

$(EXEC): $(CMO_OBJS)
	$(OCAMLC) -custom $(INCLUDES) $(BYTE_OBJS) $(LINK_OPTS) -o $(EXEC)

$(EXEC).opt: $(CMX_OBJS)
	$(OCAMLOPT) $(INCLUDES) $(OPT_OBJS) $(LINK_OPTS) -o $(EXEC).opt

.SUFFIXES:
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.mli.cmi:
	$(OCAMLC) $(INCLUDES) -c $<

.ml.cmo:
	$(OCAMLC) $(INCLUDES) -c $<

.ml.cmx:
	$(OCAMLOPT) $(INCLUDES) -c $<

count:
	wc -l *.ml *.mli | sort

clean:
	rm -f *.cm[oix] *.o $(EXEC) $(EXEC).opt *~ .depend

.depend: *.mli *.ml
	$(OCAMLDEP) $(INCLUDES) *.mli *.ml > .depend

include .depend
