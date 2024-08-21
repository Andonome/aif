include config/vars

GOBLINS = The_Goblin_Hole

config/vars:
	@git submodule update --init

config/booklet.pdf:
	make -C config booklet.pdf

$(DROSS)/$(GOBLINS).pdf: $(DEPS) config/booklet.pdf ex_cs/ caves/ | qr.tex
	$(COMPILER) -jobname=$(GOBLINS) caves/main.tex
	@pdfunite $(DROSS)/$(GOBLINS).pdf config/booklet.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(DROSS)/$(GOBLINS).pdf
$(GOBLINS).pdf: $(DROSS)/$(GOBLINS).pdf
	@$(CP) $< $@

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
