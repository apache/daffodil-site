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


## Test Data Markup Language (TDML)

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
  defaultRoundTrip="false">
   
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
