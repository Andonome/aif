EXTERNAL_REFERENTS = core stories judgement

include config/vars

GOBLINS = The_Goblin_Hole

config/vars:
	@git submodule update --init

config/rules.pdf:
	make -C config rules.pdf

DEPS += $(wildcard caves/*.tex)
DEPS += $(wildcard ex_cs/*.tex)

$(DROSS)/characters.pdf: $(wildcard ex_cs/*)
	$(COMPILER) -jobname=characters ex_cs/all.tex
$(DROSS)/$(GOBLINS).pdf: $(DEPS) qr.tex
	$(COMPILER) -jobname=$(GOBLINS) caves/main.tex

.PHONY: oneshot
oneshot: $(GOBLINS).pdf ## Oneshot cavern-based module
$(GOBLINS).pdf: $(DROSS)/$(GOBLINS).pdf $(DROSS)/characters.pdf config/rules.pdf
	@pdfunite $^ $@

$(DBOOK): $(DEPS) $(wildcard *.tex) ex_cs/ config/rules.pdf caves/ | qr.tex
	@$(COMPILER) main.tex
	@pdfunite $(DBOOK) config/rules.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(DBOOK)

targets += $(GOBLINS).pdf

.PHONY: creds
creds:
	cd images && pandoc artists.md -o ../art.pdf

