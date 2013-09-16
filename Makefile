BUILD = ocamlbuild -lib unix -lib str 
all:
	$(BUILD) make.byte
	./make.byte

graph: 
	$(BUILD) make.native
	./make.native --graph

www/epub/OEBPS/cover.png: cover.png
	convert cover.png -resize 600x800\> www/epub/OEBPS/cover.png

www/epub/OEBPS/map.png: map-athanor.png
	convert map-athanor.png -resize 600x800\> -size 600x800 'xc:white' +swap -gravity center -composite www/epub/OEBPS/map.png

ePub : www/epub/OEBPS/map.png www/epub/OEBPS/cover.png
	mkdir www/epub www/epub/META-INF www/epub/OEBPS || echo ''
	$(BUILD) make.byte
	./make.byte --ePub
	echo "application/epub+zip" -n > www/epub/mimetype
	cp epub/main.css www/epub/OEBPS
	cp epub/container.xml www/epub/META-INF
	cp epub/content.opf www/epub/OEBPS
	cp epub/*.htm www/epub/OEBPS
	cp epub/toc.ncx www/epub/OEBPS
	(cd www/epub ; zip -r ../book.epub *)

www/cover.eps: cover.png
	convert cover.png -resize 600x800\> www/cover.eps

www/map.eps: map-athanor.png
	convert map-athanor.png -resize 600x800\> -size 600x800 'xc:white' +swap -gravity center -composite www/map.eps

www/map-left.eps: map-athanor-left.png
	convert map-athanor-left.png -resize 1200x1900\> -size 1200x1900 'xc:white' +swap -gravity center -composite www/map-left.eps


www/map-right.eps: map-athanor-right.png
	convert map-athanor-right.png -resize 1200x1900\> -size 1200x1900 'xc:white' +swap -gravity center -composite www/map-right.eps

latex : www/cover.eps www/map-right.eps www/map-left.eps
	$(BUILD) make.byte
	./make.byte --latex
	rm -f www/*.log www/*.aux www/*.dvi www/*.pdf || echo 'Clean!'
	(cd www ; latex book.tex && latex book.tex && dvipdfm book.dvi)
#	(cd www ; pdflatex book.tex && pdflatex book.tex)

make.byte: 
	$(BUILD) make.byte

make.native: 
	$(BUILD) make.native

