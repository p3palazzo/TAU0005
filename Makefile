VPATH = .:assets
vpath %.html .:_includes:_layouts:_site
vpath %.scss _sass:assets/css
vpath %.xml _site

SASS      = $(wildcard *.scss)
ANYTHING  = $(filter-out _site,$(wildcard *))
MARKDOWN  = $(filter-out README.md,$(wildcard *.md))
AULAS     = $(wildcard [0-9][0-9]-*.md)
SLIDES   := $(patsubst %.md,_slides/%.html,$(AULAS))
NOTAS    := $(patsubst %.md,_notas/%.md,$(AULAS))
PAGES    := $(filter-out $(AULAS),$(MARKDOWN))

PANDOC/CROSSREF := docker run -v "`pwd`:/data" \
	--user "`id -u`:`id -g`" pandoc/crossref:2.11.2
PANDOC/LATEX    := docker run --user "`id -u`:`id -g`" \
	-v "`pwd`:/data" -v "`pwd`/assets/fonts:/usr/share/fonts" \
	pandoc/latex:2.11.2

deploy : _site slides notas

slides : $(SLIDES)

notas : $(NOTAS)

_site : $(NOTAS) $(SLIDES) $(PAGES) $(SASS) _config.yaml
	docker run -v "`pwd`:/srv/jekyll" \
		jekyll/jekyll:4.1.0 /bin/bash -c \
		"chmod 777 /srv/jekyll && jekyll build --future"

_slides/%.html : %.md revealjs.yaml biblio.bib | _styles _slides
	$(PANDOC/CROSSREF) -o $@ -d revealjs.yaml $<

_site/%.html : %.md revealjs.yaml biblio.bib | _styles _site
	$(PANDOC/CROSSREF) -o $@ -d notas.yaml $<

_notas/%.html : %.md notas.yaml biblio.bib | _styles _notas
	$(PANDOC/CROSSREF) -o $@ -d notas.yaml $<

%.pdf : %.tex biblio.bib
	docker run -i -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		-v "`pwd`/assets/fonts/unb:/usr/share/fonts" blang/latex:ctanfull \
		latexmk -pdflatex="xelatex" -cd -f -interaction=batchmode -pdf $<

%.tex : %.md latex.yaml biblio.bib
	$(PANDOC/LATEX) -o $@ -d latex.yaml $<

serve :
	docker run -p 4000:4000 -h 127.0.0.1 \
		-v "`pwd`:/srv/jekyll" -it jekyll/jekyll:4.1.0 \
		jekyll serve --skip-initial-build --no-watch

_styles :
	git clone https://github.com/citation-style-language/styles.git _styles

_notas :
	mkdir -p _notas

_slides :
	mkdir -p _slides

clean :
	@rm *.aux *.bbl *.bcf *.blg *.fls *.log
