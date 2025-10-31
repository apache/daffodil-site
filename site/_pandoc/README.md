---
layout: page
title: Pandoc + Jekyll Integration
pdf: false
---
# Pandoc + Jekyll Integration

## _ Currently Broken: pandoc just hangs, never creates PDF file output.

This directory contains tools for generating **PDF versions** of selected Jekyll pages while keeping the same Markdown files usable by Jekyll for the website.

The goal is to have **one Markdown source** that:
- renders cleanly in the Jekyll site (for HTML),
- and can also be converted into a polished PDF using **Pandoc + LaTeX**.

---

## Directory Layout

```
_pandoc/
│
├── README.md              ← this file
├── Makefile               ← builds all PDFs
├── template_basic.latex   ← custom LaTeX template used by pandoc
├── only.lua               ← pandoc preprocessor for jekyll-only and pandoc-only 
└── ../pdf/                ← generated PDFs appear here
```

At the root of the Jekyll site:

```
_data/footer.yml           ← footer used by pandoc for PDF pages
assets/...                 ← added logos used by PDF footer/header
pdf/                       ← PDFs are created here
```

---

##  How It Works

### 1. Mark pages that should have PDFs

Any Markdown file (".md" extension) can be tagged with:

```yaml
---
title: Example Page
layout: page
pdf: true
---
```
The markdown dialect used must then be in the subset common to both jekyll and pandoc.  

The Makefile will scan the markdown files and automatically detect files intended to become PDFs.

---

### 3. The Makefile

The `_pandoc/Makefile` automates the whole process.

It:

1. Scans the site for Markdown files with `pdf: true`.
2. Invokes Pandoc with the configured LaTeX template to produce a PDF.

The resulting PDFs go into:

```
site/pdf
```

---

## Example Commands

From inside the `_pandoc/` directory:

### Build all PDFs
```bash
make
```

### Clean all generated PDFs
```bash
make clean
```

### List all Markdown files with `pdf: true`
```bash
make list
```

### Force rebuild of one PDF
```bash
make ../pdf/about.pdf
```

---

## Recommended Workflow

1. Write Markdown pages normally for your Jekyll site.
2. When you also want a PDF version, add `pdf: true` to front matter.
3. From `_pandoc/`, run:
   ```bash
   make
   ```
4. Find the generated PDFs in `pdf/`.

---

**Maintainer Notes**

- `_pandoc/Makefile` assumes it’s run from `_pandoc/`, with site root as `..`
- Pandoc and AWK must be available on your `PATH`
- Tested with pandoc v3.1.3 

Note that this manual build process is temporary and at some point will be done automatically by 
the site rebuild process, that is, at the same time the jekyll processing is done.

---

## Pandoc Tools Installation

These tools run on Linux.

On Ubuntu you have to install these things:

    sudo apt install pandoc texlive-latex-base texlive-latex-recommended \
      texlive-fonts-recommended texlive-xetex texlive-latex-extra

For other distros of Linux different commands will be needed, but the same list of packages must 
be installed.
