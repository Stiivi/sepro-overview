TARGET_NAME = Sepro
PANDOC = pandoc
IFORMAT = markdown
MATHJAX = "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
FLAGS = --standalone --toc --toc-depth=2 --mathjax=$(MATHJAX) --highlight-style pygments
STYLE = css/style.css
TEMPLATE_HTML = template.html
# TEMPLATE_TEX = template.latex
PNG_IMAGES = $(patsubst %.pdf,%.png,$(wildcard img/*.pdf))

#SRC = $(wildcard *.md)
SRC = chapters/00_title.md \
	  chapters/01_introduction.md \
	  chapters/02_system_overview.md \
	  chapters/03_model.md \
	  chapters/04_actuator.md \
	  chapters/05_computation.md \
	  chapters/06_probes.md \
	  chapters/07_example.md \
	  chapters/08_development_notes.md \
	  chapters/09_future.md \
	  chapters/101_grammar.md

OBJ = $(SRC:.md=.html)

all: $(OBJ) top

index: index.html

img/%.png: img/%.pdf
	convert -density 150 $< $@

%.html: %.md $(FILTER)
	$(PANDOC) -c $(STYLE) --template $(TEMPLATE_HTML) -s -f $(IFORMAT) -t html $(FLAGS) -o $@ $<

%.pdf: %.md $(FILTER)
	$(PANDOC) --filter ${FILTER} -f $(IFORMAT) --latex-engine=xelatex $(FLAGS) -o $@ $<

%.epub: %.md $(FILTER)
	$(PANDOC) -f $(IFORMAT) $(FLAGS) -o $@ $<

pdf: $(FILTER)
	$(PANDOC) -f $(IFORMAT) --latex-engine=xelatex $(FLAGS) -o $(TARGET_NAME).pdf $(SRC)

epub: $(FILTER)
	$(PANDOC) -f $(IFORMAT) $(FLAGS) -o $(TARGET_NAME).epub *.md

top: $(FILTER)
	$(PANDOC) -c $(STYLE) --filter ${FILTER} --template $(TEMPLATE_HTML) -s -f $(IFORMAT) -t html $(FLAGS) -o tutorial.html index.md

clean:
	-rm *.html *.pdf
