include config/vars
GOBLINS = The_Goblin_Hole

output: $(BOOK).pdf

.switch-gls:
	@touch -r Makefile .switch-gls
qr.tex: README.md config/vars
	@printf '\qrcode[height=.2\\textwidth]{$(QR_TARGET)}' > qr.tex
config/vars:
	@git submodule update --init

config/booklet.pdf:
	make -C config booklet.pdf

$(GOBLINS).pdf: $(DEPS) config/booklet.pdf ex_cs/ caves/ | qr.tex
	$(COMPILER) -jobname=$(GOBLINS) caves/main.tex
	@pdfunite $(GOBLINS).pdf config/booklet.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(GOBLINS).pdf

$(BOOK).pdf: $(DEPS) ex_cs/ config/booklet.pdf caves/ | qr.tex
	@$(COMPILER) main.tex
	@pdfunite $(BOOK).pdf config/booklet.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(BOOK).pdf

all: $(BOOK).pdf $(GOBLINS).pdf

creds:
	cd images && pandoc artists.md -o ../art.pdf

.PHONY: all
clean:
	$(CLEAN)
