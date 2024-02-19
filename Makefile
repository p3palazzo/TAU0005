# {{{1 Variables
#      =========
VPATH = . assets
vpath %.bib _bibliography
vpath %.html . _includes _layouts _site
vpath %.scss _sass slides/reveal.js/css/theme/template
vpath %.yaml . _spec _data

PANDOC_V  := 3.1.2
JEKYLL_V  := 4.3.3
PANDOC := pandoc
JEKYLL := bundle exec jekyll

ASSETS  = $(wildcard assets/*)
AULA    = $(wildcard _aula/*.md)
SLIDES  = $(patsubst _aula/%.md,slides/%/index.html,$(AULA))
SASS    = _revealjs-settings.scss \
					mixins.scss settings.scss theme.scss

# {{{1 Recipes
#      =======
.PHONY : _site
_site : $(SLIDES)
	@echo "####################"
	@$(JEKYLL) build --future"

slides/%/index.html : _aula/%.md _data/revealjs.yaml \
	biblio.yaml assets/css/revealjs-main.scss $(SASS)
	@-mkdir -p $(@D)
	@$(PANDOC) -o $@ -d _data/revealjs.yaml $<
	@echo $(@D)

.PRECIOUS : assets/css/revealjs-main.scss
assets/css/%.scss : _sass/%.scss
	@-mkdir -p assets/css
	@cp $< $@
	@echo "$@ atualizado."

.PHONY : serve
serve : $(SLIDES)
	@echo "####################"
	@$(JEKYLL) serve --future

.PHONY : clean
clean :
	-@rm -rf *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.run.xml \
		tau0005-*.tex
# vim: set foldmethod=marker shiftwidth=2 tabstop=2 :
