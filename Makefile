.PHONY: test
.DEFAULT_GOAL := test

clean:
	-rm -f test/*.pdf
	-rm -f test/feynmanmf.asy

test:
	cp feynmanmf.asy test/
	$(MAKE) -C test
