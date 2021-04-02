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
SASS    = $(wildcard *.scss)
ROOT    = $(wildcard *.md)
AULA    = $(wildcard _aula/*.md)
SLIDES := $(patsubst _aula/%.md,_site/slides/%.html,$(AULA))

deploy : _site $(SLIDES) $(AULA) $(ASSETS) $(CSS) $(ROOT) $(SASS) | _csl
	@bundle install \
		&& bundle exec jekyll build --future

tau0005.pdf : plano.pdf cronograma.pdf \
	trabalho-1-construcao.pdf trabalho-2-ordens.pdf trabalho-3-tipologia.pdf
	gs -dNOPAUSE -dBATCH -sDevice=pdfwrite \
		-sOutputFile=$@ $^

.slides : $(SLIDES) revealjs.yaml | _site _csl

_site :
	@test -e _site/.git || \
		gh repo clone tau0005 _site -- -b gh-pages --depth=1 --recurse-submodules
	@cd _site && git pull

	#docker run -v "`pwd`:/srv/jekyll" \
		#$(JEKYLL-PANDOC) /bin/bash -c "chmod 777 /srv/jekyll && jekyll build --future"

_site/slides/%.html : _aula/%.md revealjs.yaml biblio.bib | _csl _site/slides
	$(PANDOC/CROSSREF) -o $@ -d _spec/revealjs.yaml $<

%.pdf : %.tex biblio.bib
	docker run --rm -i -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		-v "`pwd`/assets/fonts/unb:/usr/share/fonts" blang/latex:ctanfull \
		latexmk -pdflatex="xelatex" -cd -f -interaction=batchmode -pdf $<

%.tex : %.md latex.yaml biblio.bib
	$(PANDOC/LATEX) -o $@ -d _spec/latex.yaml $<

serve : .slides
	@bundle exec jekyll serve --incremental

	#docker run -p 4000:4000 -h 127.0.0.1 \
		#-v "`pwd`:/srv/jekyll" -it $(JEKYLL-PANDOC) \
		#jekyll serve --skip-initial-build --no-watch

_csl :
	@gh repo clone citation-style-language/styles \
		$@ -- --depth=1

_site/slides : _site
	@mkdir -p _site/slides

clean :
	-@rm -r *.aux *.bbl *.bcf *.blg *.fls *.log _csl
