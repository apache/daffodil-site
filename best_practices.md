# Enumerations

It is _*highly*_ recommended that DFDL schema authors avoid whitespace within the definition of
symbolic enumeration constants. Underscores should be use instead of spaces.

## Enumerations and Validity

The above example also illustrates an optional technique which segregates the enumeration values
into some that are schema-valid, and some that are not, based on an additional pattern facet which
constrains the valid symbolic values to names that begin with "OK_"[^checkConstraints].

[^checkConstraints] This particular MIL-STD-2045 schema
(as of this writing 2025-10-27) enforces the pattern facet at parse time, so it
is a parse error if the selected symbolic enumeration does not start with `"OK_"` meaning
only numeric values 2, 4, 5, 6, and 7 are considered well-formed. However,
this enforcement is not required and is not actually considered best practice.

[TBD]:
Bug? In MIL-STD-2045, this string type has a dfdl:checkConstraints(.) assert on it. So these 
facets are
enforced and cause a parse error if data does not adhere to them. 
This is probably a mistake in
the schema, which should at least have a DFDL variable to control whether or not this
dfdl:assert will fail or not. 
Best practice is to NOT use dfdl:checkConstraints(.), so as to
cleanly separate the concepts of well-formed and valid data. 
