#!/bin/bash
[ -e ../config ] || git clone https://gitlab.com/FirstBloodRPG/config  ..
git subtree -P config pull ../clone master
git subtree -P config push ../clone aif
pdflatex -shell-escape main.tex
makeglossaries main
makeglossaries main.idx
pdflatex main.tex
