EXTERNAL_REFERENTS = core stories judgement

targets += $(ELVES).pdf
targets += $(GOBLINS).pdf

GOBLINS = The_Goblin_Hole
ELVES = Snail_Trails

DEPS += $(wildcard caves/*.tex)
DEPS += $(wildcard ex_cs/*.tex)
DEPS += commands.tex

include config/vars

config/vars:
	@git submodule update --init

config/rules.pdf:
	make -C config rules.pdf

$(DROSS)/characters.pdf: $(wildcard ex_cs/*)
	$(COMPILER) -jobname=characters ex_cs/all.tex
$(DROSS)/$(GOBLINS).pdf: $(DEPS) qr.tex
	$(COMPILER) -jobname=$(GOBLINS) caves/main.tex

.PHONY: oneshot
caves: $(GOBLINS).pdf ## Oneshot cavern-based module
$(GOBLINS).pdf: $(DROSS)/$(GOBLINS).pdf $(DROSS)/characters.pdf config/rules.pdf
	@pdfunite $^ $@

$(DROSS)/$(ELVES).pdf: $(DEPS) $(wildcard fey/*.tex) qr.tex
	$(COMPILER) -jobname=$(ELVES) fey/main.tex
.PHONY: oneshot
shellstack: $(ELVES).pdf ## Oneshot cavern-based module
$(ELVES).pdf: $(DROSS)/$(ELVES).pdf config/rules.pdf
	@pdfunite $^ $@

$(DBOOK): $(DEPS) $(wildcard *.tex) ex_cs/ config/rules.pdf $(DROSS)/characters.pdf | qr.tex
	@$(COMPILER) main.tex
	@pdfunite $(DBOOK) $(DROSS)/characters.pdf config/rules.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(DBOOK)

.PHONY: creds
creds:
	cd images && pandoc artists.md -o ../art.pdf

