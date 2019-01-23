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

## Getting Started

### Using Daffodil

Daffodil is a library, requiring Java 8, used to convert between fixed format data and XML/JSON based on a DFDL schema. Some [examples](/examples) show the result of Daffodil parsing various inputs into XML. Multiple mechanisms that use the Daffodil library invoke its capabilities are described below.

[Command Line Interface](/cli)

   : Linux and Windows command line tool with capabilities include parsing, unaparsing, an interactive debugger, and more. Available via download in binary [releases](/releases).

[Java API](/docs/latest/javadoc) or [Scala API](/docs/latest/scaladoc)

   : Examples for using the Java API are available on the [OpenDFDL examples](https://github.com/OpenDFDL/examples.git) repository. Individual [releases](/releases) describe how to include a dependency to Daffodil via Maven and SBT.

[Apache NiFi Processors](https://opensource.ncsa.illinois.edu/bitbucket/projects/DFDL/repos/daffodil-nifi/browse)

   : Provides two [Apache NiFi](https://nifi.apache.org/) processors for parsing and unparsing NiFi FlowFiles.

[XML Calabash Extension](https://opensource.ncsa.illinois.edu/bitbucket/projects/DFDL/repos/daffodil-nifi/browse)

   : An extension to [XML Calabash](http://xmlcalabash.com) that declares XProc pipeline steps to parse and unparse input data.

### Existing DFDL Schemas

Many DFDL schemas are freely and publicly available at [DFDLSchemas](https://github.com/DFDLSchemas) on GitHub. This includes image formats, financial transaction formats, healthcare formats, and more. Some DFDL Schemas for Controlled Unclassified Information (CUI) data formats are available on [DI2E.net](https://confluence.di2e.net/pages/viewpage.action?pageId=196139975), which requires US Citizenship and DoD sponsorship.


### Creating DFDL Schemas

#### Layout

When creating a custom DFDL schema, it is beneficial to follow the directory/file layout described in [Standard DFDL Schema Project Layout](/dfdl-layout). This layout provides a consistent and familiar structure for DFDL schema development that existing tooling understands, provides for easy testing and schema packaging, and ensures no name conflicts on classpaths if multiple schemas are used together.

#### Editors

Any text editor can be used for authoring DFDL schemas. But because DFDL schemas are a subset of XML Schema, using an XML editor (especially an XML Schema aware editor) can provide intelligent assistance in authoring DFDL Schemas, including attribute and tag completion, validation, indentation, visualizations, etc. Below are resources for configuring various tools specifically for editing or authoring DFDL schemas.

 * [Eclipse IDE](/eclipse-configuration)

#### DFDL Extensions

Daffodil provides extensions to the DFDL specification to add extra enhancements and capabilities. These extensions are listed at [DFDL Extensions](/dfdl-extensions).

### Infoset

The Daffodil API and CLI support multiple ways to represent the DFDL infoset, including XML and JSON. See [Daffodil and the DFDL Infoset](/infoset) for a description of how the parts of the DFDL infoset are represented.
