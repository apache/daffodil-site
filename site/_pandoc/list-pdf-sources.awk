#!/usr/bin/awk -f
# Prints FILENAME iff the file has YAML front matter with "pdf: true".
# - Must be called with filenames (works via find/xargs).
# - Ignores matches outside the front matter.
# - Front matter is the lines between the first '---' and the next '---'.

# We process each file independently.
# Use a per-file BEGINFILE block if available (GNU awk). Otherwise reset on first record.
BEGIN {
  have_beginfile = 0
}
BEGINFILE {
  have_beginfile = 1
  in_front = 0
  seen_start = 0
  want_pdf = 0
}

# For non-GNU awk compatibility:
# Reset on the first line of each file if BEGINFILE isn't supported.
FNR == 1 && !have_beginfile {
  in_front = 0
  seen_start = 0
  want_pdf = 0
}

{
  # Detect start of front matter
  if (!seen_start) {
    if ($0 ~ /^[[:space:]]*---[[:space:]]*$/) {
      seen_start = 1
      in_front = 1
      next
    } else {
      # No front matter: skip file
      nextfile
    }
  }

  # If in front matter, look for end and for pdf:true
  if (in_front) {
    if ($0 ~ /^[[:space:]]*---[[:space:]]*$/) {
      # End of front matter
      in_front = 0
      if (want_pdf) {
        print FILENAME
      }
      nextfile
    }
    # Match "pdf: true" allowing spaces; ensure it's a key at line start
    if ($0 ~ /^[[:space:]]*pdf:[[:space:]]*true([[:space:]]|$)/) {
      want_pdf = 1
    }
    next
  }

  # If we got here, we’ve passed front matter without finding pdf:true
  nextfile
}
