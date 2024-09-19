include config/vars

GOBLINS = The_Goblin_Hole

config/vars:
	@git submodule update --init

config/booklet.pdf:
	make -C config booklet.pdf

$(DROSS)/characters.pdf: $(DEPS) ex_cs/
	$(COMPILER) -jobname=characters ex_cs/all.tex
$(DROSS)/$(GOBLINS).pdf: $(DEPS) caves/ | qr.tex
	$(COMPILER) -jobname=$(GOBLINS) caves/main.tex

$(GOBLINS).pdf: $(DROSS)/$(GOBLINS).pdf $(DROSS)/characters.pdf config/booklet.pdf
	@pdfunite $^ $@

$(DBOOK): $(DEPS) ex_cs/ config/booklet.pdf caves/ | qr.tex
	@$(COMPILER) main.tex
	@pdfunite $(DBOOK) config/booklet.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(DBOOK)

all: $(RELEASE) $(GOBLINS).pdf

creds:
	cd images && pandoc artists.md -o ../art.pdf

.PHONY: all
clean:
	$(CLEAN)
