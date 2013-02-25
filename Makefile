all:
	ocamlbuild -lib unix make.byte
	./make.byte

graph: 
	ocamlbuild -lib unix make.native
	./make.native --graph

latex : 
	ocamlbuild -lib unix make.byte
	./make.byte --latex
	(cd www ; pdflatex book.tex && pdflatex book.tex)

make.byte: 
	ocamlbuild -lib unix make.byte

make.native: 
	ocamlbuild -lib unix make.native

