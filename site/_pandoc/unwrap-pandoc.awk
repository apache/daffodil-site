#!/usr/bin/awk -f
# Unwraps blocks of the form:
#   <!-- PANDOC:START -->
#   <!--
#      ... lines ...
#   -->
#   <!-- PANDOC:END -->
#
# Everything between PANDOC:START and PANDOC:END (excluding the comment wrappers)
# is printed as-is.

BEGIN { inblock = 0; inside_comment = 0 }

# Detect start of PANDOC block
/^[[:space:]]*<!--[[:space:]]*PANDOC:START[[:space:]]*-->/ {
    inblock = 1
    next
}

# Detect end of PANDOC block
/^[[:space:]]*<!--[[:space:]]*PANDOC:END[[:space:]]*-->/ {
    inblock = 0
    next
}

{
    if (inblock) {
        # Skip the opening <!-- and closing --> inside the PANDOC section
        if ($0 ~ /^[[:space:]]*<!--[[:space:]]*$/) next
        if ($0 ~ /^[[:space:]]*-->[[:space:]]*$/) next
        print
    } else {
        # Outside block: print unchanged
        print
    }
}
