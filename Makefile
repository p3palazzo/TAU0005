# {{{1 Variables
#      =========

VPATH = .:assets
vpath %.bib _bibliography
vpath %.csl _csl
vpath %.html .:_includes:_layouts:_site
vpath %.scss _sass:assets/css:assets/css-slides
vpath %.xml _site
vpath %.yaml .:_spec

PANDOC_VERSION  := 2.14
JEKYLL_VERSION  := 4.2.0
PANDOC/CROSSREF := docker run --rm -v "`pwd`:/data" \
	-u "`id -u`:`id -g`" pandoc/crossref:$(PANDOC_VERSION)
PANDOC/LATEX    := docker run --rm -v "`pwd`:/data" \
	-v "`pwd`/assets/fonts:/usr/share/fonts" \
	-u "`id -u`:`id -g`" pandoc/latex:$(PANDOC_VERSION)
JEKYLL := palazzo/jekyll-tufte:$(JEKYLL_VERSION)-$(PANDOC_VERSION)

ASSETS  = $(wildcard assets/*)
SASS    = assets/css-slides/revealjs.scss _sass/_settings.scss reveal.js/.git
AULA    = $(wildcard _aula/*.md)
SLIDES := $(patsubst _aula/%.md,_site/slides/%/index.html,$(AULA))

# {{{1 Recipes
#      =======
.PHONY : _site
_site : $(SLIDES) \
	| _csl/chicago-fullnote-bibliography-with-ibid.csl
	@docker run --rm -v "`pwd`:/srv/jekyll" \
		$(JEKYLL) /bin/bash -c "chmod 777 /srv/jekyll && jekyll build --future"

tau0005.pdf : plano.pdf cronograma.pdf \
	trabalho-1-construcao.pdf trabalho-2-ordens.pdf trabalho-3-tipologia.pdf
	gs -dNOPAUSE -dBATCH -sDevice=pdfwrite \
		-sOutputFile=$@ $^

_site/slides/%/index.html : _aula/%.md revealjs.yaml revealjs-crossref.yaml \
	references.bib $(SASS) \
	| _csl/chicago-author-date.csl
	@-mkdir -p $(@D)
	@$(PANDOC/CROSSREF) -o $@ -d _spec/revealjs.yaml $<
	@echo $(@D)/

%.pdf : %.tex references.bib
	@docker run --rm -i -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		-v "`pwd`/assets/fonts/unb:/usr/share/fonts" blang/latex:ctanfull \
		latexmk -pdflatex="xelatex" -cd -f -interaction=batchmode -pdf $<
	@echo $@

%.tex : %.md latex.yaml references.bib
	$(PANDOC/LATEX) -o $@ -d _spec/latex.yaml $<

_csl/%.csl : | _csl
	@cd _csl && git checkout master -- $(@F)
	@echo "Checked out $(@F)."

reveal.js :
	@test -e $@ || \
		git submodule add https://github.com/hakimel/reveal.js

# {{{1 PHONY
#      =====

_csl :
	@echo "Fetching CSL styles..."
	@test -e $@ || \
		git clone --depth=1 --filter=blob:none --no-checkout \
		https://github.com/citation-style-language/styles.git \
		$@

.PHONY : serve
serve : $(SLIDES) \
	| _csl/chicago-fullnote-bibliography-with-ibid.csl
	@docker run --rm -v "`pwd`:/srv/jekyll" \
		-h "0.0.0.0:127.0.0.1" -p "4000:4000" \
		$(JEKYLL) jekyll serve --future

.PHONY : clean
clean :
	-@rm -rf *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.run.xml \
		tau0005-*.tex _csl

.PHONY : submodule-update
submodule-update : | _sass _spec assets/css-slides reveal.js
	@echo 'Updating _sass...'
	@cd _sass && git checkout master && git pull --ff-only
	@echo 'Updating _spec...'
	@cd _spec && git checkout master && git pull --ff-only
	@echo 'Updating assets/css-slides...'
	@cd assets/css-slides && git checkout master && git pull --ff-only

# vim: set foldmethod=marker shiftwidth=2 tabstop=2 :
