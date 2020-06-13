VPATH = .:assets
vpath %.html .:_includes:_layouts:_site
vpath %.scss assets/css
vpath %.xml _site
vpath %.yaml spec

ANYTHING    = $(wildcard *)
BUT        := $(filter-out *.md,$(ANYTHING))
MARKDOWN    = $(wildcard *.md)
SLIDES_PRE := $(patsubst %.md,%.html,$(MARKDOWN))
SLIDES     := $(filter-out README.html,$(SLIDES_PRE))

deploy : sitemap.xml $(SLIDES)

_site/sitemap.xml : $(BUT) README.md
	docker run --rm -v "`pwd`:/srv/jekyll" \
		jekyll/builder:4.1.0 /bin/bash -c "chmod 777 /srv/jekyll && jekyll build"

%.html : %.md revealjs.yaml
	docker run --rm -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		pandoc/core:2.9.2.1 -o $@ -d spec/revealjs.yaml $<
	mv $@ _site/

clean :
	rm -rf _site
