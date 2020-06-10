VPATH = .:assets
vpath %.scss assets/css
vpath %.xml _site
vpath %.yaml spec

ANYTHING    = $(wildcard *)
MARKDOWN    = $(wildcard *.md)
SLIDES_PRE := $(patsubst %.md,_site/%.html,$(MARKDOWN))
SLIDES     := $(filter-out _site/README.html,$(SLIDES_PRE))

deploy : sitemap.xml $(SLIDES)

_site/%.html : %.md revealjs.yaml style.scss
	docker run --rm -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		pandoc/core:2.9.2.1 -o $@ -d spec/revealjs.yaml $<

_site/sitemap.xml : $(ANYTHING)
	docker run --rm -v "`pwd`:/srv/jekyll" \
		jekyll/builder:4.0 /bin/bash -c "chmod 777 /srv/jekyll && jekyll build"
