#!/bin/bash
pdflatex -shell-escape main.tex
makeglossaries main
makeglossaries main.idx
pdflatex main.tex
