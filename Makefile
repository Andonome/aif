EXTERNAL_REFERENTS = core stories judgement

booklet_files = $(wildcard enc/*.tex)
booklet_list = $(patsubst enc/%.tex, booklets/a7_%.tex, $(booklet_files) )
halfshots = $(patsubst enc/%.tex, %.pdf, $(booklet_files) )

pdfs += $(ELVES).pdf
pdfs += $(GOBLINS).pdf
pdfs += fridge.pdf
zines += cyoa_bino.pdf
zines += $(halfshots)
targets += a7l_cs.pdf
targets += cs_zine
output += booklets

GOBLINS = The_Goblin_Hole
ELVES = Snail_Trails

DEPS += commands.tex

dependencies += magick

DEPS += qr.tex 

vpath a7%.tex characters

include config/common.mk

config/common.mk:
	@git submodule update --init

config/rules.pdf:
	make -C $(@D) $(@F)

.PHONY: goblins
goblins: $(GOBLINS).pdf ## Oneshot cavern-based module
$(DROSS)/caves.pdf: glossary.tex $(DEPS) $(DROSS)/caves-switch-gls
$(GOBLINS).pdf: $(DROSS)/caves.pdf $(DROSS)/characters.pdf config/rules.pdf
	pdfjam --pdftitle $(GOBLINS) --pdfsubject "BIND RPG" \
	--pdfkeywords "RPG,TTRPG,roleplaying" \
	$^ \
	--outfile $@

.PHONY: shellstack
shellstack: $(ELVES).pdf ## Elven mayhem
$(DROSS)/fey.pdf: $(DEPS) $(DROSS)/fey-switch-gls images/extracted/sundered.jpg images/extracted/enchanted.jpg
$(ELVES).pdf: $(DROSS)/fey.pdf config/rules.pdf
	pdfunite $^ $@

images/extracted/sundered.jpg: images/feylands.svg | images/extracted/
	cat $< | \
	inkscape --pipe --export-type=png --export-area=230:30:470:150 -d 600 |\
	magick - -fill white -channel-fx '| gray=>alpha' $@

images/extracted/enchanted.jpg: images/feylands.svg | images/extracted/ images/extracted/sundered.jpg
	cat $< | \
	inkscape --pipe --export-type=png --export-area=430:30:670:145 -d 600 |\
	magick - -fill white -channel-fx '| gray=>alpha' $@

images/extracted/fridge.jpg: images/Dyson_Logos/bowels.svg | images/extracted/ images/extracted/fridge.jpg
	cat $< | inkscape --pipe \
	--select=layer1 --actions=delete \
	--export-type=png | \
	magick - -fill white -channel-fx '| gray=>alpha' \
	$@

##########

a7_cyoa_bino.pdf: ## CYOA but screen readable

cyoa_bino.pdf: ## CYOA for printing

number_of_parts != ls cyoa/pt_* | wc -l

zine_batch_one != seq 1 3 $(number_of_parts) | shuf | tr '\n' ' '
zine_batch_two != seq 2 3 $(number_of_parts) | shuf | tr '\n' ' '
zine_batch_three != seq 3 3 $(number_of_parts) | shuf | tr '\n' ' '
zine_part_nums = $(zine_batch_three) $(zine_batch_two) $(zine_batch_one)
zine_part_names = $(patsubst %, cyoa/pt_%.tex, $(zine_part_nums))

booklets/a7_cyoa_bino.tex: cyoa/head.tex $(zine_part_names) | booklets/
	cat $^ > $@
	printf '%s\n' '\ifnum\thepage<14\pagebreak\null\fi' >> $@
	printf '%s\n' '\ifnum\thepage<14\pagebreak\null\fi' >> $@
	printf '%s\n' '\end{document}' >> $@

$(halfshots): $(booklet_list)

a7l_cs.pdf: ## A7 example characters

booklets/a7_%.tex: enc/%.tex | booklets/
	$(CP) $< $@

.PHONY: cs_zine
cs_zine: cs.pdf ## Make A7 zine example characters
	make zine_characters.pdf

zine_characters.pdf: cs.pdf $(mini_spell_pdf)
	pdfunite $^ $@

