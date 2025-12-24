---
layout: page
title: Getting Started
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

# Using Daffodil

Daffodil is a Java-callable library. 
As of version 4.0.0 it requires Java 17[^java8]. 
It is used to convert between fixed format data and XML or JSON based on a DFDL 
schema. 
Some [examples](/examples) show the result of Daffodil parsing various inputs into XML. Multiple mechanisms that use the Daffodil library invoke its capabilities are described below.

There are also [DFDL Training](/dfdl-training) materials available.

[Command Line Interface](/cli)

   : Linux and Windows command line tool with capabilities include parsing, unaparsing, an interactive debugger, and more. Available via download in binary [releases](/libraryAndCLI).

[API](/docs/latest/javadoc)

   : Examples for using the API in both Java and Scala are available on the [OpenDFDL examples](https://github.com/OpenDFDL/examples.git) repository. Individual [releases](/libraryAndCLI) describe how to include a dependency to Daffodil via Maven and SBT.

[Apache NiFi Processors](https://github.com/TresysTechnology/nifi-daffodil)

   : Provides two [Apache NiFi](https://nifi.apache.org/) processors for parsing and unparsing NiFi FlowFiles.

[XML Calabash Extension](https://opensource.ncsa.illinois.edu/bitbucket/projects/DFDL/repos/daffodil-calabash-extension/browse)

   : An extension to [XML Calabash](http://xmlcalabash.com) that declares XProc pipeline steps to parse and unparse input data.

[Smooks DFDL Cartridge](https://www.smooks.org/documentation/#dfdl)

   : A [Smooks](https://www.smooks.org) module that has a reader for parsing the source into an event stream and a visitor for unparsing the event stream. This module forms the foundation of the [EDI and EDIFACT cartridges](https://github.com/smooks/smooks-edi-cartridge).

# Existing DFDL Schemas

Many DFDL schemas are freely and publicly available at [DFDLSchemas](https://github.com/DFDLSchemas) on GitHub. This includes image formats, financial transaction formats, healthcare formats, and more.
 
DFDL Schemas for US and allied government data formats are available 
to authorized persons at
[US DoD Intelink](
https://intelshare.intelink.gov/sites/ncdsmo/Shared%20Documents/Forms/AllItems.aspx?RootFolder=%2Fsites%2Fncdsmo%2FShared%20Documents%2FCDS%20Development%2FFilters%20and%20Other%20Application%20Source%20Code%2FDFDL%2FDFDL%20Schemas
). These formats include: Link16 (aka MIL-STD-6016, STANAG 5516) with JREAP (MIL-STD-3011) and 
NACT headers, VMF (aka MIL-STD-6017),GMTIF (STANAG 4607 AEDP-7), iCalendar, IMF, USMTF (aka 
MIL-STD-6040), and OilStock



# Creating DFDL Schemas

## Layout

When creating a custom DFDL schema, it is beneficial to follow the directory/file layout described in [Standard DFDL Schema Project Layout](/dfdl-layout). This layout provides a consistent and familiar structure for DFDL schema development that existing tooling understands, provides for easy testing and schema packaging, and ensures no name conflicts on classpaths if multiple schemas are used together.

## Editors

Any text editor can be used for authoring DFDL schemas. But because DFDL schemas are a subset of XML Schema, using an XML editor (especially an XML Schema aware editor) can provide intelligent assistance in authoring DFDL Schemas, including attribute and tag completion, validation, indentation, visualizations, etc. Below are resources for configuring various tools specifically for editing or authoring DFDL schemas.

 * [Eclipse IDE](/eclipse-configuration)

## DFDL Extensions

Daffodil provides extensions to the DFDL specification to add extra enhancements and capabilities. These extensions are listed at [DFDL Extensions](/dfdl-extensions).

# Infoset

The Daffodil API and CLI support multiple ways to represent the DFDL infoset, including XML and JSON. See [Daffodil and the DFDL Infoset](/infoset) for a description of how the parts of the DFDL infoset are represented.

----

[^java8]: Earlier Daffodil versions work with Java 8+.
