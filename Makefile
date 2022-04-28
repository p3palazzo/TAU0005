# {{{1 Variables
#      =========
VPATH = . assets
vpath %.bib _bibliography
vpath %.html . _includes _layouts _site
vpath %.scss _sass slides/reveal.js/css/theme/template
vpath %.yaml . _spec _data

PANDOC_VERSION  := 2.18
JEKYLL_VERSION  := 4.2.0
PANDOC/CROSSREF := docker run --rm -v "`pwd`:/data" \
	-u "`id -u`:`id -g`" pandoc/core:$(PANDOC_VERSION)
JEKYLL := palazzo/jekyll-tufte:$(JEKYLL_VERSION)-$(PANDOC_VERSION)

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
	@docker run --rm -v "`pwd`:/srv/jekyll" \
		$(JEKYLL) /bin/bash -c "chmod 777 /srv/jekyll && jekyll build --future"

slides/%/index.html : _aula/%.md revealjs.yaml \
	revealjs-crossref.yaml biblio.yaml $(SASS) \
	assets/css/revealjs-main.scss
	@-mkdir -p $(@D)
	@$(PANDOC/CROSSREF) -o $@ -d _spec/revealjs.yaml $<
	@echo $(@D)

.PRECIOUS : assets/css/revealjs-main.scss
assets/css/%.scss : _sass/%.scss
	@-mkdir -p assets/css
	@cp $< $@
	@echo "$@ atualizado."

.PHONY : serve
serve : $(SLIDES)
	@echo "####################"
	@docker run --rm -v "`pwd`:/srv/jekyll" \
		-h "0.0.0.0:127.0.0.1" -p "4000:4000" \
		$(JEKYLL) jekyll serve --future

.PHONY : clean
clean :
	-@rm -rf *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.run.xml \
		tau0005-*.tex
# vim: set foldmethod=marker shiftwidth=2 tabstop=2 :
