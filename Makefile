VPATH = .:assets
vpath %.html .:_includes:_layouts:_site
vpath %.scss assets/css
vpath %.xml _site
vpath %.yaml spec

ANYTHING    = $(wildcard *)
BUT        := $(filter-out *.md,$(ANYTHING))
MARKDOWN    = $(wildcard *.md)
SLIDES_PRE := $(patsubst %.md,_site/%.html,$(MARKDOWN))
SLIDES     := $(filter-out _site/README.html,$(SLIDES_PRE))

deploy : sitemap.xml $(SLIDES)

_site/sitemap.xml : $(BUT) README.md
	docker run --rm -v "`pwd`:/srv/jekyll" \
		jekyll/jekyll:4.1.0 /bin/bash -c "chmod 777 /srv/jekyll && jekyll build"

_site/%.html : %.md revealjs.yaml
	docker run --rm -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		pandoc/core:2.9.2.1 -o $@ -d spec/revealjs.yaml $<

serve :
	docker run --rm -p 4000:4000 -h 127.0.0.1 \
		-v "`pwd`:/srv/jekyll" -it jekyll/jekyll:4.1.0 \
		jekyll serve --skip-initial-build --no-watch
