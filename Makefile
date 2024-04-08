# {{{1 Variables
#      =========
VPATH = . assets
vpath %.bib _bibliography
vpath %.html . _includes _layouts _site
vpath %.scss _sass slides/reveal.js/css/theme/template
vpath %.yaml . _spec _data

PANDOC_V  := 3.1.1
JEKYLL_V  := 4.2.2
PANDOC := docker run --rm -v "`pwd`:/data" \
	-u "`id -u`:`id -g`" pandoc/core:$(PANDOC_V)
JEKYLL := palazzo/jekyll-pandoc:$(JEKYLL_V)-$(PANDOC_V)

ASSETS  = $(wildcard assets/*)
SASS    = _revealjs-settings.scss \
					mixins.scss settings.scss theme.scss

AULA    = $(wildcard _src/aula/*.md)
PLAN    = $(wildcard _src/plano/*.md)
TRAB    = $(wildcard _src/trabalho/*.md)
AULA_GFM= $(patsubst _src/aula/%.md,_aula/%.md,$(AULA))
PLAN_GFM= $(patsubst _src/plano/%.md,_plano/%.md,$(PLAN))
TRAB_GFM= $(patsubst _src/trabalho/%.md,_trabalho/%.md,$(TRAB))
SLIDES  = $(patsubst _src/aula/%.md,slides/%/index.html,$(AULA))

# {{{1 Recipes
#      =======
.PHONY : _site
_site : docs
	@echo "####################"
	bundle exec jekyll build --future

docs: $(AULA_GFM) $(PLAN_GFM) $(TRAB_GFM) $(SLIDES)

_aula/%.md : _src/aula/%.md biblio.yaml defaults.yaml
	@-mkdir -p $(@D)
	@pandoc -o $@ -d _data/defaults.yaml $<
	@echo "$@"

_plano/%.md : _src/plano/%.md biblio.yaml defaults.yaml
	@-mkdir -p $(@D)
	@pandoc -o $@ -d _data/defaults.yaml $<
	@echo "$@"

_trabalho/%.md : _src/trabalho/%.md biblio.yaml defaults.yaml
	@-mkdir -p $(@D)
	@pandoc -o $@ -d _data/defaults.yaml $<
	@echo "$@"

slides/%/index.html : _src/aula/%.md _data/revealjs.yaml \
	biblio.yaml assets/css/revealjs-main.scss $(SASS)
	@-mkdir -p $(@D)
	@$(PANDOC) -o $@ -d _data/revealjs.yaml $<
	@echo $(@D)

.PRECIOUS : assets/css/revealjs-main.scss
assets/css/%.scss : _sass/%.scss
	@-mkdir -p assets/css
	@cp $< $@
	@echo "$@"

.PHONY : serve
serve : docs
	@echo "####################"
	@bundle exec jekyll serve --future
# vim: set foldmethod=marker shiftwidth=2 tabstop=2 :
