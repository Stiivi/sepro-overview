#
# Chapters in order
# 
# SRC = $(wildcard *.md)
#
SRC = 00_title.md \
	  01_introduction.md \
	  03_model.md \
	  04_actuator.md \
	  05_simulation.md \
	  06_probes.md \
	  02_system_overview.md \
	  07_example.md \
	  08_development_notes.md \
	  09_future.md \
	  101_grammar.md \
	  102_rejected_or_postponed_ideas.md


TARGET_NAME = Sepro
PANDOC = pandoc
IFORMAT = markdown
MATHJAX = "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
FLAGS = --standalone \
		--highlight-style pygments
STYLE = css/style.css
TEMPLATE_HTML = template.html
# TEMPLATE_TEX = template.latex
STYLE_DIR = style
HTML_FLAGS = --toc \
			 --toc-depth=2 \
			 --default-image-extension=png \
			 --template="$(STYLE_DIR)/template.html" \
			 --mathjax=$(MATHJAX) \
			 -c "css/style.css"
PDF_FLAGS = --default-image-extension=pdf \
			--latex-engine=xelatex \
			-H "$(STYLE_DIR)/preamble.tex" \
			--template="$(STYLE_DIR)/template.latex" \
			-V listings \
			-V fontsize=11pt \
			-V papersize=a4paper \
			-V documentclass:report \
			$(FLAGS)

OUTPUT_DIR = docs

# Do not edit below this line
# -----------------------------------------------------------------------

# Text sources
# 
SRC_DIR = chapters
HTML_IMAGES_DIR = $(OUTPUT_DIR)/images

ALL_SRC = $(addprefix $(SRC_DIR)/,$(SRC))

# Images
#

IMAGES = $(wildcard images/*.pdf)
HTML_IMAGES = $(addprefix $(OUTPUT_DIR)/,$(patsubst %.pdf,%.png,$(IMAGES)))

OBJ = $(addprefix $(OUTPUT_DIR)/,$(SRC:.md=.html))

all: dirs $(OBJ) # top

dirs: 
	mkdir -p $(OUTPUT_DIR)
	mkdir -p $(OUTPUT_DIR)/css
	mkdir -p $(OUTPUT_DIR)/images

index: index.html

$(OUTPUT_DIR)/images/%.png: images/%.pdf 
	convert -density 150 $< $@

html_resources: $(HTML_IMAGES) 
	cp style/*.css $(OUTPUT_DIR)/css

$(OUTPUT_DIR)/%.html: $(SRC_DIR)/%.md $(FILTER) html_resources
	$(PANDOC) -s -f $(IFORMAT) -t html $(FLAGS) $(HTML_FLAGS) -o $@ $<

%.pdf: %.md $(FILTER)
	$(PANDOC) --filter ${FILTER} -f $(IFORMAT) $(PDF_FLAGS) -o $(OUTPUT_DIR)/$@ $<

%.epub: %.md $(FILTER)
	$(PANDOC) -f $(IFORMAT) $(FLAGS) -o $@ $<

pdf: $(FILTER) dirs
	$(PANDOC) -f $(IFORMAT) $(PDF_FLAGS) -o $(OUTPUT_DIR)/$(TARGET_NAME).pdf $(ALL_SRC)

epub: $(FILTER) dirs
	$(PANDOC) -f $(IFORMAT) -t epub3 $(FLAGS) -o $(OUTPUT_DIR)/$(TARGET_NAME).epub $(ALL_SRC)

top: $(FILTER)
	$(PANDOC) -c $(STYLE) --filter ${FILTER} --template $(TEMPLATE_HTML) -s -f $(IFORMAT) -t html $(FLAGS) -o tutorial.html index.md

clean:
	-rm $(OUTPUT_DIR)/*
