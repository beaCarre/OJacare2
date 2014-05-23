TARGET=schemasCompil.pdf

all: $(TARGET)

open: all
	evince $(TARGET)
clean :
	rm -rf $(TARGET) $(TARGET:%.pdf=%.log) $(TARGET:%.pdf=%.aux)

$(TARGET): $(TARGET:%.pdf=%.tex)
	pdflatex $< -o $@