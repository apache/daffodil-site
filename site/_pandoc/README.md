---
layout: page
title: Pandoc + Jekyll Integration
pdf: false
---
# 🧭 Pandoc + Jekyll Integration

This directory contains tools for generating **PDF versions** of selected Jekyll pages while keeping the same Markdown files usable by Jekyll for the website.

The goal is to have **one Markdown source** that:
- renders cleanly in the Jekyll site (for HTML),
- and can also be converted into a polished PDF using **Pandoc + LaTeX**.

---

## 🏗️ Directory Layout

```
_pandoc/
│
├── README.md              ← this file
├── Makefile               ← builds all PDFs
├── unwrap-pandoc.awk      ← preprocessor that removes comment wrappers
├── template.latex         ← (optional) custom LaTeX template
├── header.tex             ← (optional) extra LaTeX header content
└── ../pdf/                ← generated PDFs appear here
```

At the root of the Jekyll site:

```
_config.yml
_posts/
pages/
assets/
_pandoc/
pdf/
```

---

## 🧩 How It Works

### 1. Mark pages that should have PDFs

Any Markdown file (in `_posts`, `pages/`, or elsewhere) can be tagged with:

```yaml
---
title: Example Page
layout: page
pdf: true
---
```

The Makefile will scan the entire Jekyll project and automatically detect these files.

---

### 2. Use HTML comment wrappers for Pandoc-only content

Pandoc sometimes needs LaTeX code for things like custom tables, math, or page layout.  
We hide that LaTeX from Jekyll using **HTML comments**, which Jekyll ignores but our AWK preprocessor removes before running Pandoc.

Example:

````markdown
Regular Markdown content here.

<!-- PANDOC:START -->
<!--
```{=latex}
\begin{tabular}{ll}
A & B \\
C & D \\
\end{tabular}
```
-->
<!-- PANDOC:END -->

More Markdown content.
````

When viewed on the Jekyll site:
- This section is hidden (HTML comments are ignored).

When built via Pandoc:
- The `unwrap-pandoc.awk` script strips the comment wrappers,
- The inner LaTeX becomes active, producing a correct PDF table.

---

### 3. The Makefile

The `_pandoc/Makefile` automates the whole process.

It:

1. Recursively scans the site for Markdown files with `pdf: true`.
2. Runs `unwrap-pandoc.awk` to clean up `<!-- PANDOC:START -->` / `<!-- PANDOC:END -->` wrappers.
3. Invokes Pandoc with the configured LaTeX template to produce a PDF.

The resulting PDFs go into:

```
_pandoc/output/
```

keeping them separate from the Jekyll site itself.

---

## 🧮 Example Commands

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
make ../about.pdf
```

---

## 🧰 How the AWK Script Works

`unwrap-pandoc.awk` removes the HTML comment wrappers used to hide LaTeX from Jekyll.

Input example:

````markdown
<!-- PANDOC:START -->
<!--
\LaTeX code
-->
<!-- PANDOC:END -->
````

Output to Pandoc:

```markdown
\LaTeX code
```

That means Pandoc receives clean, valid LaTeX syntax while Jekyll never sees it.

---

## ⚙️ Customizing Pandoc

Pandoc is run with `--defaults=basic.yaml` which specifies the `template_basic.tex` is used.
The template can be modified to change the PDF output. 

---

## 🧱 Recommended Workflow

1. Write Markdown pages normally for your Jekyll site.
2. When you also want a PDF version, add `pdf: true` to front matter.
3. If needed, wrap LaTeX-specific content in `<!-- PANDOC:START -->` / `<!-- PANDOC:END -->` blocks.
4. From `_pandoc/`, run:
   ```bash
   make
   ```
5. Find the generated PDFs in `pdf/`.

---

## 🪄 Why This Setup Works

| Concern | Solution |
|----------|-----------|
| Jekyll shouldn’t see LaTeX | Hidden in HTML comments |
| Pandoc must see LaTeX | AWK removes wrappers |
| Need automatic PDF generation | Makefile scans for `pdf: true` |
| Keep tools separate | Everything lives in `_pandoc/` |

---

## 🧾 Example Output

```
pdf/
├── about.pdf
└── _posts/
    └── 2025-01-01-example.pdf
```

---

**Maintainer Notes**

- `_pandoc/Makefile` assumes it’s run from `_pandoc/`, with site root as `..`
- Pandoc and AWK must be available on your `PATH`

---

## Pandoc Tools Installation

These tools run on Linux.

On Ubuntu you have to install these things:

    sudo apt install pandoc texlive-latex-base texlive-latex-recommended \
      texlive-fonts-recommended texlive-xetex texlive-latex-extra

I have found one must update pandoc to a more up to date version.
This is currently dependent on pandoc 3.7.0.2 which can be downloaded from
https://github.com/jgm/pandoc/releases/tag/3.7.0.2 . 
