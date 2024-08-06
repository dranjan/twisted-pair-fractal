SOURCES=$(wildcard *.sage)
NOTEBOOKS=$(patsubst %.sage,%.ipynb,$(SOURCES))

notebooks: $(NOTEBOOKS)

clean:
	rm -f $(NOTEBOOKS)

%.ipynb: %.sage
	jupytext --to notebook --execute $<
