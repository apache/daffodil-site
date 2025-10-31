# ==========================================================
# Pandoc PDF generator for Jekyll site
# Scans Markdown files with "pdf: true" in YAML front matter
# and produces PDFs in the site's ./pdf/ directory
# ==========================================================
SHELL := /bin/bash

# --- Configuration ---
SITE_ROOT := ..

PANDOC := pandoc

# Output directory for generated PDFs (at site root)
PDF_OUTDIR := $(SITE_ROOT)/pdf

DEFAULTS := $(SITE_ROOT)/_pandoc/basic.yaml

# This is coarse, but we take any markdown file containing a line of "pdf: true" regardless of location in the file.
# but we exclude directories that begin with "_".
MD_CANDIDATES=$(shell grep -Rlx 'pdf: true' $(SITE_ROOT) --exclude-dir '_*')

# --- Files to build ---
PDF_SRCS := $(MD_CANDIDATES)
PDFS     := $(patsubst $(SITE_ROOT)/%.md,$(PDF_OUTDIR)/%.pdf,$(PDF_SRCS))

# --- Default target ---
all: $(PDFS)
	@echo "Generated $(words $(PDFS)) PDF(s) in $(PDF_OUTDIR)"

# --- Rule to ensure output dirs exist and build each PDF ---
$(PDF_OUTDIR)/%.pdf: $(SITE_ROOT)/%.md | make-dirs
	@mkdir -p $(dir $@)
	@echo "📄 Building $@"
	$(PANDOC) --defaults=$(DEFAULTS) \
	  -L only.lua \
	  -f markdown+markdown_in_html_blocks \
	  --metadata-file=$(SITE_ROOT)/_data/footer.yml \
	  -V numberoffset=0 \
	  --from markdown --to pdf -o $@

# --- Create directories as needed ---
.PHONY: make-dirs
make-dirs:
	@mkdir -p $(PDF_OUTDIR)

# --- Cleanup ---
.PHONY: clean
clean:
	@echo "Removing generated PDFs"
	@rm -rf $(PDF_OUTDIR)

# --- Debugging helpers ---
.PHONY: list
list:
	@echo "Markdown files with pdf:true:"
	@for f in $(PDF_SRCS); do echo " - $$f"; done
