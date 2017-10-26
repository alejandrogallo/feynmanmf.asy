all: pdf

pdf:
	for i in *.asy; do \
		 asy -f pdf $$(basename $$i); \
	done

png:
	for i in *.asy; do \
		 asy -f png $$(basename $$i); \
	done

svg:
	for i in *.asy; do \
		 asy -f svg $$(basename $$i); \
	done

clean:
	-rm *.pdf
	-rm *.png
