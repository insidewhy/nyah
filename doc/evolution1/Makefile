PAPER = proposal

.PHONY: pdf dvi clean

all: pdf html dvi

pdf: ${PAPER}.pdf

html: ${PAPER}.html

dvi: ${PAPER}.dvi

${PAPER}.dvi: ${PAPER}.tex
	latex ${PAPER}.tex

${PAPER}.html: ${PAPER}.tex
	tth $^

${PAPER}.pdf: ${PAPER}.dvi
	dvipdf $^

clean:
	rm -f ${PAPER}.{pdf,aux,dvi,html} proposal.log  texput.log
