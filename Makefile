include config/vars

GOBLINS = The_Goblin_Hole

config/vars:
	@git submodule update --init

config/rules.pdf:
	make -C config rules.pdf

$(DROSS)/$(BOOK)_characters.pdf: $(DEPS) ex_cs/
	$(COMPILER) -jobname=$(BOOK)_characters ex_cs/all.tex
$(DROSS)/$(GOBLINS).pdf: $(DEPS) caves/ | qr.tex
	$(COMPILER) -jobname=$(GOBLINS) caves/main.tex

$(GOBLINS).pdf: $(DROSS)/$(GOBLINS).pdf $(DROSS)/$(BOOK)_characters.pdf config/rules.pdf
	@pdfunite $^ $@

$(DBOOK): $(DEPS) $(wildcard *.tex) enc/ ex_cs/ config/rules.pdf caves/ | qr.tex
	@$(COMPILER) main.tex
	@pdfunite $(DBOOK) config/rules.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(DBOOK)

all: $(RELEASE) $(GOBLINS).pdf

creds:
	cd images && pandoc artists.md -o ../art.pdf

.PHONY: all
clean:
	$(CLEAN)
