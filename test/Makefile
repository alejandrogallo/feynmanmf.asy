all: feynmanmf.asy pdf

TEST_SOURCES = $(filter-out feynmanmf.asy,$(wildcard *.asy))
SOURCES = $(TEST_SOURCES) ../feynmanmf.asy
PDF_FILES = $(patsubst %.asy,%.pdf,$(TEST_SOURCES))
JPG_FILES = $(patsubst %.asy,%.jpg,$(TEST_SOURCES))
PNG_FILES = $(patsubst %.asy,%.png,$(TEST_SOURCES))

../feynmanmf.asy:
	make -C .. feynmanmf.asy

feynmanmf.asy: ../feynmanmf.asy
	ln -s ../feynmanmf.asy feynmanmf.asy

$(PDF_FILES): ../feynmanmf.asy
$(PNG_FILES): ../feynmanmf.asy

pdf: $(PDF_FILES)
%.pdf: %.asy
	asy -f pdf $*.asy

png: $(PNG_FILES)
%.png: %.pdf
	convert -density 400 $< $@

jpg: $(JPG_FILES)
%.jpg: %.pdf
	convert -density 400 $< $@

clean:
	-rm $(wildcard feynmanmf.asy)
	-rm $(wildcard *.pdf) $(wildcard *.png) $(wildcard *.jpg) $(wildcard *.eps)
