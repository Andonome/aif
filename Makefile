include config/vars

output: $(BOOK).pdf

.switch-gls:
	@touch -r Makefile .switch-gls
qr.tex: README.md config/vars
	@printf '\qrcode[height=.2\\textwidth]{$(QR_TARGET)}' > qr.tex
config/vars:
	@git submodule update --init

config/booklet.pdf:
	make -C config booklet.pdf

$(BOOK).pdf: $(wildcard *.tex) rumours/ caves/ config/ config/booklet.pdf | qr.tex
	@$(COMPILER) main.tex
	@pdfunite $(BOOK).pdf config/booklet.pdf /tmp/out.pdf
	@mv /tmp/out.pdf $(BOOK).pdf

all: $(BOOK).pdf

creds:
	cd images && pandoc artists.md -o ../art.pdf

.PHONY: all
clean:
	$(CLEAN)
