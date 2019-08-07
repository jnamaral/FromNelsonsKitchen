SRC=$(wildcard *.tex)
PDF=$(SRC:%.tex=%.pdf)
HTML=$(SRC:%.tex=%.html)
INDEX_TEMPLATE="./index.temp"

all: html pdf

html: $(HTML)

pdf: $(PDF)

# The following set of commands generate the .html file from the .tex file
# Then it also generate the .html content to add the recipe to the page.
# The entries generated are put in a file called index.temp
# It creates, and then removes, a temporary file called llllixo

$(HTML): %.html: %.tex
	htlatex $< "xhtml,charset=utf-8" " -cunihtf -utf8"
	echo "<li> <a href=\""$(basename $<)".html\">" >> $(INDEX_TEMPLATE)
	grep recipeName $<|grep new|sed 's/\\newcommand \\recipeName {//'|sed 's/}//' >> $(INDEX_TEMPLATE)
	echo "</a> </li>" >>  $(INDEX_TEMPLATE)
	LC_ALL=C sed 's/\<title\>/\<link rel=\"shortcut icon\" href=\"favicon.ico\" type=\"image\/x-icon\" \/>\<title\>/g' "$(basename $<)".html > ~"$(basename $<)".html
	LC_ALL=C sed 's/class=\"td11\"\>\</class=\"td11\"  width=\"25%\"\>\</g' ~"$(basename $<)".html > "$(basename $<)".html
	LC_ALL=C sed 's/alt=\"PIC\"/alt=\"PIC\" width=\"100%\"/g' "$(basename $<)".html > ~"$(basename $<)".html
	LC_ALL=C sed 's/\<\/head\>/\<div class=\"container\"\>\<img src=\"FromNelsonsKitchen-Inner-Banner.jpg\" border=0 width=\"100%\" alt=\"From Nelsons Kitchen\" align=\"center\"\>\<\/div\>\<\/head\>/' ~"$(basename $<)".html > "$(basename $<)".html
	rm ~"$(basename $<)".html 

$(PDF): %.pdf: %.tex
	cp "$(basename $<)".tex ~"$(basename $<)".txt
	LC_ALL=C sed '/imageTable/d' ~"$(basename $<)".txt > "$(basename $<)".tex
	latexmk -gg -pdf -halt-on-error $<
	latexmk -c $<
	mv  ~"$(basename $<)".txt "$(basename $<)".tex

clean:
	cp index.html __index.html__
	rm -f *.out *.pdf *.html *.aux *.dvi *.log *.blg *.bbl *.tex-e *.4ct *.4tc *.css *.idv *.lg *.tmp *.xref *.temp *.synctex.gz
	mv __index.html__ index.html

cleantemp:
	cp index.html __index.html__
	rm -f *.out *.aux *.dvi *.log *.blg *.bbl *.tex-e *.4ct *.4tc *.idv *.lg *.tmp *.xref *.synctex.gz
	mv __index.html__ index.html
