BUILD = ocamlbuild -lib unix -lib str 
all:
	$(BUILD) make.byte
	./make.byte

graph: 
	$(BUILD) make.native
	./make.native --graph

latex : 
	$(BUILD) make.byte
	./make.byte --latex
	rm -f www/*.log www/*.aux www/*.dvi www/*.pdf || echo 'Clean!'
	(cd www ; latex book.tex && latex book.tex && dvipdfm book.dvi)
#	(cd www ; pdflatex book.tex && pdflatex book.tex)

make.byte: 
	$(BUILD) make.byte

make.native: 
	$(BUILD) make.native

