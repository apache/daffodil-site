# ==========================================================
# Pandoc PDF generator for Jekyll site
# Scans Markdown files with "pdf: true" in YAML front matter
# and produces PDFs in the site's ./pdf/ directory
# ==========================================================

# --- Configuration ---
SITE_ROOT := ..
AWK_UNWRAP := $(SITE_ROOT)/_pandoc/unwrap-pandoc.awk
AWK_LIST   := $(SITE_ROOT)/_pandoc/list-pdf-sources.awk
PANDOC := pandoc

# Output directory for generated PDFs (at site root)
PDF_OUTDIR := $(SITE_ROOT)/pdf

DEFAULTS := $(SITE_ROOT)/_pandoc/basic.yaml

# --- Candidate Markdown files (exclude build/tool/output dirs) ---
# Use find + awk pipeline — awk -f avoids executable bit.
MD_CANDIDATES := $(shell find $(SITE_ROOT) \
  -type f -name '*.md' \
  -not -path '*/_*/*' \
  -not -path '*/node_modules/*' \
  -not -path '*/vendor/*' \
  -not -path '*/pdf/*' \
  -print0 | xargs -0 -r awk -f $(AWK_LIST))

# --- Files to build ---
PDF_SRCS := $(MD_CANDIDATES)
PDFS     := $(patsubst $(SITE_ROOT)/%.md,$(PDF_OUTDIR)/%.pdf,$(PDF_SRCS))

# --- Default target ---
all: $(PDFS)
	@echo "✅ Generated $(words $(PDFS)) PDF(s) in $(PDF_OUTDIR)"

# --- Rule to ensure output dirs exist and build each PDF ---
$(PDF_OUTDIR)/%.pdf: $(SITE_ROOT)/%.md | make-dirs
	@mkdir -p $(dir $@)
	@echo "📄 Building $@"
	@awk -f $(AWK_UNWRAP) $< | \
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
	@echo "🧹 Removing generated PDFs"
	@rm -rf $(PDF_OUTDIR)

# --- Debugging helpers ---
.PHONY: list
list:
	@echo "Markdown files with pdf:true (front matter only):"
	@for f in $(PDF_SRCS); do echo " - $$f"; done
