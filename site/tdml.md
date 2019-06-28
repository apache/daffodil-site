---
layout: page
title: Test Data Markup Language (TDML)
description: Test Data Markup Language
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


Test Data Markup Language (TDML) it is a way of specifying a DFDL schema, input
test data, and expected result or expected error/diagnostic messages, all
self-contained in an XML file. IBM created TDML to capture tests for their own
DFDL implementation. Daffodil latched onto this and has since extended it a
bit, though there is an effort to reconcile TDML dialects so that all
implementations can run the same tests.

A TDML file is often useful just to ask a question about how something in DFDL
works, for example, to get a clarification. It allows for a level of precision
that is often lacking, but also often required when discussing complex data
format issues. As such, providing a TDML file along with a bug report is the
absolutely best way to demonstrate a problem.

By convention, a TDML file uses the file extension ``.tdml``, or ``.tdml.xml``
when used with the TDML "tutorial" feature.

The schema for a TDML file is available on [GitHub](https://github.com/apache/incubator-daffodil/blob/master/daffodil-lib/src/main/resources/org/apache/daffodil/xsd/tdml.xsd).

Below is an annotated TDML file for a very simple example:

```xml
<?xml version="1.0" encoding="ASCII"?>
 
<tdml:testSuite
  suiteName="Bug Report TDML Template"
  description="Illustration of TDML for bug reporting."
  xmlns:tdml="http://www.ibm.com/xmlns/dfdl/testData"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:dfdl="http://www.ogf.org/dfdl/dfdl-1.0/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ex="http://example.com"
  xmlns:gpf="http://www.ibm.com/dfdl/GeneralPurposeFormat"
  xmlns:daf="urn:ogf:dfdl:2013:imp:daffodil.apache.org:2018:ext"
  xmlns="http://www.w3.org/1999/xhtml"
  xsi:schemaLocation="http://www.ibm.com/xmlns/dfdl/testData tdml.xsd"
  defaultRoundTrip="none">
   
  <!--
    This example TDML file is for a self-contained bug report.
   
    It shows the definition of an inline schema and parse test and unparse test that use that schema.
  -->

  <!-- 
    A DFDL schema is defined inside the tdml:defineSchema element. The contents
    are similar to a normal DFDL schema, allowing for imports, defining a
    global format via dfdl:defineFormat and dfdl:format, and defining schema
    xs:elements/groups/types/etc.
  -->

  <tdml:defineSchema name="bug01Schema" elementFormDefault="unqualified">
 
    <xs:import
      namespace="http://www.ibm.com/dfdl/GeneralPurposeFormat"
      schemaLocation="IBMdefined/GeneralPurposeFormat.xsd" />
      
    <dfdl:defineFormat name="myFormat">
      <dfdl:format ref="gpf:GeneralPurposeFormat"
        lengthKind="implicit"
        representation="text"
        encoding="ASCII"
        initiator=""
        terminator=""
        separator="" />
    </dfdl:defineFormat>
  
    <dfdl:format ref="ex:myFormat" />
 
    <xs:element name="myTestRoot" type="xs:dateTime"
      dfdl:calendarPattern="MM.dd.yyyy 'at' HH:mm:ssZZZZZ"
      dfdl:calendarPatternKind="explicit"
      dfdl:lengthKind="delimited"
      dfdl:terminator="%NL;" />
  
  </tdml:defineSchema>
 
  <!--
    Define a parse test case, using the above schema and root element. Input
    data is defined along with the expected infoset.
  -->

  <tdml:parserTestCase name="dateTimeTest" root="myTestRoot" model="bug01Schema"
    description="A hypothetical bug illustration about parsing a date time.">
    
   <tdml:document>
     <tdml:documentPart type="text"
       replaceDFDLEntities="true"><![CDATA[04.02.2013 at 14:00:56 GMT-05:00%LF;]]></tdml:documentPart>
   </tdml:document>
 
   <tdml:infoset>
     <tdml:dfdlInfoset>
       <ex:myTestRoot>2013-04-02T14:00:56.000000-05:00</ex:myTestRoot>
     </tdml:dfdlInfoset>
   </tdml:infoset>
      
  </tdml:parserTestCase>

  <!--
    Define an unparse test case, using the above schema and root element. An
    input infoset is defined along with the expected unparsed data.
  -->
 
  <tdml:unparserTestCase name="unparseDateTimeTest" root="myTestRoot" model="bug01Schema"
    description="Another bug illustration, this time unparsing direction.">
 
    <tdml:infoset>
      <tdml:dfdlInfoset>
        <ex:myTestRoot>2013-04-02T14:00:56.000000-05:00</ex:myTestRoot>
      </tdml:dfdlInfoset>
    </tdml:infoset>
 
    <tdml:document>
      <tdml:documentPart type="text"
        replaceDFDLEntities="true"><![CDATA[04.02.2013 at 14:00:56-05:00%CR;%LF;]]></tdml:documentPart>
   </tdml:document>
        
  </tdml:unparserTestCase>
    
</tdml:testSuite>
```

Suppose you save the above out as a file ``myDateTimeBug.tdml``. You can then run
it using the ``test`` subcommand of the [Daffodil Command Line Interface](/cli):

```
$ daffodil test myDateTimeBug.tdml
```

### Specifying Test Data

Test data can be specified in text, hexadecimal, individual bits, or in an
external file by setting the ``type`` attribute in the ``tdml:documentPart``
element. Multiple ``tdml:documentPart`` elements are combined to create the
test data. The different documentPart types are illustrated below.

```xml
<tdml:document>
  <!--
    A document part with type="text" is text. It is often a good idea to use
    CDATA to avoid whitespace changes made by some autoindenting IDE's.

    So in the example below, the line ending after '250;' and after '967;' are
    intentional parts of the data so as to illustrate that the whitespace is
    preserved.

    If you care exactly which kind of line ending is used, then you can use
    DFDL character entities to insert a %CR; %LF; or both. In this example,
    because the whitespace is expressed as whitespace, it depends on the
    platform where you edit this file whether the line ending is a LF (Unix
    convention), or a CRLF (MS Windows convention). By convention, it is
    usually recommended to use Unix style line-endings in TDML files and use
    character entities if explicit line endings are being tested.

    If you want to use DFDL character entities, you must turn on the
    replaceDFDLEntities="true" feature of the documentPart element.
  -->

  <tdml:documentPart type="text"><![CDATA[quantity:250;
hardnessRating:967;
]]></tdml:documentPart>

  <!--
    In 'text' both XML character entities, and DFDL's own character entities
    are interpreted.

    So here is a NUL terminated string that contains a date with some Japanese
    Kanji characters. The Japanese characters are expressed using XML numeric
    character entities. The NUL termination is expressed using a DFDL character
    entity.

    In this example one has no choice but to use a DFDL character entity. The
    NUL character (which has character code zero), is not allowed in XML
    documents, not even using an XML character entity. So you have to write
    '%NUL;' or '%#x00;' to express it using DFDL character entities.
  -->

  <tdml:documentPart type="text"
    replaceDFDLEntities="true"><![CDATA[1987&#x5E74;10&#x6708;&#x65e5; BCE%NUL;]]></tdml:documentPart>

  <!--
    Type 'byte' means use hexadecimal to specify the data. Freeform whitespace
    is allowed and  any character that is not a-zA-Z0-9 is ignored. So you can
    use "." or "-" to separate groups of hex digits if you like.
  -->

  <tdml:documentPart type="byte">
    9Abf e4c3
    A5-E9-FF-00
  </tdml:documentPart>

  <!--
    Type 'bits' allows you to specify individual 0 and 1. Any character other
    than 0 or 1 is ignored.

    The number of bits does not have to be a multiple of 8. That is, whole
    bytes are not required.
  -->

  <tdml:documentPart type="bits">
    1.110 0.011 1   First 5 bit fields.
  </tdml:documentPart>

  <!--
    Type 'file' means the content is a file name where to get the data
  -->

  <tdml:documentPart type="file">/some/directory/testData.in.dat</tdml:documentPart>

</tdml:document>
```
Note that in order for a test to be considered successful, it must consume all
the data defined in the ``tdml:document`` element. Otherwise the test will fail
with a message about "left over data".

### Specifying the Infoset

The infoset can be provided either as an inline XML infoset or as a path to an
external file by setting the ``type`` attribute on the ``tdml:dfdlInfoset``
element. If not provided, the type defaults to inline XML. For example:

```xml
<tdml:infoset>
  <tdml:dfdlInfoset type="infoset">
    <ex:myTestRoot>2013-04-02T14:00:56.000000-05:00</ex:myTestRoot>
  </tdml:dfdlInfoset>
</tdml:infoset>

<tdml:infoset>
  <tdml:dfdlInfoset type="file">/some/directory/testData.in.xml</tdml:dfdlInfoset>
</tdml:infoset>
```

Note that the ``tdml:dfdlInfoset`` may need to contain characters that are not
legal in XML documents. Daffodil remaps these characters into legal XML
characters in the Unicode Private Use Areas (PUA). See [XML Illegal
Characters](/infoset#xml-illegal-characters) for details.

### Negative Tests: Expecting Errors/Warnings

A poor or missing diagnostic message is a bug just as much as a broken feature.
TDML allows for creating negative tests to expect errors and warnings. To do
expect errors, replace the ``tdml:infoset`` element with a ``tdml:errors``
element:

```xml
<tdml:errors>
  <tdml:error>Schema Definition Error</tdml:error>
  <tdml:error>testElementName</tdml:error>
</tdml:errors>
```

Each ``tdml:error`` child element contains a sub-string which must be found
somewhere in the set of diagnostic messages that come out of the test. The
comparison is case-insensitive.

The ``tdml:warnings`` and ``tdml:warning`` elements behave just like the error
counterparts to define warnings that should be created during the test. Note
that warnings are considered non-fatal and so can appear alongside
``tdml:errors`` and ``tdml:infoset`` elements.

```xml
<tdml:warnings>
  <tdml:warning>Schema Definition Warning</tdml:warning>
  <tdml:warning>'http://www.ogf.org/dfdl/dfdl-1.0/' should be 'http://www.ogf.org/dfdl/'</tdml:warning>
</tdml:warnings>
```

### Using CDATA Regions

XML CDATA regions indicate XML data that should not be interpreted as XML.
Although in general is it used to easily include XML special characters in XML
data, its use has other benefits in TDML files as well. Below are examples of
what scenarios when CDATA regions should and should not be used.

#### {% ok %} &nbsp;As a clear way represent XML special characters

The characters ``<``, ``>``, ``&``, ``'``, and ``"`` must be represented in XML
with ``&lt;``, ``&gt;``, ``&amp;``, ``&apos;``, and ``&quot;``, respectively.
These special characters are not escaped when used in CDATA tags, which can
make the data more clear. For example, the following are equivalent:

```xml
<foo>abc&amp;&amp;&amp;>def</foo>
<foo>abc<![CDATA[&&&]]>def</foo>
```

#### {% ok %} &nbsp;To preserve textual formatting within TDML - for clarity reasons

Often times IDE's and XML editors will indent, wrap, and remove redundant
whitespace in XML data. However, sometimes it is desired that such formatting
is maintained for readability purposes. Many tools  refuse to perform
modifications on CDATA regions, so they can be used as a way to maintain
formatting. For example:

```xml
<tdml:documentPart type="byte"><![CDATA[
00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f
20 21    23 24 25    27 28 29 2a 2b 2c 2d 2e 2f
30 31 32 33 34 35 36 37 38 39 3a 3b    3d    3f
40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
]]></tdml:documentPart>
```

The data holes in the above matrix of hex would be hard to understand without
the formatting. But logically, the whitespace is irrelevant when the
documentPart type is "byte". In effect, we have CDATA here so that tooling like
IDEs, XML editor, etc. will not mess with the formatting of the content.

#### {% ok %} &nbsp;To avoid insertion of whitespace that would make things incorrect

Let us assume that the input document should contain exactly two letters:
``a年``. This might be represented as the following in a TDML file:

```xml
<document>
  <documentPart type="text">a年</documentPart>
</document>
```

The problem is that it is possible that an XML tool might reformat the XML as
this:

```xml
<document>
  <documentPart type="text">
    a年
  </documentPart>
</document>
```

But this is a text documentPart containing some letters with surrounding
whitespace. Our test, in this case, expects data of length exactly 2
characters, so could cause a failure. CDATA can be used to prevent many XML
tools from reformatting and inserting whitespace that could affect the test
input data:

```xml
<document>
  <documentPart type="text"><![CDATA[a年]]></documentPart>
</document>
```
#### {% err %} &nbsp;To preserve specific line endings

Using CDATA does NOT necessarily preserve line endings. So if you had a test
where you have this:

```xml
<documentPart type="text"><![CDATA[Text followed by a CR LF
]]></documentPart>
```

If you edit that on a windows machine, where CRLF is the usual text line
ending, then the file will actually have a CRLF line ending in that text. If
the test has say, ``dfdl:terminator="%CR;%LF;"``, then this should fail
because, no matter what, XML always standardizes line endings to just one
character: LF. XML replaces CRLF with LF, and isolated CR with LF. The net
result: by the time a program is reading the XML data, it should only see LF
line endings.

It is possible to get a literal CR character into XML content, but ONLY by
using the numeric character entity notation, i.e., ``&#xD;``. So one might try to
write the above test as:

```xml
<documentPart type="text"><![CDATA[Text followed by a CR LF]]></documentPart>
<documentPart type="text">&#xD;&#xA;</documentPart>
```

Even this, however, is not a sure thing, because re-indenting the XML might
cause you to get:

```xml
<documentPart type="text"><![CDATA[Text followed by a CR LF]]></documentPart>
<documentPart type="text">
   &#xD;&#xA;
</documentPart>
```

Which would be broken because of the whitespace insertions around the
``&#xD;&#xA;``.

There are two good solutions to this problem. First one can use type="byte"
document parts:

```xml
<documentPart type="text"><![CDATA[Text followed by a CR LF]]></documentPart>
<documentPart type="byte">0D 0A</documentPart>
```

This will always create exactly the bytes ``0D`` and ``0A``, and documentParts
are concatenated together with nothing between. However, this will break if the
documentPart has an encoding where CR and LF are not exactly represented by the
bytes 0D and 0A. For example currently we support
``encoding="us-ascii-7-bit-packed"``. In that encoding, CR and LF each take up
only 7 bits, resulting in 14 bits rather than 2 full bytes.

The best way to handle this problem is to use the documentPart
replaceDFDLEntities attribute:

```xml
<documentPart type="text" replaceDFDLEntities="true"><![CDATA[Text followed by a CR LF%CR;%LF;]]></documentPart>
```

The line gets kind of long, but those ``%CR;`` and ``%LF;`` are DFDL entities
syntax for those Unicode characters. These are translated into whatever
encoding the documentPart specifies, so this will be robust even if the
encoding is say, UTF-16 or the 7-bit encoding.

If you have a multi-line piece of data and need CRLFs in it, then this does get
a bit clumsy as you have to do it like this where each text line gets its own
documentPart:

```xml
<documentPart type="text" replaceDFDLEntities="true"><![CDATA[Of all the gin joints%CR;%LF;]]></documentPart>
<documentPart type="text" replaceDFDLEntities="true"><![CDATA[In all the towns in the world%CR;%LF;]]></documentPart>
<documentPart type="text" replaceDFDLEntities="true"><![CDATA[She walked into mine%CR;%LF;]]></documentPart>
```

So the general rule is that CDATA regions cannot be used to ensure that
specific kinds of line endings will be preserved in a file.

Some tests, however, are insensitive to the presence of whitespace. This is
true of many tests for delimited text formats. In those cases you may want
CDATA to preserve formatting of text (so it won't be re-indented), and to
preserve *some* line endings. If this same test example was instead using
``dfdl:terminator="%NL;"``, the NL entity matches CRLF, CR, or LF, and even
some other obscure Unicode line ending characters. In that case, the original
documentPart XML:

```xml
<documentPart type="text"><![CDATA[Of all the gin joints
In all the towns of the world
She walked into mine
]]></documentPart>
```

is fine, and will work and be robust.

### Round-Trip Testing

Round-trip testing is using a single test case for testing both parse and unparse directions.

The ``tdml:testSuite`` has a ``defaultRoundTrip`` attribute, and each test case can have a ``roundTrip`` attribute which overrides the default. 

The default behavior if nothing is specified in either the ``tdml:testSuite`` or the test case itself, is ``onePass``. The values of these attributes can be:

``none``

   : *tdml:parserTestCase:* Parse given data, compare to expected infoset.

   : *tdml:unparserTestCase:* Unparse given infoset, compare output data to expected data.

``onePass``

   : *tdml:parserTestCase:* Parse given data, compare to expected infoset, expect match. Unparse infoset, compare to given data.

   : *tdml:unparserTestCase:* Unparse given infoset, compare output data to expected data, expect match. Parse data to infoset, compare to expected infoset, expect match.

``twoPass``

   : *tdml:parserTestCase:* Parse given data, compare to expected infoset, expect failure. Unparse infoset, compare to given data, expect failure. Parse output data to a second infoset. Compare to first infoset, expect success.

   : *tdml:unparserTestCase:* Invalid

``threePass``

   : *tdml:parserTestCase:* Parse given data, compare to expected infoset, expect failure. Unparse infoset to first output data, compare to given data, expect failure. Parse first output data to second infoset. Compare to expected infoset, expect failure. Unparse second infoset to second output data, compare to first output data, expect success.

   : *tdml:unparserTestCase:* Invalid

``false``

   : Same as ``none``, used for backwards compatability

``true``

   : Same as ``onePass``, used for backwards compatability

A test must be designated as (or default to) requiring a specific number of passes. A test designated as ``twoPass`` must fail in ``onePass`` in order to succeed with the second pass. A test designated ``threePass`` must fail both the first pass, and second pass in order to succeed on the third pass. The ``twoPass`` and especially ``threePass`` modes must be used with caution as they can mask errors; hence, tests should be designed to need them when they are used.
