filename=main
output: svg-inkscape main.pdf
	pdflatex ${filename}.tex
svg-inkscape:
	pdflatex -shell-escape ${filename}.tex
main.pdf:
	pdflatex ${filename}.tex
tree:
	[ -e ../config ] || ( echo "You don't have a local config repo" && exit 1 )
	git status
	git subtree -P config pull ../config master || exit 1
	git subtree -P config push ../config master || exit 1

clean:
	rm -r *.{aux,toc,acn,acr,log,ptc,out,idx,ist,alg,glo} svg-inkscape 2>/dev/null
