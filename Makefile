VPATH = .:assets
vpath %.yaml spec
vpath %.scss assets/css
ANYTHING    = $(wildcard *)
MARKDOWN    = $(wildcard *.md)
SLIDES_PRE := $(patsubst %.md,_site/%.html,$(MARKDOWN))
SLIDES     := $(filter-out _site/README.html,$(SLIDES_PRE))

deploy : build slides

slides : $(SLIDES)

_site/%.html : %.md revealjs.yaml style.scss
	docker run --rm -v "`pwd`:/data" --user "`id -u`:`id -g`" \
		pandoc/core:2.9.2.1 -o $@ -d spec/revealjs.yaml $<

build : $(ANYTHING)
	docker run --rm -v "`pwd`:/srv/jekyll" \
		jekyll/builder:4.0 jekyll build

serve :
	docker run --rm -v "`pwd`:/srv/jekyll" \
		jekyll/builder:4.0 jekyll serve
