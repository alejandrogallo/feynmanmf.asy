.PHONY: test
.DEFAULT_GOAL := test

clean:
	-rm -f test/*.pdf
	-rm -f test/feynmanmf.asy

test:
	ln -s -f ../feynmanmf.asy test/feynmanmf.asy
	$(MAKE) -C test
