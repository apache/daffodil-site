---
layout: page
title: Best Practices Guide for DFDL Schema Authors 
group: nav-right
---
<!--
{% comment %}
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to you under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
{% endcomment %}
-->

## Table of Contents 
{:.no_toc} 
<!-- The {: .no_toc } excludes the above heading from the ToC --> 

1. yes, this is the standard Jekyll way to do a ToC (this line gets removed)
{:toc}
<!-- note the above line {:toc} cannot have whitespace at the start --> 


# Introduction

This page is a collection of notes on how to create DFDL schemas to obtain some real benefits:
- Minmizes XML and XSD namespace complexity
- Provides composition properties so DFDL schemas can be reused as libraries in larger schemas
- Ensures compatibility of the schema with more restrictive infosets than XML.
  For example: JSON, Apache NiFi Records, or Apache Spark Structs.
- Ensures portability of the DFDL schema for use to validate XML infosets
  using multiple different _XML Schema Validation libraries_ such as [Xerces C](
  {{ site.data.links.reference.xercesc}}) and [libxml2]({{ site.data.links.reference.libxml2}}).

The [DFDL Training page lists several example schemas](/dfdl-training#exampleSchemas)  which follow
this style guide fully which you can use as good starting points.

There are also best-practice materials on:
- [Slides on Well-Formed vs. Valid (Avoiding `dfdl:checkConstraints(.)`)](
/best-practices/P-Avoid-Check-Constraints.pdf)
- [Slides on Handling large opaque BLOBs of binary data](
/best-practices/P-DFDL-BLOBs-v-HexBinary-array.pdf)
- [Slides on Using _Reject Elements_ to capture bad data](
/best-practices/P-DFDL-Reject-Elements.pdf)
- [Slides on Round-trip (parse + unparse) testing (with TDML)](
/best-practices/P-DFDL-Round-Trip-Testing.pdf)
- [Slides on DFDL Schemas for ad-hoc structured text formats](
/best-practices/P-DFDL-Structured-Text.pdf)


This set of notes represents best practices after learning _the hard way_ from many debugging
exercises and creating a wide variety of DFDL schemas from small teaching examples to large
production schemas for major data formats with more than 100K lines of DFDL.

For those familiar with XML Schema (XSD) design patterns, our schema style is a variation of
what is called the
[_Venetian Blind_ pattern]({{ site.data.links.reference.venetianBlind}}),
that one might call _Strict Venetian-Blind Type Library_.

- "Strict" because we strongly minimize the use of global elements, namespaces,
  and some other XSD constructs that are highly specialized to XML as the data representation.
- "Type-Library" because we structure DFDL schemas so that there is always
  the option for a user to use the schema as a library within a larger encompassing
  DFDL schema by referencing a complex type definition provided by the library schema.

Below are the details.

# Avoid Element Namespaces {#avoidElementNamespaces}

Much of the complexity of XML and XML Schema comes from their namespace features.
This can be avoided entirely by following simple conventions.

Since many data representations (such as JSON, Apache NiFi Records) have no notion of
namespaces, following this guidance keeps DFDL schemas compatible with those representations.

The conventions are:
- DFDL Schemas should use `elementFormDefault="unqualified"` (which is the default for XML Schemas).
- Daffodil tunable 
  [`unqualifiedPathStepPolicy`](/tunables/#unqualifiedpathsteppolicy)
  should be defined to be `noNamespace` (which is its default value)
- DFDL schemas should not use element references.
- Most DFDL Schema files should contain only definitions of types, groups, DFDL formats, and DFDL
  variables.
  - These schema files should share a single target namespace
    with a [well-chosen unique URI](#namespace-uri-conventions).
- A DFDL Schema should define global elements only for root elements.
  - These should be in a single separate file with _no target namespace_.
  - These should be _one liner_ declarations which just reference types imported from the other
    schema files.
  - Most DFDL schemas will need only 1 or 2 such global elements.

The real content of the schema should always be in a named complex type definition.
This gives the schema user the choice of what they want to call their elements,
and enables use of the schema as a child element within a
larger structure.

Defining only global types and groups -- leaving the global elements only for testing or the
end-user of the schema -- provides greater flexibility.
All schemas are available to use as libraries.
Hence, the standard start of a DFDL schema is doing to be:

```xml 
<!-- mySchemaType.dfdl.xsd -->
<schema
  targetNamespace="urn:example.com:schema:dfdl:mySchema:ms"
  xmlns:ms="urn:example.com:schema:dfdl:mySchema:msns"
  xmlns:dfdl="http://www.ogf.org/dfdl/dfdl-1.0/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns="http://www.w3.org/2001/XMLSchema" 
  ... >

  ... import/include statements and top level format annotations...

  <complexType name="mySchemaType">
     ... the real schema contents is all here or reachable from here. ...
  </complexType>

  ... other types and groups ...

</schema>
```

Included files, and imported files that are part of the same DFDL schema project should have
no global elements at all.

The only global element(s) defined should be _one liners_ defined in a single _root_
schema file like this:

```xml
<!-- mySchemaRoot.dfdl.xsd --> 
<schema
  xmlns:ms="urn:example.com:schema:dfdl:mySchema:ms"
  ... >
  <!-- Root elements only - no target namespace -->

  <import namespace="urn:example.com:schema:dfdl:mySchema:ms" 
          schemaLocation=".../mySchemaType.dfdl.xsd"/>

  ... a top level dfdl:format declaration ...

 <!-- 
   The root element - a type-reference only to an individual item 
   of the data format
 --> 
  
  <element name="myRoot" type="ms:mySchemaType"/> 
  
  <!--
    If needed (for testing) optional second root element for files containing 
    repetitions of the mySchemaType data format. Also a type reference only.
   -->
  <element name="myRootFile" type="ms:mySchemaFileType"/>

</schema>
```

Rationale:

- This makes schemas more flexible for reuse because it takes no position on element
  names that the schema user can't avoid if they so choose.
- JSON compatible.
- When the only global elements are defined in a no-namespace schema, XML instance documents:
  - never use prefixes on element names
  - never (almost) have namespace prefix definitions in them

The only namespace prefix definitions one _may_ still require in XML instance documents are
exactly these:
- `xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"` - used for `xsi:nil` and `xsi:type`
  attributes
- `xmlns:xs="http://www.w3.org/2001/XMLSchema"` - used for values of `xsi:type` attributes

For example:
```xml
  <data xsi:nil="true" />
  <start xsi:type="xs:dateTime" >1961-02-01T06:02:03Z</start>
```
The `xsi:nil` attribute is only needed if a DFDL schema uses nillable elements.
The `xsi:type` attribute is only used during test/debug activities to 
enable type-sensitive equality comparison[^ztime].
These exceptions never create the need for an _element_ to have a namespace prefix.

[^ztime]: For example the `xs:dateTime` value `1961-02-01T01:02:03-05:00` is US.EST equivalent
    to `1961-02-01T06:02:03Z` which is UTC.

> **Security Note:** Avoiding element prefixes and namespace prefix definitions is also
> considered a
> cyber-security improvement for XML since they can be used for covert channels without
> making the document invalid.
> A primary use case for DFDL and Daffodil is in _data cybersecurity_ where this principle
> is important!

Summary:
- A DFDL schema should consist almost entirely of type and group definitions.
  - The type and group definitions should have a target namespace.
  - These files should contain no global elements at all.
- Schema files that define global elements should have one or at most two global element
  declarations in them, and those should be the only definitions in that file.
- These global elements should have _no target namespace_.
- If the DFDL schema is a component library, then the global elements exist for testing only
  and are ignored entirely when the schema is reused as part of a larger schema.

## Namespace URI Conventions

There are good conventions to use when
- choosing a namespace URI for a DFDL schema, and
- choosing namespace prefixes

Suppose you work for example.com, and you have XML Schemas, DFDL Schemas, and JSON schemas.

Let's suppose you have a DFDL schema for a format named "ebx data".  
Suppose there are various versions of this format.

The following is a useful namespace URI and prefix definition for this format:
```xml
xmlns:ebx="urn:example.com:schema:dfdl:ebxData:ebx"
```
This has these benefits:
- The URI is a
  [URN (Universal Resource Name)]({{site.data.links.reference.urn}})
  which means it is not an identifier nor a location to retrieve from.
- It is unique to your company/organization
- It identifies it as a DFDL schema namespace
- It contains the format name
- It ends with the suggested prefix to be used for this namespace

Note also that there is no version information at the end of this URI.
This turns out to be a best practice.

Everyone who sees this namespace URI alone as in an import statement like this:

```xml
<import namespace="urn:example.com:schema:dfdl:ebxData:ebx"
        schemaLocation="/com/example/schema/dfdl/ebxData.dfdl.xsd"/>
```

From this one automatically knows the prefix to use by convention, because it is the
last part of the namespace URI.

These conventions for the `schemaLocation` are also useful as they provide something like
the Java package system to avoid name collisions.

## Versioning - In the Infoset/Data, Not the Namespace URI {#noVersionsInNamespaceURIs}

It's become clear in XML Schemas (not just DFDL) that having version specific namespace URIs 
causes difficulty.

One issue is that the path expressions that navigate such elements become version specific even if 
the elements they are ultimately accessing are common to multiple versions. Such paths are 
monomorphic to specific versions. It is much nicer if path expressions are as polymorphic 
across versions as possible.

Hence, define an element in your schema to hold the version information.
Don't append a version number to a namespace URI.

(Since JSON has no namespaces, you can't use namespaces to carry version information if you want
to use JSON.
Hence carrying version information in an element makes your schema more JSON
compatible.)

# Express DFDL Properties on the Simple Types, not the Elements

Data formats usually are repetitive.
The same format properties are often needed repeatedly for many different elements in the overall
format.

This is best captured by defining named types and groups.
Redundancy is then avoided by sharing use of types for every element having that same format.

One then avoids repetitive DFDL properties by placing the properties on the simple type
definitions rather than on the elements having that type.

It would be nice to say this applies for both simple and complex types, but alas the same exact
style is not usable on complex type definitions, which do not carry DFDL properties in
DFDL version 1.0.
To avoid redundant properties on complex types it is suggested that named format definitions
are created and used on each complex type variation.
This is not quite as clean, but minimizes redundancy within what is allowed.

Note that the DFDL Workgroup is considering adding the ability to [put DFDL properties on complex
types]({{site.data.links.dfdlSpec.issue71}}) in a future version of the DFDL standard.

# Avoid Child Elements with the Same Name {#AvoidChildElementsWithSameName}

XML Schema has a data model with some flexibility needed only for markup languages.

DFDL uses XML Schema to describe structured data, where this flexibility is not needed.

DFDL omits many XML Schema constructs, but DFDL version 1.0 still allows some things that are
best avoided to insure the ability to interoperate with other data models.

One such feature is the ability in XML Schema to have multiple child elements with the same name.
So long as it is unambiguous what element declaration is intended, XML Schema allows things like:
```xml
...
<element name="foo" ..../>
<element name="bar" ..../>
<element name="foo" ..../>
```
This is allowed because the element `bar` separates the two different declarations of
the `foo` element;
hence, when parsing XML, the first `foo` declaration is used until a `bar` element is
encountered, and after that the second `foo` declaration is used.

That's all interesting and useful for markup languages, but no other structured data system allows this.
Hence, while DFDL v1.0 allows this, it is best avoided to enable DFDL schemas to be interfaced to
data systems having more typical data models.

You can see why XML Schema allows this if you think about markup as in HTML.
XML is for markup languages and XSD is for describing them.
In a markup language you are often going to need lots of the same tag to appear within text
repeatedly, separated by other tags at that same level of nesting.
The fact that the instance data is XML means the tag-names make it easy to tease apart the document.

DFDL is for describing data that has no tags or specific syntax that the schema language
can depend upon.
So it provides only a subset of XSD features, and best practice is to avoid things that aren't
typical in structured data systems.

JSON also has no notion of child elements with the same name, so avoiding this enables a
DFDL schema to be JSON compatible.

# Avoid Anonymous Choices {#avoidAnonymousChoices}
XML Schema allows a choice to be anonymous within the data model of an element. For example:
```xml
<element name="myElement">
  <complexType>
    <sequence>
       ... various elements ...
       <choice>
         ... choice branches ...
       </choice>
       ... various more elements
    </sequence>
  </complexType>
</element>
```
The choice above appears in the middle of a sequence group, with elements and/or other groups
before and after it.
Note that there is no element name associated with the choice.
Rather in XML data, the choice branches would at some level within them contain elements
and these would appear as direct children of the `myElement` parent element.

Many other data modeling languages do not have this capability.
They require choices to be named.

Hence, this sort of anonymous choice is to be avoided.

There are two ways to avoid trouble here.

- Choice groups should always be the model-groups of named elements.  
- Choice branches within the choice are all just _scalar_ elements (meaning non-dimensioned:
`minOccurs` and `maxOccurs` are both absent or are both "1").

So for example, this is fine:
```xml
 <complexType name="TransportLayer">    
   <choice dfdl:choiceDispatchKey="{ xs:string(../Protocol) }">
     <element name="TCP" type="eth:TCP" dfdl:choiceBranchKey="6"/>
     <element name="UDP" type="eth:UDP" dfdl:choiceBranchKey="17"/>
   </choice>
 </complexType>
 ```
because the choice is the model group of a complex type.
That can only be the type of an element, so this choice is the model group of that element's content.
It's not anonymous.

The other way of avoiding trouble is having each choice branch be a scalar element:
```xml
<sequence>
  <element name="Type" type="bb:bit" dfdl:length="8".../>
  <element name="Code" type="bb:bit" dfdl:length="8" .../>
  <element name="Checksum" type="bb:bit" dfdl:length="16"/>
  <choice dfdl:choiceDispatchKey="{ fn:concat(xs:string(./Type), '_', xs:string(./Code)) }">
    <element name="EchoRequest" dfdl:choiceBranchKey="8_0"...>
    <element name="EchoReply" dfdl:choiceBranchKey="0_0" ...>
  </choice>
</sequence>
```
Here we see that the choice is anonymous within the sequence, but the choice branches are just scalar elements.
Data modeling systems with no notion of a choice can model these two choice branch
elements each as an optional element.  
Apache Spark Struct has no equivalent of choice in it; hence, choice branches must be modeled as
optional elements.

By using using these techniques, one insures one's DFDL schema can be mapped to the data
structures of the other data systems which do not allow anonymous choices.

# Versioning and Choices - Using Marker Elements {#versionInMarkerElements}

Given two different versions of a schema, consider:

```xml
<complexType name="v1OrV2">
  <choice>
    <element name="v1">
       <complexType>
          <sequence>
             <element name="a" .../>
             <element name="c" type="xs:int" dfdl:length="7"/>
          </sequence>
       </complexType>
    </element>
    <element name="v2">
       <complexType>
            <sequence>
             <element name="b" .../>
             <element name="c" type="xs:int" dfdl:length="6"/>
             <element name="spare" type="xs:unsignedInt" dfdl:length="1"/>
           </sequence>
       </complexType>
    </element>
  </choice>
</complexType>
```
Note both versions 1 and 2 have a child named `c` which is an `xs:int`.

This has the drawback that the path to reach element `c` must have a parent that is version
specific even though element `c` is common to both versions.
The two differ only by a DFDL property (`dfdl:length`).

Consider instead using this technique:
```xml
<complexType name="v1OrV2">
  <choice>
    <sequence>
      <element name="v1" type="pre:empty"/>
      <element name="a" .../>
      <element name="c" type="xs:int" dfdl:length="7"/>
    </sequence>
    <sequence>
      <element name="v2" type="pre:empty"/>
      <element name="b" .../>
      <element name="c" type="xs:int" dfdl:length="6"/>
      <element name="spare" type="xs:unsignedInt" dfdl:length="1"/>
    </sequence>
  </choice>
</complexType>
```
This uses a marker element which will be `<v1/>` or `<v2/>` before the other elements.
A path to the `c` element will not have a `v1` nor `v2` element parent.

Such paths are then version polymorphic, which is very much preferable.

The type `pre:empty` can be defined to be an unaligned empty sequence so that it has no
representation in the data stream.

# Parse and Unparse Symmetry

Some DFDL schemas are written to parse data only.
This section is about the other case where the schema is also being used to unparse the data.

It is generally considered best practice for a schema that parses and unparses data to have
symmetric behavior, meaning: if the parse produces an infoset, that infoset can be unparsed
successfully.

There are exceptions to this if the DFDL schema is designed to tolerate malformed data by
capturing it explicitly into _reject elements_ to allow debug or analysis.
Such reject elements should fail to unparse.

# Avoid Choices with Empty Branches

See also [this email about choices with empty branches](
{{site.data.links.dafLists.emptyBranchesEmail}}), for example:

```xml
<choice>
  <element name="foo" type="xs:int" />
  <sequence />
</choice>
```
This is best avoided as it causes incorrect XSD validation in current versions of Xerces C,
a popular XML validator library.

See issue: [XERCESC-2243 - choice validation with branch an empty sequence does not validate
correctly]({{site.data.links.apacheJira.xercesc2243}}).

# Normalizing Units of Measure

Binary data often uses integers to represent quantities that are scaled in some manner.
These slides illustrate how DFDL should be created to 
[_normalize the units of measure_](/best-practices/P-DFDL-Units-Normalization.pdf)
to make the data convenient to use and easy to understand. 

# Large Schemas and Schema Generators: Coping with Large Data Format Specifications

DFDL schema projects for large data formats often start from a large specification document 
having thousands of pages. If you are lucky there is a database description of the format, but 
if not these slides illustrate 
[how to scrape and generate DFDL](/best-practices/P-DFDL-Schema-Generation.pdf), 
that is, reverse engineer a machine-readable specification 
from the spec document and then generate the DFDL schema from that.

## Include Documentation Strings

When capturing element names and types from a format specification it is best practice, when 
possible, to also capture documentation blocks. 
Incorporating this documentation into annotations on the DFDL schema simply makes the schema 
more useful. 
For example one can generate online help text from the DFDL schema rather than forcing users to 
search through the specification document. 

## Preserve Naming and Connection back to the Specification Document

Large data format specifications often have conventions in the way things are named which makes 
finding them in the specification easier. 
For example, in the data dictionary for a format, each entry may have a specific identification 
number allowing similarly named data dictionary items to be robustly distinguished. 

In a DFDL schema for this format it is best to reproduce and use these identification numbers, 
not to the exclusion of meaningful names, but as an adjunct to them.
This enables users who are familiar with the format specification and these identification 
numbers to immediately understand the 
connection between that specification and the DFDL schema.

## Style of Generated Schemas

The best practice for generated DFDL schemas is that they should be generated so they look 
as if they were written by hand in that they should follow DFDL schema best practices.
End users of large DFDL schemas will often need to subset or customize them by hand, so the 
organization of the DFDL schema into files should lend itself to this kind of customization.

## Plan Ahead for Multiple Versions

Large data format specifications often have many versions that are in active use. 
DFDL schema generators should be planned with this in mind. 

For example, the _machine readable_ version of the format specification
(such as would be output from a 
[Spec Scraper](/best-practices/P-DFDL-Schema-Generation.pdf))
should be designed to 
enable identification of the deltas/differences between versions of the schema.
For a large data format, it is most often the case that the differences from one version to the next
are small.

>
> ### About Spec Deltas
>
> A delta between two versions of a format specification document can be classified as one of 
> these kinds:
> 1. Prose Correction: A clarification or correction to the text of the document that improves it, 
>    but does not represent any actual change to the data format.
> 2. Spec Format Correction: An update to the specification that makes the spec properly reflect 
>    the defacto data format. 
>    For example, a specific data field is defacto 3 bytes long, but a prior version of the 
>    spec incorrectly stated it was 4 bytes long.
>    The new version of the spec corrects this mistake.
> 3. Spec Infoset Correction: An update to the specification that changes the infoset but not the 
>    underlying format. 
>    For example, the name of a field might be corrected or changed.
> 4. Addition: An update to the specification that extends it in a way that is compatible 
>    with the prior version, for example, adding a new message type to a message data format. 
> 5. Change: An update to the specification that indicates data conforming to the new version will 
>    be different from data conforming to the prior specification. 
>
> Notice that the first two kinds of deltas do not affect the DFDL schema for a format. 

Use of the delta information enables generation of a DFDL schema which is much easier to use 
because the common parts that do not vary with different versions are going to make up the bulk 
of the schema. 

The goal is that access (using DFDL or XPath _expressions_) to the infoset uses paths which are 
usually _polymorphic_ across versions - it is not necessary to have path components that specify a 
version if there are no deltas between versions for the fields of data being accessed. 
Version-specific differences are then the only places where users must be version aware when 
accessing or creating infosets. 

For example suppose a data format has specifications with revisions A, B, C, and forthcoming 
revision D. 
In the future additional revisions could also occur. 
While one may only have need for revision B for a specific data processing need, it is 
best to plan for the schema to be able to handle many revisions. 
If in the future you also need to handle revision C, then it is best to issue an updated
DFDL schema for the format that is able to handle _both_ revisions B and C, rather than 
separate DFDL schemas for each version. 

See other version-related guidance about:
- [Avoid Versions in Namespace URIs](#noVersionsInNamespaceURIs)
- [Versioning using Marker Elements](#versionInMarkerElements)

## Version Fields and DFDL Variables for Versions

If the data contains a version identifier field, then this field can be used to select 
the version using DFDL choices. 
If the data does _not_ contain a version identifier field, then an external _DFDL Variable_ 
should be defined by the schema which specifies the version. 
The value of this variable should be captured in an element of the infoset.
This enables the schema to be used as a payload component with, for example, a header schema which 
provides the version of the payload. 
The assembly schema that combines the header and payload component schemas would simply bind the 
DFDL variable using `dfdl:newVariableInstance` so that the payload part of the data would be 
properly processed. 

## How Many Files in a DFDL Schema?

From experience, it is worth limiting the number of files generated for a schema in a manner 
consistent with user needs to modify or subset the schema. 
For example, a schema for a message data format with 
100 message types should have approximately 100 files, i.e., one per message, along with a 
small number of other files to define a common type library, dispatch to the different message 
types, etc. 
This enables users to create schemas that handle only a subset of the messages, or to readily 
customize or create variant messages by modifying or duplicating single files of the schema by 
hand appropriately. 

Because DFDL schemas are often used as XML schemas for data that has been converted into
XML, there is some justification to creating even fewer files so long as the ability to
modify/subset the content remains feasible given the organization and order of the items in the 
file.
Limiting the number of files can make use of the schema with other XML utilities and tools much
easier, as experience has shown that such tools are commonly built with the assumption that a
schema consists of a few files only.

We would not go so far as to recommend DFDL schemas be created as single files only except for
very small examples intended for teaching/illustration or bug reporting.
For example, within [TDML (Test Data Markup Language) files](/tdml) small DFDL schemas that
illustrate tests can be embedded directly.

## Large Data Dictionaries in Single Files

Many large data formats come with a _data dictionary_ that defines a large number of field types 
that are reused multiple times in the format. 
In one large format there are over 1200 different entries in the data dictionary. 
An example of what a DFDL schema generator should *not* do, it's clearly unreasonable to generate
one schema file per data dictionary entry. 
Rather, a single somewhat large, even multiple megabyte-sized, DFDL schema file containing the 
DFDL definitions for the entire data dictionary is more sensible despite the fact that if a user 
wants to subset the schema they would not be able to easily determine the parts of the data 
dictionary they need without creating tools to isolate this. 

One valuable exception to this policy is for 
[large enumerations](/dfdl-extensions#dfdlxEnumerations). 
Placing those in separate files, or having a separate file where all the enumerations are 
defined often helps users avoid having to scroll past thousands of lines of enumeration constants. 

# Appendix: Namespaces, Namespace Prefixes, Import, Include, and the `schemaLocation` Attribute

> This section provides rationale for the conventions already described above for avoiding
> elements with namespaces entirely, choosing schema target namespace URIs methodically, etc.

Namespaces and namespace prefixes in XSD seem simple enough until you start building a very
large DFDL schema from multiple disjoint component schemas that are intended for reuse.

DFDL does not have any namespace features of its own, it simply passes through XML Schema's
namespace and prefix system.

> **Note:** DFDL does not have the XML Schema "redefine" construct, but neither do
> many other XML Schema software platforms.

Without following a reasonable set of standard practices it is quite easy to end up in
what we call _namespace hell_.
In this situation you get all sorts of diagnostic messages about symbols not being defined,
but your import/include files seem to be well specified.
Debugging this can be problematic and you end up with roughly the situation that the
guidance below specifies, just after much work and wasted time.

It's also the case that many DFDL applications do not use XML as their output data format.
JSON is very popular also, and direct connectors to other data transformation and
processing fabrics are in the works which have their own particular data models.
XML's data model, and namespace system, really have no corresponding features in many
of these other systems like JSON. (E.g., JSON does not have namespaces.)

The practices here insure a DFDL schema's use of namespaces does not prevent parser/unparser
creation/consumption of JSON, or other kinds of data output, using a DFDL processor.

## Staying out of Namespace Hell

The first set of simple rules for staying out of trouble is this:

- For every target namespace, choose a unique prefix to use everywhere in your schema to refer to
  that namespace.
- The practice of using xmlns:tns prefix within schemas to refer to "this target namespace"
  should not be used.
- Schema type and group definitions should, with few exceptions, have a target namespace.
  - Issue: [DAFFODIL-2916]({{site.data.links.apacheJira.daf2916}}) - xs:include of
    no-namespace schema does not chameleon the references
    properly (closed now, but existed in Daffodil versions prior to 3.9.0) means reuse of
    no-namespace schemas is nearly impossible.
- A default namespace should be used only for the XML Schema namespace to avoid having to type
  "xs:" or "xsd:" everywhere.
- Global "root" elements should be defined with _no target namespace_.

Different schema projects can use different prefixes, but within one schema project one
namespace should mean one prefix globally across all files.

The most critical guidance rules are these:

- For every target namespace, one file must be the _single distinguished file_ providing that
  namespace.
  It is the one-and-only `schemaLocation` file that is `xs:import`-ed anywhere one must import that
  namespace.
- That distinguished file must `xs:include` all the other files that share that target namespace.

Note that cyclic usage between namespaces is allowed. Two schema files can `xs:import` each other.
So long as they have different target namespaces.

However, `xs:include` relationships cannot be cyclic.

The rest of this section is effectively just providing rationale for the above guidance.

## Things that Don't Work

Sometimes people want to decompose one namespace into several sub-units, and only import the
symbols for the  features of that namespace they need and are using.
So they expect they can import a namespace by importing only a specific file that contributes
part of the definitions for that namespace.

This does not work.

To achieve that sort of modularity you must decompose to different namespaces.

The best mental model to understand this is: imagine all the `schemaLocation` attributes
were erased from all `xs:import` statements.
Imagine the namespace URIs are actually being used to retrieve the namespace file.
With this erasure you can only have one place where everything is getting that namespace
because that namespace is defined by its URI, and that's also how you retrieve it.

That's how XSD works. One namespace == one source == one file providing its definition.

Some people actually create schemas this way, without `schemaLocation` on `xs:import` statements.
Then they use an XML Catalog to provide the 1 to 1 mapping of namespaces to the single
distinguished file that provides its definition.

We have not used XMLCatalogs much and they are not recommended, as they introduce their own complexities.
(Daffodil does support them.)

Going back to practices for `xs:import`, adding back in `schemaLocation` attributes, it should
be clear now that all across a schema, there is a 1 to 1 association of namespaces to a
specific `schemaLocation`. So every `xs:import` anywhere in your schema, for a given namespace `X`
must provide the same exact schemaLocation `Y`.

If you have, anywhere in your schema....
```xml
<import namespace="ns" schemaLocation="location"/>
```
then for any specific `ns`, the `location` must always be the exact same file path/name.

## What is the problem with the `tns` prefix?

If you follow this style guide and have no global elements in namespaces then this won't come up

However, if you do have global elements in namespaces then using `tns` for "target namespace" as a
prefix causes trouble.

It often results in bigger XML due to the need to have `xmlns:tns="...." ` rebindings in
multiple places in XML instance documents.
When these are deep in the element nest they can be hard to find.

It also makes XML instance documents harder to interpret (for people), as deep inside an
XML document an element has `tns:someName` , but the binding of `tns` prefix is far away
(textually, for example many pages of text prior, but not necessarily at the start),
and so not clear in that context.  
Basically, when looking at an XML instance document, a person gets very little information
from a `tns` prefix.

If `tns` prefixes are used only for type and group references, and never for element references,
one might find that this reduces some editing, and as element references are generally frowned
upon this should not come up often.
However, if the prefix definition `xmlns:tns="...."` appears on the `xs:schema` element
then even when there is some other prefix also bound to the same namespace there is no telling
whether a given XSD tool will actually use `tns` or the other prefix when identifying an element
in XML instance documents.
So even if the schema author only ever uses `tns` for type and group references, the `tns`
prefix can still show up and cause confusion in XML instance documents.

Best practice is just avoid this `tns` convention entirely, and furthermore avoid having any
elements in namespaces at all.

# Appendix: Path Expressions and Namespaces

DFDL includes an expression language based on XPath.

Turns out that there are some "issues" with XPath 1.0 and XML namespaces.

## No XPath way to bind prefixes
If you have XML data that has a namespace, such as:
```xml
<data xmlns="urn:someNamespaceOrOther"><a>75</a></data>
```
Well, it turns out that there is no standard way to get this XPath to work:
```xml
    /data/a
``` 
There is no XPath 1.0-standard mechanism for associating a namespace with a prefix (or with the default namespace).
By that I mean there is nothing you can put in the path expression itself to specify the namespaces.  
Such mechanisms are available on APIs specific to the XPath-1.0 processor.

XPath-1.0 processors typically provide a way to bind namespace external to the XPath 1.0 expression.
For example, in JAXB, namespaces are bound to prefixes (and to the default namespace) using
the `NamespaceContext` method.

See [XPath.html]({{site.data.links.reference.java7Xpath}})
and the discussion on QNames in the class overview.
Also see
[NamespaceContext.html]({{site.data.links.reference.java7NamespaceContext}})
for details on how to bind the default namespace.

The `xmllint` command (and `libxml2` library on which it is based), binds unqualified names in XML 
Schema paths (such as in `xs:key` and `xs:unique` selectors) and applies a default namespace if 
one is defined.

XSLT however, does NOT do this.
Any default namespace binding is ignored in XSLT match and selector paths.

## Coping with Schemas having Elements in Namespaces

The above inconsistencies are yet another reason why the best practice is to avoid elements being
defined in any namespace at all.

However, some DFDL schemas do not follow these best practice guidelines. 
In that case, managing namespace prefixes can be a little bit tricky.

Daffodil constructs a namespace context object to provide resolution of prefixes on QNames.

In Daffodil the way this works, is that whenever we have a DFDL expression, we also have the 
encapsulating XML schema object that contained it.
The namespace scope of that XML schema object defines what the prefixes in the expression mean.
So we grab the namespace scope from the XML schema object, and use it to provide those definitions.
This applies to every kind of name reference _except unqualified path steps_.

Daffodil has a specific tunable parameter
called [`unqualifiedPathStepPolicy`](/tunables/#unqualifiedpathsteppolicy).
This tunable defaults to `noNamespace`, but if a DFDL schema is not using no-namespace 
elements in the recommended way, it can be set to
`defaultNamespace` or `preferDefaultNamespace`.

Suppose you write a schema and use the recommended convention of
`xmlns="http://www.w3.org/2001/XMLSchema"`.
This allows you to avoid the clutter of the `xs:` prefix on all the XML Schema elements.
However, the schema does have a target namespace, let's say `urn:myFormat`
bound to prefix `mf`.
Furthermore, let's say the schemas specifies `elementFormDefault="qualified"`.
That means all the local element names are also found in the target namespace.

Now how are unqualified path steps in such a DFDL schema to be 
interpreted?
For example, in the `dfdl:length` expression in this element declaration:
```xml
   <element name="data" type="int"
      dfdl:length="{ /a/b/c }" />
```
By default, Daffodil will assume the path steps in `/a/b/c` have no namespace.
But since your schema has a target namespace, and uses qualified local element names,
you really want the above to be equivalent to if you had qualified all the names with
prefixes:
```xml
   <xs:element name="data" type="xs:int"
      dfdl:length="{ /mf:a/mf:b/mf:c }" />
```
There is a way to get Daffodil to choose that interpretation which is binding the tunable
[`unqualifiedPathStepPolicy`](/tunables/#unqualifiedpathsteppolicy) tunable to 
`defaultNamespace` or `preferDefaultNamespace`.
This lets you write the path expression without qualified names, but at the cost of having
to change the default namespace for the surrounding element declaration or perhaps the whole 
schema, to be the target namespace using `xmlns="urn:myFormat` like so:
```xml
<xs:schema xmlns="urn:myFormat" ...>
  ...
  <xs:element name="data" type="xs:int" 
      dfdl:length="{ /a/b/c }" />
  ...
</xs:schema>  
```
Now Daffodil will properly interpret the path `/a/b/c` as if you had written `/mf:a/mf:b/mf:c`.

All names in the schema referring to other elements, types, groups,
defineFormat, defineVariable, or defineEscapeScheme also must be prefixed QNames in this case. 
But for path expressions it is very easy to forget that one must prefix all the steps
since those are QNames as well.

If you really want to write expressions like `/a/b/c`, i.e., without any prefixes on the steps, 
then you have to use the default namespace the same as the schema's target namespace,
and set the Daffodil `unqualifiedPathStepPolicy` tunable appropriately. 

But really you should just write or update your schema following the best practice recommendations 
herein, and avoid all of this complexity. 

The Daffodil tunables like `unqualifiedPathStepPolicy` are part of 
[_Configuration_ of Daffodil](/configuration/).

-------
<!-- Footnotes go below this line -->
