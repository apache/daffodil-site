---
layout: page
title: DFDL Training 
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

There are a few paths to take in order to learn DFDL depending on your goals and background.
This page provides resources allowing you to learn by working your way through labs that 
gradually introduce DFDL concepts, or you can plunge right into well-crafted DFDL schemas for 
basic data formats, and gradually work up to more complex ones. 

There is a general [Overview Presentation about DFDL](
{{ site.data.links.slides.overviewDFDL}}) with sections about:
- Motivation: Why we need DFDL
- Introduction to DFDL - including a tiny example
- Larger Examples: CSV, PCAP, MIL-STD-2045

The remaining sections are perhaps less interesting for DFDL beginners. 
- Where to get DFDL Schemas
- Apache Daffodil - What is in it
- Example of using Daffodil's Java API (yes it's "Hello World!")

Reading [Section 1]({{ site.data.links.dfdlSpec.intro}})(the introduction) of the 
[DFDL Specification]({{ site.data.links.dfdlSpec.specStart}})
is also a basic introduction to DFDL.

# Prerequisites

There are several things that you need to be familiar with to learn DFDL.
These include:
- XML - Extensible Markup Language
- XML Schema (aka XSDL or XSD)
- Basic Data Format Concepts
- DFDL Basic Terminology

### XML - Extensible Markup Language

Daffodil supports both JSON and XML, but the learning/training materials are very biased towards 
using XML.

- [{{ site.data.links.xml.introWho}} XML Tutorial](
{{ site.data.links.xml.introXML}}) - Gives a basic 
introduction to XML.
- [Our Slides: Introduction to XML]({{ site.data.links.slides.introXML}}) - Provides a deeper dig 
  into XML use as a data language and some of the challenges with escaping, CRLF/LF, NUL, and 
  whitespace.

### XML Schema (aka XSD or XSDL)

DFDL uses a subset of the XML Schema Definition Language (XSDL or XSD) to express 
the structure of data, meaning the field names,
their order, and nesting of hierarchical structure. 
This means that _a DFDL Schema **is** an XML Schema_. 

If you are familiar with the notion of a 
[_grammar_ or _BNF_]({{ site.data.links.reference.bnf}}),
XML Schema is conceptually similar.
It is more verbose, but provides standardized places to add _annotations_ to the schema
which allows DFDL to add the data format information onto the schema in a standard way.

- [{{ site.data.links.xml.introWho}} XML Schema Tutorial](
{{ site.data.links.xml.introXSD}}) - Gives the basics about XML Schema.
  - _Ignore anything about DTD, which are an older kind of schema for XML.
   DFDL does not use DTDs and in fact prohibits their use._
- [Our Slides: Introduction to XML Schema]({{ site.data.links.slides.introXSD}}) - Deeper 
  introduction giving more of the motivation for why DFDL is built on top of XML Schema.

### Basic Data Format Concepts

You will need to be familiar with these concepts:
- bit
- byte
- character set - ASCII, Unicode, UTF-8.
  Also called a character _encoding_.
- [byte order - big-endian and little-endian]( 
{{ site.data.links.referece.endianness}})
- [hexadecimal (aka hex)]({{ site.data.links.reference.hex}})

### DFDL Basic Terminology

DFDL uses these terms often:
- Native - the raw data format of the input to a DFDL parse process
- Infoset - the output representation of the parsed data. For learning purposes we'll assume 
  the Infoset is represented in XML. 
- Parse - to convert data from native format to an infoset
- Unparse - The preferred term for the opposite of parse: to convert data from an infoset back into 
  native form. 
  This is often called _serialization_ or _marshalling_ in other non-DFDL contexts.  
- DFDL Processor - either a DFDL Parser or DFDL Unparser
- Well-Formed - data is well-formed if a DFDL Parser can successfully produce an infoset. Note 
  that well-formed data may be _invalid_.
- Valid - A formal term meaning the infoset (as XML) is _schema valid_ in that 
  it has-been (or can be) validated using the DFDL schema (as an XML Schema). Note that the DFDL 
  schema can express more complex rules beyond just the usual XSD constraints by way of Schematron.  

There is also a [Glossary of DFDL Terms](
{{ site.data.links.dfdlSpec.glossary}}
) in the DFDL Specification. 

# Training Courses with Lab Exercises

There are training courses for DFDL which include hands-on lab exercises.

## Tools Needed for Hands-On Training

To do hands-on learning of DFDL you will want to interact with many of the open-source 
[DFDL schema projects on github]({{ site.data.links.schemas.dfdlSchemasSite}}).

You will need to download and install these tools:
- [git]({{ site.data.links.tools.git}}) - This may be pre-installed if you are running Linux. 
- [SBT (Simple Build Tool)]({{ site.data.links.tools.sbt}}) - This build tool is used by most 
  DFDL Schemas created for use with Apache Daffodil. It will automatically pull in the
  [Daffodil SBT Plugin](/sbt) when a DFDL schema project requires it. 
- [Apache Daffodil](/releases) - The Daffodil libraries and its Command Line Interface (CLI)

If you are familiar with the VSCode IDE, you may also want to install:
- [Apache Daffodil Extension for Visual Study Code](/vscode)

Many developers use their preferred Java IDE such as 
[JetBrains IntelliJ IDEA]({{ site.data.links.tools.idea}}). 
Others like the low level approach of just using the 
[Daffodil Command Line Interface (CLI)](/cli). 

## [CSV to Bin]({{ site.data.links.training.csvToBin}}) Training Course

The [CSV to Bin]({{ site.data.links.training.csvToBin}}) course has 7 labs starting from CSV 
(Comma Separated Values) and creating variants of it eventually ending with 
simple binary data examples. 
This course was intended to take 3 days, the last day being 
implementation of the [NTP (Network Time Protocol)](
{{ site.data.links.reference.ntpPacketHeaderDiagram}}
) message format.

You can [review the slides]({{ site.data.links.training.csvToBinSlides}}) which accompany the labs.

## [FakeTDL DFDL Training]({{ site.data.links.training.fakeTDL}}) Course

The [FakeTDL DFDL Training]({{ site.data.links.training.fakeTDL}}) course
has 5 labs all of which are about developing your own version of the _Fake TDL_ data format 
starting from its specification document.
On completion the DFDL schema should be equivalent to the 
official [FakeTDL DFDL Schema]({{ site.data.links.schemas.fakeTDL}}). 

You can [review the slides]({{ site.data.links.training.fakeTDLSlides}}) which accompany the labs.



# Learning from Example DFDL Schemas  {#exampleSchemas}

There are several simple DFDL Schemas that are well-structured, 
follow [best-practices](/dfdl-best-practices), include self-testing, 
and so serve as good starting points for learning DFDL. 

If a data layout diagram like [this one for NTP (Network Time Protocol)](
{{ site.data.links.reference.ntpPacketHeaderDiagram}}
) doesn't intimidate you, then perhaps you will want to 
just dig directly into:

- [DFDL Schema for NTP]({{ site.data.links.schemas.ntp}}) - You should recognize the field names
  from the diagram in the [primary _complex type_ definition in the `ntp-type.dfdl.xsd` file](
{{ site.data.links.schemas.ntpType}}
).

Another publicly available schema intended to help with understanding of binary data, 
specifically military messaging formats, is:
- [DFDL Schema: Fake TDL]({{ site.data.links.schemas.fakeTDL}}) - This includes a [Fake 
  TDL specification document](
{{ site.data.links.schemas.fakeTDLSpec}}) from which the DFDL schema is derived. 

The [MIL-STD-2045 Header Schema]({{ site.data.links.schemas.ms2045}}) is a useful example 
showcasing:
- _enums_ - a Daffodil extension of the DFDL v1.0 language.
- _bit order_ - this format numbers the bits of each byte starting _least-significant-bit-first_.
- Multi-version support - this schema handles both revisions C and D1 of the format 
  simultaneously.

# Other Learning Resources

There are a variety of other materials on the Internet that provide some DFDL training:

- [xFront Tutorials on DFDL]({{ site.data.links.training.xfront}})
- IBM
  - YouTube videos and numerous articles - search web for "IBM DFDL"
  - [Getting Started with the Data Format Description Language](
{{ site.data.links.training.ibmGetStarted}})
- Open Grid Forum DFDL Workgroup has 6 tutorials. 
  [Download PDFs from here]({{ site.data.links.training.ogfTutorials}}).

> **Note:** AI bots like ChatGPT and Gemini don't know much about
DFDL yet. (as of December 2025)

There is also a separate page about
[best-practices](/dfdl-best-practices) for DFDL schema authors to follow. 

## Presentations about DFDL/Daffodil

This site contains a 
[library of the Daffodil project team's presentations](/presentations) at 
events including the ASF annual conference, various MeetUps and user groups, etc. 
Both PDF and source (".pptx") forms of the slide presentations are available there. 

The most common use case for DFDL is to describe files of data thereby enabling 
_data integration_ into a common unified accessible form. DFDL for data integration 
is often _parse only_, as there is often no need to _unparse_ the data back into its original form.
However, there is also the
[Cybersecurity Use Case for DFDL](/presentations/P-DFDL-Cyber-Use-Case.pdf). 
This places a stronger emphasis on DFDL schemas that are able to both parse and unparse. 
Important features in DFDL, specifically the `dfdl:outputValueCalc` property, exist to support 
unparsing for this cybersecurity case. 

> **Note:** The ASF annual conference is now (since 2023) called 
> [_Community Over Code_](https://communityovercode.org/).
> It was formerly known as 
> [_ApacheCon_.](https://www.apachecon.com/history.html)

# Intermediate and Advanced DFDL Training Topics

## DFDL Schema Composition

The DFDL language is designed to allow large DFDL schemas to be created as compositions of other 
schemas.
Large complex schemas can be built up as _assemblies_ of _component schemas_.
This way a library of reusable DFDL component schemas can be built up and reused.
Each _component_ can be developed and tested in isolation.

The [DFDLSchemas site]({{ site.data.links.schemas.dfdlSchemasSite}}) has these schemas
which provide an extensive example of the techniques for composing a larger DFDL schema 
from smaller components:
- [Envelope Payload]({{ site.data.links.schemas.envPay}}) - an assembly of the next 3 schemas
- [TCP Message]({{ site.data.links.schemas.tcpMsg}})
- [MIL-STD-2045 Header]({{ site.data.links.schemas.ms2045}})
- [PCAP]({{ site.data.links.schemas.pcap}}) - a component of the above, but also assembles 
  PCAP-specific schema content with the next schema. 
  - [EthernetIP]({{ site.data.links.schemas.ethIP}}) - schema for Ethernet packets
    - EthernetIP makes use of an advanced Daffodil DFDL Language Extension 
      called [Layers](/layers) to compute IPv4 packet checksums.

A [slide deck on Schema Composition]({{ site.data.links.slides.comp}}) illustrates the nesting 
of DFDL schema payload components with surrounding DFDL schema headers/envelopes, which are also 
components. 


## Learning the Daffodil API

Most uses of Apache Daffodil will embed it within a data processing system by way of its API.
As of Daffodil 4.0.0 there is only a Java API for Daffodil, though it is usable from other JVM 
languages such as Scala. 
Prior versions of Daffodil had a Java API and a separate Scala API.
All the API documentation is available on this site via links such as:
- [Latest (Java) API](/docs/latest/javadoc)
- [Daffodil v3.11.0 API - for Java](/docs/3.11.0/javadoc) or [for Scala](/docs/3.11.0/scaladoc).

Examples showing how to use the API from Java are available on the 
[OpenDFDL]({{ site.data.links.examples.openDFDL}}) site. See:
- [helloWorld]({{ site.data.links.examples.helloWorld}}) - Shows how to parse, perform an XSLT 
  transformation, and unparse data from Java code. Slides that walk through this hello-world API 
  example are included at the end of the
  [Overview Presentation about DFDL](
  {{ site.data.links.slides.overviewDFDL}}).
  - A variation using
 [EXI - a dense binary XML representation]({{ site.data.links.reference.exi}}) for efficiency, 
  is also provided, called 
  [helloWorldExificient]({{ site.data.links.examples.helloWorldExificient}}). 
  Using EXI avoids the creation of large XML text representations of the 
  data, but otherwise does the same parse, XSLT Transform, and unparse of data. 
- [hexWords]({{ site.data.links.examples.hexWords}}) is an advanced example of a DFDL 
  schema for a data format that is not byte-oriented.
  The data records are a multiple of 4 bits in length, hence, a data record can end in the 
  middle of a byte. 
  Using Daffodil via its API, _hexWords_ shows one can parse such data from a data stream, letting 
  Daffodil keep track of the bit position internally. 
