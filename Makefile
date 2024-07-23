include config/vars

output: $(BOOK).pdf

.switch-gls:
	@touch -r Makefile .switch-gls
config/vars:
	@git submodule update --init

config/booklet.pdf:
	make -C config booklet.pdf

$(BOOK).pdf: $(wildcard *.tex) rumours/ caves/ config/
	@$(COMPILER) main.tex
	@pdfunite $(BOOK).pdf config/booklet.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(BOOK).pdf

all: $(BOOK).pdf

creds:
	cd images && pandoc artists.md -o ../art.pdf

.PHONY: all
clean:
	$(CLEAN)
