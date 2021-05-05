VPATH = .:assets
vpath %.html .:_includes:_layouts:_site
vpath %.scss _sass:assets/css
vpath %.xml _site
vpath %.yaml .:_spec

PANDOC_VERSION  := 2.12
JEKYLL_VERSION  := 4.2.0
PANDOC/CROSSREF := docker run --rm -v "`pwd`:/data" \
	-u "`id -u`:`id -g`" pandoc/crossref:$(PANDOC_VERSION)
PANDOC/LATEX    := docker run --rm -v "`pwd`:/data" \
	-v "`pwd`/assets/fonts:/usr/share/fonts" \
	-u "`id -u`:`id -g`" pandoc/latex:$(PANDOC_VERSION)
JEKYLL := palazzo/jekyll-tufte:$(JEKYLL_VERSION)-$(PANDOC_VERSION)

ASSETS  = $(wildcard assets/*)
FONTS   = $(wildcard assets/fonts/*)
SASS    = $(wildcard assets/css/*.scss) $(wildcard assets/css-slides/*.scss) $(wildcard _sass/*.scss)
ROOT    = $(wildcard *.md)
AULA    = $(wildcard _aula/*.md)
SLIDES := $(patsubst _aula/%.md,_site/slides/%.html,$(AULA))

_site : $(SLIDES) \
	| _csl/chicago-fullnote-bibliography-with-ibid.csl
	docker run --rm -v "`pwd`:/srv/jekyll" \
		$(JEKYLL) /bin/bash -c "chmod 777 /srv/jekyll && jekyll build"

tau0005.pdf : plano.pdf cronograma.pdf \
	trabalho-1-construcao.pdf trabalho-2-ordens.pdf trabalho-3-tipologia.pdf
	gs -dNOPAUSE -dBATCH -sDevice=pdfwrite \
		-sOutputFile=$@ $^

_site/slides/%.html : _aula/%.md revealjs.yaml revealjs-crossref.yaml \
	_biblio.bib $(SASS) \
	| _csl/chicago-author-date.csl _site/slides
	$(PANDOC/CROSSREF) -o $@ -d _spec/revealjs.yaml $<

_site/slides :
	-@mkdir -p _site/slides

%.pdf : %.tex _biblio.bib
	docker run --rm -i -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		-v "`pwd`/assets/fonts/unb:/usr/share/fonts" blang/latex:ctanfull \
		latexmk -pdflatex="xelatex" -cd -f -interaction=batchmode -pdf $<

%.tex : %.md latex.yaml _biblio.bib
	$(PANDOC/LATEX) -o $@ -d _spec/latex.yaml $<

_csl/%.csl : | _csl
	@cd _csl && git checkout master -- $(@F)
	@echo "Checked out $(@F)."

# {{{1 PHONY
#      =====

.PHONY : _csl
_csl :
	@echo "Fetching CSL styles..."
	@test -e $@ || \
		git clone --depth=1 --filter=blob:none --no-checkout \
		https://github.com/citation-style-language/styles.git \
		$@

.PHONY : serve
serve : _site
	docker run --rm -v "`pwd`:/srv/jekyll" \
		-h "0.0.0.0:127.0.0.1" -p "4000:4000" \
		$(JEKYLL) jekyll serve

.PHONY : clean
clean :
	-@rm -rf *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.run.xml \
		tau0005-*.tex _csl

# vim: set foldmethod=marker shiftwidth=2 tabstop=2 :
