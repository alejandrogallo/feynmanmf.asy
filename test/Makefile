all: pdf

pdf:
	for i in *.asy; do \
		 asy -f pdf $$(basename $$i); \
		 echo $$i; \
	done

png: pdf
	for i in *.pdf; do \
		 convert -density 400 $$i $$(basename $$i .pdf).png; \
		 echo $$i; \
	done

jpg: pdf
	for i in *.pdf; do \
		 convert -density 400 $$i $$(basename $$i .pdf).jpg; \
		 echo $$i; \
	done

clean:
	-rm *.pdf
	-rm *.png
	-rm *.jpg
	-rm *.eps
