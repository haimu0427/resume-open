PDF := resume-zh.pdf
SRC := resume-zh.tex
DEPS := resume.cls

all: $(PDF)
zh: $(PDF)

$(PDF): $(SRC) $(DEPS)
	latexmk -xelatex $(SRC)

clean:
	latexmk -c $(SRC)

cleanall:
	latexmk -C $(SRC)

.PHONY: all zh clean cleanall
