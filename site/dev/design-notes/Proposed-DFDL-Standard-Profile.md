# Proposal: DFDL Standard Profile

#### Version  0.3  2023-12-08

## Introduction

In attempting to integrate Apache Daffodil with other data processing software, the need to make
DFDL schemas interoperate properly in conjunction with other data models has arisen.

Other tools such as Apache NiFi, Apache Drill, Apache Spark, etc. have data models which are
powerful, but not as expressive as DFDL.

DFDL's data model is a simplification of 
[XML Schemas's Post Schema Validation Infoset (PSVI)](https://www.w3.org/XML/2002/05/psvi-use-cases);
however, even this causes problems.
Most other data processing systems were not designed with markup languages in mind, but rather for
structured data.

The following things are allowed in DFDL v1.0, but are difficult to map into most data models:

- anonymous choices
- duplicate element child names
- namespaces that are different, but where the prefixes are not unique
- global names for element children

A more restrictive subset of DFDL, a _standard profile_, is needed which can be enforced (on
request) to ensure that DFDL schemas will be usable with a variety of data processing systems.
Creating DFDL schemas that adhere to this standard profile ensures maximal interoperability,
including the ability to convert into JSON without name/namespace collisions.

This is a proposal for a switch/option to be added to Daffodil which turns on enforcement of this
standard profile (which is a subset of DFDL).

## Standard Profile Restrictions

### No Anonymous Choices

Choices must be the model groups of complex type definitions and are not allowed in any other
context.

Each choice branch must begin with a different element. (This is already a XML Schema requirement -
Unique Particle Attribution.)

### Group References Cannot Carry DFDL Properties

Group references are allowed, but DFDL format properties cannot be expressed on group references; hence,
combining those properties with those of the group definition is not required.

Note that dfdl:assert, dfdl:discriminator and other DFDL *statements*, not format properties.
These may be expressed in group definitions, but not on group references. 

While most data structure systems do not have this notion of reusable groups, when restricted as 
described, reusable groups are something users could implement by way of a simple macro 
pre-processor, so having this in the standard profile really does not create any particular 
challenge when mapping from DFDL standard profile schemas into any data structure system. 

Groups and group references are used heavily in DFDL schemas to push down complexity like 
discriminators that are reused in many places.
Allowing groups and group references reduces the difficulty of converting many large DFDL 
schemas to conform to the standard profile, and makes this possible without introducing many 
otherwise unneeded element and type definitions. 

### No Element References

There is no corresponding form of sharing in most data structure systems.

### No Namespace-Qualified Names

Only elementFormDefault 'unqualified' is allowed.
Note that this is the default for XML Schema and DFDL.

### Unique Namespace Prefixes

All namespace prefixes must be unique in the entire schema.

This enables one to create unique identifiers by concatenating prefix_local to create global names.

### All Element Children Have Unique Names

All children element declarations must have unique names within their enclosing parent element.

#### Discussion

Note that this causes issues in a number of large DFDL schemas which attempt to implement a 
single DFDL schema that is capable of handling multiple versions of the data format.

In this case, the schema uses a construct like:
```xml
<choice dfdl:choiceDispatchKey="{ ... }">
  <sequence dfdl:choiceBranchKey="C">
    <element name="VersionC" type="zString"/><!-- zero-length string -->
    <element name="hdr" type="hdr_version_C_type"/>
  </sequence>
  <sequence dfdl:choiceBranchKey="D">
    <element name="VersionD" type="zString"/>
    <element name="hdr" type="hdr_version_D_type"/>
  </sequence>
</choice>
```
In the above, you can see that there are two separate element declarations named hdr, of different types. 
This allows common sub-structure that is the same in versions C and D to be addressed by path expressions that are
polymorphic. They do not have a path step component that identifies the version. 

However, if we require all children to have unique names, then this would have to be elements with distinct names on each
branch such as hdrC and hdrD, and then paths, even those reaching sub-fields that are common to both versions, 
have path steps that are specifically requesting a particular version. 

This is a bit painful particularly if there are few differences between versions, and many expressions that
need to reference into the common fields, because
all such expressions would need to be duplicated for version C and version D. 

An alternative solution is that this could be overcome by a way of creating path expressions with wildcards in 
them eg., ".../hdr*/...".
An extension of this kind in DFDL has already been proposed/discussed some time ago by the DFDL workgroup, but has 
not yet turned into a formal proposal. (The DFDL4Space implementation by the ESA has a kind of wildcard feature like
this as a DFDL extension.)

Another way of addressing this is to refactor the schema to put common fields outside the choice, and 
have a version-driven choice only for points where the different versions diverge.
This has a downside in that one point in the schema which is version sensitive becomes perhaps many such points, so 
the places where version-distinctions are required are less predictable to a schema user. 

This also requires a more sophisticated DFDL schema generator that takes into account multiple versions, computing their 
deltas, and generating common schema when it can. 
This is, however, not the way some large schemas were created, as these schemas are machine generated from the 
individual format specifications, without performing an analysis of what is common and what is unique.

### Nillable Simple Types Only (TBD: May not be necessary)

Nillable is allowed only for simple type elements. 

Note that in DFDL, element declarations express nillability, not type definitions. 

#### Rationale

DFDL does not allow the same representation for nilled complex elements as it does for nilled simple elements. 
The representation DFDL allows for nillable complex types is only empty string whereas for simple types a variety of 
dfdl:nilValue values can be expressed. 

Hence, omitting this feature removes an awkward corner case.

### Element Name/Identifier Restrictions

Element names must consist of all non-whitespace characters from the
Unicode basic multilingual plane (no surrogate pairs in element names).

They may not contain any control characters (Unicode class Cc) and may not contain various punctuation
characters (Unicode classes Ps, Pe, Pd, Pc, Pf, Pi, Po, nor $).

This is a lowest-common denominator of identifier rules intended to allow
DFDL schema identifiers to be mapped into ANY programming language or
structure declaration language, while at the same time allowing use of
Unicode characters.

Element names may not begin with a digit.

Users are encouraged to use "A-Za-Z0-9" only as some systems may not allow use of Unicode characters in
identifiers.

Element names may not begin with any prefix defined as part of the schema
followed by an "_" as this could be ambiguous with names being made globally
unique by appending prefix, "_" and local name.

### String Content Restrictions

Schemas may only be written in UTF-8 encoding.

#### Rationale

Simplify implementations.

### Import `schemaLocation`

Imported files - a namespace must be imported from a single unique imported file. 
A single schema may not contain different import statements for the same
namespace which specify different files.

This is a practical requirement in XML Schema and in Apache Daffodil today, but should be made explicit.

If the `schemaLocation` begins with a "/" it is interpreted as an absolute path, otherwise a
relative path. Both may be interpreted relative to a classpath.

## Existing DFDL Restrictions

Just as a reminder, the above standard-profile restrictions go on top of DFDL
existing limitations on XML Schema such as:

- arrays/optional - only for elements
- no mixed content
- no complex type derivation
- no attributes
- limited set of simple types
- pattern facets only for xs:string elements
- other facet restrictions by type

## Possible additional restrictions

### Troublesome Placement of dfdl:assert and dfdl:discriminator on Sequences & Choices

The DFDL v1.0 rules about sequences/choices and statement annotations on them are confusing.
In particular, a dfdl:assert or dfdl:discriminator with testKind 'expression' appears lexically at
the top of the sequence/choice, but is executed after the sequence/choice content has been parsed.

This is sufficiently error-prone that the standard profile should disallow
it, requiring instead that an inner sequence carrying the assertion or
discriminator with NO child content, be inserted in the sequence at the
point where the evaluation is required to occur.

# Requesting/Enabling the Standard Profile

If the standard profile is requested, then use of constructs outside of the standard profile is a
Schema Definition Error.

## Use Cases

A DFDL schema author may want to, by default, state that they want to conform to the standard profile
for new DFDL schemas they create.
The purpose of this is to maximize the utility of these new schemas when used with a variety of data systems.

However, a DFDL schema author may also have a mixture of DFDL schema projects they use or maintain, and some of them
may pre-date or intentionally not use the standard profile; hence, individual schema projects must be able to 
carry a declared intention of whether they do, or do not, expect to adhere to the standard profile. 

Finally, an individual schema project may contain a variety of subsections, some of which use the standard profile, and 
some of which do not; hence, individual DFDL schema files must be able to declare their use of the standard profile, or
intention to not use it. 

### Mechanisms for Requesting the Standard Profile

The following ways should be available for a schema author to tell Daffodil they want enforcement of
the standard profile (or not).

- *Home Directory Properties File* - a file such as ~/.daffodil or daffodil.properties should
  contain a default value for choosing the standard profile. This default value can be overridden by
  other mechanisms which have higher priority.
- *Schema Project Properties File* - a Daffodil config file at the root of the Daffodil schema
  project directory tree, should be able to specify a default value for use by the schema project.
  
  If the XML config file system is superceded by some other properties file per-schema, then that
  same file should enable specifying the standard profile is (or is not) to be used.
- *Per Schema-File property* - A property expessed at the top level of a DFDL schema file should
  indicate that the standard profile is requested.

  All schemas imported or included by a schema that requests the standard profile would be assumed
  to also be required to obey the standard profile.

  However, the inverse is not true. Including/importing a schema file that requests the standard profile does not
  change the profile behavior (using or not) of the schema doing the include/import.
- *Command Line Interface (CLI) Option* - The daffodil CLI should take an option (perhaps 
  --standard-profile yes/no) telling it the 
  schema is expected to obey the standard profile. The CLI should also obey the other mechanisms 
  listed here. The CLI flag should override properties files (homedir, or schema project 
  expressed), but not things specified directly in the schema files themselves. 

An opposite expression - that a schema explicitly is known to require more than the
standard profile, should also be allowed to be placed in any of these locations.

Including such an explicitly non-standard-profile schema into a schema that requests the standard
profile should cause a Schema Definition Error. 
The inverse however, is not true. 
A schema that explicitly obeys the standard profile can be included/imported into any schema. 

