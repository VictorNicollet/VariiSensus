all:
	ocamlbuild -lib unix make.byte
	./make.byte

graph: 
	ocamlbuild -lib unix make.native
	./make.native --graph

make.byte: 
	ocamlbuild -lib unix make.byte

make.native: 
	ocamlbuild -lib unix make.native

