#!/bin/bash
if [ $1 = clean ]; then
	rm *aux *log main.{i,g}* *toc
	exit 0
fi

if [ $1 = tree ]; then
	git status
	git subtree -P config pull ../config master
	git subtree -P config push ../config aif
fi
pdflatex -shell-escape main.tex
makeglossaries main
makeglossaries main.idx
pdflatex main.tex
