#!/bin/bash
git subtree -P config pull https://gitlab.com/FirstBloodRPG/config master
git subtree -P config push https://gitlab.com/FirstBloodRPG/config master
pdflatex -shell-escape main.tex
makeglossaries main
makeglossaries main.idx
pdflatex main.tex
