EXTERNAL_REFERENTS = core stories judgement

targets += $(ELVES).pdf
targets += $(GOBLINS).pdf

GOBLINS = The_Goblin_Hole
ELVES = Snail_Trails

DEPS += $(wildcard caves/*.tex)
DEPS += $(wildcard ex_cs/*.tex)
DEPS += commands.tex

dependencies += magick

include config/vars

config/vars:
	@git submodule update --init

config/rules.pdf:
	make -C config rules.pdf

$(DROSS)/characters.pdf: $(wildcard ex_cs/*) config/CS.tex
	$(COMPILER) -jobname=characters ex_cs/all.tex
$(DROSS)/$(GOBLINS).pdf: $(DEPS) qr.tex glossary.tex
	$(COMPILER) -jobname=$(GOBLINS) caves/main.tex

.PHONY: oneshot
caves: $(GOBLINS).pdf ## Oneshot cavern-based module
$(GOBLINS).pdf: $(DROSS)/$(GOBLINS).pdf $(DROSS)/characters.pdf config/rules.pdf
	@pdfunite $^ $@

DEPS += images/extracted/sundered.jpg images/extracted/enchanted.jpg

$(DROSS)/$(ELVES).pdf: $(DEPS) $(wildcard fey/*.tex) qr.tex
	$(COMPILER) -jobname=$(ELVES) fey/main.tex
.PHONY: oneshot
shellstack: $(ELVES).pdf ## Oneshot cavern-based module
$(ELVES).pdf: $(DROSS)/$(ELVES).pdf config/rules.pdf
	@pdfunite $^ $@

images/extracted/sundered.jpg: images/feylands.svg images/extracted/
	cat $< | \
	inkscape --pipe --export-type=png --export-area=230:30:470:150 -d 600 |\
	magick - -fill white -channel-fx '| gray=>alpha' $@

images/extracted/enchanted.jpg: images/feylands.svg images/extracted/
	cat $< | \
	inkscape --pipe --export-type=png --export-area=430:30:670:145 -d 600 |\
	magick - -fill white -channel-fx '| gray=>alpha' $@

$(DBOOK): $(DEPS) $(wildcard *.tex) ex_cs/ config/rules.pdf $(DROSS)/characters.pdf | qr.tex
	@$(COMPILER) main.tex
	@pdfunite $(DBOOK) $(DROSS)/characters.pdf config/rules.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(DBOOK)

.PHONY: creds
creds:
	cd images && pandoc artists.md -o ../art.pdf

