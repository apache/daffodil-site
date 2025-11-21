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

> **NOTE:** This other page: XPath Expressions and Namespaces should be integrated into this
> overall style guide.

This page is a collection of notes on how to create DFDL schemas to obtain some real benefits:
- Minmizes XML and XSD namespace complexity
- Provides composition properties so DFDL schemas can be reused as libraries in larger schemas
- Ensures compatibility of the schema with more restrictive infosets than XML.
  For example: JSON, Apache NiFi Records, or Apache Spark Structs.
- Ensures portability of the DFDL schema for use to validate XML infosets
  using multiple different _XML Schema Validation libraries_ such as [Xerces C](
  https://xerces.apache.org/xerces-c/) and [libxml2](https://gitlab.gnome.org/GNOME/libxml2).

The [DFDL Training](/dfdl-training) page lists several example schemas which follow this style guide
fully which you can use as good starting points.

This set of notes represents best practices after learning _the hard way_ from many debugging
exercises and creating a wide variety of DFDL schemas from small teaching examples to large
production schemas for major data formats with more than 100K lines of DFDL.

For those familiar with XML Schema (XSD) design patterns, our schema style is a variation of
what is called the
[_Venetian Blind_ pattern](
https://www.balisage.net/Proceedings/vol25/print/Bruggemann-Klein01/BalisageVol25-Bruggemann-Klein01.html),
that one might call _Strict Venetian-Blind Type Library_.

- "Strict" because we strongly minimize the use of global elements, namespaces,
  and some other XSD constructs that are highly specialized to XML as the data representation.
- "Type-Library" because we structure DFDL schemas so that there is always
  the option for a user to use the schema as a library within a larger encompassing
  DFDL schema by referencing a complex type definition provided by the library schema.

Below are the details.

# Avoid Element Namespaces

Much of the complexity of XML and XML Schema comes from their namespace features.
This can be avoided entirely by following simple conventions.

Since many data representations (such as JSON, Apache NiFi Records) have no notion of
namespaces, following this guidance keeps DFDL schemas compatible with those representations.

The conventions are:
- DFDL Schemas should use `elementFormDefault="unqualified"` (which is the default for XML Schemas).
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

```xsd mySchemaType.dfdl.xsd
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

```xsd
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
The `xsi:type` attribute is only used during test/debug activities to enable  
type-sensitive equality comparison[^ztime].
These exceptions never create the need for an _element_ to have a namespace prefix.

[^ztime]: For example the `xs:dateTime` value `1961-02-01T01:02:03-05:00` is US.EST equivalent to
`1961-02-01T06:02:03Z` UTC.

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
```xsd
xmlns:ebx="urn:example.com:schema:dfdl:ebxData:ebx"
```
This has these benefits:
- The URI is a
  [URN (Universal Resource Name)](
  https://en.wikipedia.org/wiki/Uniform_Resource_Name)
  which means it is not an identifier nor a location to retrieve from.
- It is unique to your company/organization
- It identifies it as a DFDL schema namespace
- It contains the format name
- It ends with the suggested prefix to be used for this namespace

Note also that there is no version information at the end of this URI.
This turns out to be a best practice.

Everyone who sees this namespace URI alone as in an import statement like this:

```xsd
<xs:import namespace="urn:example.com:schema:dfdl:ebxData:ebx"
           schemaLocation="/com/example/schema/dfdl/ebxData.dfdl.xsd"/>
```

From this one automatically knows the prefix to use by convention, because it is the
last part of the namespace URI.

These conventions for the `schemaLocation` are also useful as they provide something like
the Java package system to avoid name collisions.

## Versioning - In the Infoset/Data, Not the Namespace URI

It's become clear in XML Schemas (not just DFDL) that having version specific namespace URIs causes difficulty.

One issue is that the path expressions that navigate such elements become version specific even if the elements they are ultimately accessing are common to multiple versions. Such paths are monomorphic to specific versions. It is much nicer if path expressions are as polymorphic across versions as possible.

Hence, define an element in your schema to hold the version information.
Don't append a version number to a namespace URI.

(Since JSON has no namespaces, you can't use namespaces to carry version information if you want
to use JSON.
Hence carrying version information in an element makes your schema more JSON
compatible.)

# Express DFDL Properties on the Simple Types, not the Elements

Data formats usually are repetitive.
The same format properties are often needed repeatedly for many different elements in the overall format.

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
types](https://github.com/OpenGridForum/DFDL/issues/71) in a future version of the DFDL standard.

# Avoid Child Elements with the Same Name

XML Schema has a data model with some flexibility needed only for markup languages.

DFDL uses XML Schema to describe structured data, where this flexibility is not needed.

DFDL omits many XML Schema constructs, but DFDL version 1.0 still allows some things that are
best avoided to insure the ability to interoperate with other data models.

One such feature is the ability in XML Schema to have multiple child elements with the same name.
So long as it is unambiguous what element declaration is intended, XML Schema allows things like:
```xsd
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

# Avoid Anonymous Choices
XML Schema allows a choice to be anonymous within the data model of an element. For example:
```xsd
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

Choice groups should always be the model-groups of named elements.  
Choice branches within the choice are all just _scalar_ elements (meaning non-dimensioned:
`minOccurs` and
`maxOccurs` are both "1").
So for example, this is fine:
```xsd
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
```xsd
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

# Versioning and Choices - Using Marker Elements

Given two different versions of a schema, consider:

```xsd
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
```
Note both versions 1 and 2 have a child named `c` which is an `xs:int`.

This has the drawback that the path to reach element `c` must have a parent that is version
specific even though element `c` is common to both versions.
The two differ only by a DFDL property (`dfdl:length`).

Consider instead using this technique:
```xsd
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
https://lists.apache.org/thread/dw0y9xy2z9r78fw4yyojvgc9cj6npoh4), for example:

```xsd
<choice>
  <element name="foo" type="xs:int" />
  <sequence />
</choice>
```
This is best avoided as it causes incorrect XSD validation in current versions of Xerces C,
a popular XML validator library.

See issue: [XERCESC-2243 - choice validation with branch an empty sequence does not validate
correctly](
https://issues.apache.org/jira/browse/XERCESC-2243).

# Appendix: Namespaces, Namespace Prefixes, Import, Include, and the `schemaLocation` Attribute

> _This section provides rationale for the conventions already described above for avoiding
elements with namespaces entirely, choosing schema target namespace URIs methodically, etc.

Namespaces and namespace prefixes in XSD seem simple enough until you start building a very
large DFDL schema from multiple disjoint component schemas that are intended for reuse.

DFDL does not have any namespace features of its own, it simply passes through XML Schema's
namespace and prefix system.

(Note however: DFDL does not have the XML Schema "redefine" construct, but neither do
many regular XML Schema software platforms.)

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
  - Issue: [DAFFODIL-2916](https://issues.apache.org/jira/browse/DAFFODIL-2916) - xs:include of
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
were erased from all xs:import statements.
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
```xsd
<xs:import namespace="ns" schemaLocation="location"/>
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
