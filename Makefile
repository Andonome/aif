include config/vars

output: $(BOOK).pdf

.switch-gls:
	@touch -r Makefile .switch-gls
config/vars:
	@git submodule update --init

$(BOOK).pdf: $(wildcard *.tex) rumours/ caves/ config/
	@$(COMPILER) main.tex

all: $(BOOK).pdf

creds:
	cd images && pandoc artists.md -o ../art.pdf

.PHONY: all
clean:
	$(CLEAN)
