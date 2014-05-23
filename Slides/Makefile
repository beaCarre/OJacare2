TARGET=present.pdf

all: $(TARGET)

open: all
	evince $(TARGET)
clean :
	rm -rf $(TARGET) $(TARGET:%.pdf=%.log) $(TARGET:%.pdf=%.aux) $(TARGET:%.pdf=%.out)

$(TARGET): $(TARGET:%.pdf=%.tex)
	pdflatex $< -o $@