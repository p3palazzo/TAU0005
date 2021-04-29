VPATH = .:assets
vpath %.html .:_includes:_layouts:_site
vpath %.scss _sass:assets/css
vpath %.xml _site
vpath %.yaml .:_spec

PANDOC/CROSSREF := docker run --rm -v "`pwd`:/data" \
	--user "`id -u`:`id -g`" pandoc/crossref:2.12
PANDOC/LATEX    := docker run --rm --user "`id -u`:`id -g`" \
	-v "`pwd`:/data" -v "`pwd`/assets/fonts:/usr/share/fonts" \
	pandoc/latex:2.12
JEKYLL-PANDOC   := palazzo/jekyll-tufte:4.2.0-2.12

ASSETS  = $(wildcard assets/*)
CSS     = $(wildcard assets/css/*)
FONTS   = $(wildcard assets/fonts/*)
SASS    = $(wildcard assets/css/*.scss) $(wildcard _sass/*.scss)
ROOT    = $(wildcard *.md)
AULA    = $(wildcard _aula/*.md)
SLIDES := $(patsubst _aula/%.md,_site/slides/%.html,$(AULA))

deploy : _site $(SLIDES) \
	| _csl/chicago-fullnote-bibliography-with-ibid.csl
	@bundle update \
		&& bundle exec jekyll build

tau0005.pdf : plano.pdf cronograma.pdf \
	trabalho-1-construcao.pdf trabalho-2-ordens.pdf trabalho-3-tipologia.pdf
	gs -dNOPAUSE -dBATCH -sDevice=pdfwrite \
		-sOutputFile=$@ $^

.slides : $(SLIDES)

_site/slides/%.html : _aula/%.md revealjs.yaml revealjs-crossref.yaml \
	biblio.bib $(SASS) \
	| _csl/chicago-author-date.csl _site/slides
	$(PANDOC/CROSSREF) -o $@ -d _spec/revealjs.yaml $<

%.pdf : %.tex biblio.bib
	docker run --rm -i -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		-v "`pwd`/assets/fonts/unb:/usr/share/fonts" blang/latex:ctanfull \
		latexmk -pdflatex="xelatex" -cd -f -interaction=batchmode -pdf $<

%.tex : %.md latex.yaml biblio.bib
	$(PANDOC/LATEX) -o $@ -d _spec/latex.yaml $<

_csl/%.csl : | _csl
	@cd _csl && git checkout master -- $(@F)
	@echo "Checked out $(@F)."

# {{{1 PHONY
#      =====

.PHONY : _site
_site :
	@test -e _site/.git && cd _site && git pull || \
		git clone --depth=1 git@github.com:p3palazzo/tau0006.git \
		$@

.PHONY : _csl
_csl :
	@echo "Fetching CSL styles..."
	@test -e $@ || \
		git clone --depth=1 --filter=blob:none --no-checkout \
		https://github.com/citation-style-language/styles.git \
		$@

.PHONY : serve
serve : _site
	@bundle update \
		&& bundle exec jekyll serve

.PHONY : clean
clean :
	-@rm -rf *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.run.xml \
		tau0005-*.tex _csl

# vim: set foldmethod=marker shiftwidth=2 tabstop=2 :
