EXTERNAL_REFERENTS = core stories judgement

pdfs += $(ELVES).pdf
pdfs += $(GOBLINS).pdf

GOBLINS = The_Goblin_Hole
ELVES = Snail_Trails

DEPS += $(wildcard caves/*.tex)
DEPS += $(wildcard fey/*.tex)
DEPS += $(wildcard ex_cs/*.tex)
DEPS += commands.tex

dependencies += magick

DEPS += images/extracted/sundered.jpg images/extracted/enchanted.jpg

include config/vars

config/vars:
	@git submodule update --init

config/rules.pdf:
	make -C $(@D) $(@F)

$(DROSS)/caves.pdf: qr.tex

.PHONY: goblins
goblins: $(GOBLINS).pdf ## Oneshot cavern-based module
$(GOBLINS).pdf: $(DROSS)/caves.pdf $(DROSS)/ex_cs.pdf config/rules.pdf
	pdfjam --pdftitle $(GOBLINS) --pdfsubject "BIND RPG" \
	--pdfkeywords "RPG,TTRPG,roleplaying" \
	$^ \
	--outfile $@

.PHONY: shellstack
shellstack: $(ELVES).pdf ## Elven mayhem
$(DROSS)/fey.pdf: qr.tex $(DEPS) $(wildcard fey/*.tex) glossary.tex
$(ELVES).pdf: $(DROSS)/fey.pdf config/rules.pdf
	pdfunite $^ $@

images/extracted/sundered.jpg: images/feylands.svg images/extracted/
	cat $< | \
	inkscape --pipe --export-type=png --export-area=230:30:470:150 -d 600 |\
	magick - -fill white -channel-fx '| gray=>alpha' $@

images/extracted/enchanted.jpg: images/feylands.svg images/extracted/
	cat $< | \
	inkscape --pipe --export-type=png --export-area=430:30:670:145 -d 600 |\
	magick - -fill white -channel-fx '| gray=>alpha' $@

