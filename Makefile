EXTERNAL_REFERENTS = core stories judgement

pdfs += $(ELVES).pdf
pdfs += $(GOBLINS).pdf
pdfs += minizine.pdf

GOBLINS = The_Goblin_Hole
ELVES = Snail_Trails

DEPS += $(wildcard fridge/*.tex)
DEPS += $(wildcard shrooms/*.tex)
DEPS += $(wildcard caves/*.tex)
DEPS += $(wildcard fey/*.tex)
DEPS += images/extracted/sundered.jpg images/extracted/enchanted.jpg

DEPS += $(wildcard characters/*.tex)
DEPS += commands.tex

dependencies += magick

DEPS += qr.tex 

include config/vars

config/vars:
	@git submodule update --init

config/rules.pdf:
	make -C $(@D) $(@F)

.PHONY: goblins
goblins: $(GOBLINS).pdf ## Oneshot cavern-based module
$(DROSS)/caves.pdf: glossary.tex $(DEPS)
$(GOBLINS).pdf: $(DROSS)/caves.pdf $(DROSS)/characters.pdf config/rules.pdf
	pdfjam --pdftitle $(GOBLINS) --pdfsubject "BIND RPG" \
	--pdfkeywords "RPG,TTRPG,roleplaying" \
	$^ \
	--outfile $@

.PHONY: shellstack
shellstack: $(ELVES).pdf ## Elven mayhem
$(DROSS)/fey.pdf: $(DEPS)
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

images/extracted/fridge.jpg: images/Dyson_Logos/bowels.svg images/extracted/
	cat $< | inkscape --pipe \
	--select=layer1 --actions=delete \
	--export-type=png | \
	magick - -fill white -channel-fx '| gray=>alpha' \
	$@

##########

a7_minizine.pdf: ## CYOA but scren readable

minizine.pdf: ## CYOA for printing

number_of_parts != ls cyoa/pt_* | wc -l

zine_batch_one != seq 1 3 $(number_of_parts) | sort -R | tr '\n' ' '
zine_batch_two != seq 2 3 $(number_of_parts) | sort -R | tr '\n' ' '
zine_batch_three != seq 3 3 $(number_of_parts) | sort -R | tr '\n' ' '
zine_part_nums = $(zine_batch_three) $(zine_batch_two) $(zine_batch_one)
zine_part_names = $(patsubst %, cyoa/pt_%.tex, $(zine_part_nums))

a7_minizine/main.tex: cyoa/head.tex $(zine_part_names) | a7_minizine/
	cat $^ > $@
	printf '%s\n' '\end{document}' >> $@
