#!/bin/bash
git subtree -P config pull ../config master
git subtree -P config push ../config aif
pdflatex -shell-escape main.tex
makeglossaries main
makeglossaries main.idx
pdflatex main.tex
