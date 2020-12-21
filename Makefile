VPATH = .:assets
vpath %.html .:_includes:_layouts:_site
vpath %.scss _sass:assets/css
vpath %.xml _site

SASS      = $(wildcard *.scss)
ANYTHING  = $(filter-out _site,$(wildcard *))
MARKDOWN  = $(filter-out README.md,$(wildcard *.md))
REVEALJS  = $(wildcard [0-9][0-9]-*.md)
SLIDES   := $(patsubst %.md,_site/%.html,$(REVEALJS))
PAGES    := $(filter-out $(REVEALJS),$(ANYTHING))
PANDOC/CROSSREF := pandoc/crossref:2.11.2
PANDOC/LATEX    := pandoc/latex:2.11.2

deploy : jekyll slides

slides : $(SLIDES)

_site : $(PAGES) $(SASS) _config.yaml
	docker run -v "`pwd`:/srv/jekyll" \
		jekyll/jekyll:4.1.0 /bin/bash -c \
		"chmod 777 /srv/jekyll && jekyll build --future"

_site/%.html : %.md revealjs.yaml biblio.bib | _styles _site
	docker run -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		$(PANDOC/CROSSREF) -o $@ -d revealjs.yaml $<

_site/%-notas.html : %.md notas.yaml biblio.bib | _styles _site
	docker run -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		$(PANDOC/CROSSREF) -o $@ -d revealjs.yaml $<

biblio.bib : basica.bib complementar.bib
	cat $^ > $@

serve :
	docker run -p 4000:4000 -h 127.0.0.1 \
		-v "`pwd`:/srv/jekyll" -it jekyll/jekyll:4.1.0 \
		jekyll serve --skip-initial-build --no-watch

_styles :
	git clone https://github.com/citation-style-language/styles.git _styles
