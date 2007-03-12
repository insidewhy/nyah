PAPER = proposal

.PHONY: pdf dvi clean

pdf: ${PAPER}.pdf

dvi: ${PAPER}.dvi

${PAPER}.dvi:
	latex ${PAPER}.tex

${PAPER}.pdf: ${PAPER}.dvi
	dvipdf $^

clean:
	rm -f ${PAPER}.{pdf,aux,dvi} proposal.log  texput.log
