.PHONY: test
.DEFAULT_GOAL := test

clean:
	-rm -f test/*.pdf
	-rm -f test/feynmanmf.asy

test:
	ln -s -f ../feynmanmf.asy test/feynmanmf.asy
	$(MAKE) -C test

readme-imgs:
	make -C test png
	for i in test/*.png; do \
		echo "### \`$$i\`" | tee -a README.md; \
		echo \
			"![$$i](https://github.com/alejandrogallo/feynmanmf.asy/raw/images/$$i)" \
			| tee -a README.md; \
	done

update-images:
	make -C test png
	mv test new_test
	git checkout images
	git reset --hard af177b5
	mv new_test test
	git add -f test/*.png
	git commit -m "Update test images"
	git push -f origin images
