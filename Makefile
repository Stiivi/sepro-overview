#
# Chapters in order
# 
# SRC = $(wildcard *.md)
#
SRC = 00_title.md \
	  01_introduction.md \
	  02_system_overview.md \
	  03_model.md \
	  04_actuator.md \
	  05_computation.md \
	  06_probes.md \
	  07_example.md \
	  08_development_notes.md \
	  09_future.md \
	  101_grammar.md


TARGET_NAME = Sepro
PANDOC = pandoc
IFORMAT = markdown
MATHJAX = "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
FLAGS = --standalone \
		--mathjax=$(MATHJAX) \
		--highlight-style pygments
STYLE = css/style.css
TEMPLATE_HTML = template.html
# TEMPLATE_TEX = template.latex
PNG_IMAGES = $(patsubst %.pdf,%.png,$(wildcard img/*.pdf))
STYLE_DIR = style
HTML_FLAGS = --toc \
			 --toc-depth=2
PDF_FLAGS = --default-image-extension=pdf \
			--latex-engine=xelatex \
			-H "$(STYLE_DIR)/preamble.tex" \
			--template="$(STYLE_DIR)/template.latex" \
			-V listings \
			-V fontsize=11pt \
			-V papersize=a4paper \
			-V documentclass:report \
			$(FLAGS)

BUILD_DIR = build

# Do not edit below this line
# -----------------------------------------------------------------------

# Text sources
# 
SRC_DIR = chapters

ALL_SRC = $(addprefix $(SRC_DIR)/,$(SRC))

# Images
#

PNG_IMAGES = $(patsubst %.pdf,%.png,$(wildcard img/*.pdf))

OBJ = $(SRC:.md=.html)

all: $(OBJ) top

build:
	mkdir -p $(BUILD_DIR)

index: index.html

img/%.png: img/%.pdf
	convert -density 150 $< $@

%.html: %.md $(FILTER)
	$(PANDOC) -c $(STYLE) --template $(TEMPLATE_HTML) -s -f $(IFORMAT) -t html $(FLAGS) -o $(BUILD_DIR)/$@ $<

%.pdf: %.md $(FILTER)
	$(PANDOC) --filter ${FILTER} -f $(IFORMAT) $(PDF_FLAGS) -o $(BUILD_DIR)/$@ $<

%.epub: %.md $(FILTER)
	$(PANDOC) -f $(IFORMAT) $(FLAGS) -o $@ $<

pdf: $(FILTER) build
	$(PANDOC) -f $(IFORMAT) $(PDF_FLAGS) -o $(BUILD_DIR)/$(TARGET_NAME).pdf $(ALL_SRC)

epub: $(FILTER) build
	$(PANDOC) -f $(IFORMAT) $(FLAGS) -o $(BUILD_DIR)/$(TARGET_NAME).epub $(ALL_SRC)

top: $(FILTER)
	$(PANDOC) -c $(STYLE) --filter ${FILTER} --template $(TEMPLATE_HTML) -s -f $(IFORMAT) -t html $(FLAGS) -o tutorial.html index.md

clean:
	-rm $(BUILD_DIR)/*
