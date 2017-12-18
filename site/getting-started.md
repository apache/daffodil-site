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

Daffodil has two methods in which it can be invoked:

* Via the [Command Line Interface](/cli). Capabilities include parsing, unaparsing, an interactive debugger, and more.
* Programmatically via the [Java API](/docs/latest/javadoc) or [Scala API](/docs/latest/scaladoc). Examples for using the Java API are available on the [OpenDFDL examples](https://github.com/OpenDFDL/examples.git) repository (not Apache affiliated). The Daffodil [releases](/releases) describe how to include a dependency to Daffodil via maven and SBT.

Both methods require Java 8.

### Existing DFDL Schemas

Multiple DFDL schemas exist on the [DFDLSchemas github](https://github.com/DFDLSchemas) (not Apache affiliated) that are available to download and try out. This includes multiple image formats, financial transaction formats, and more.

### Creating DFDL Schemas

When creating a custom DFDL schema, it is beneficial to follow the directory/file layout described in [Standard DFDL Schema Project Layout](/dfdl-layout). This layout provides a consistent and familiar structure for DFDL schema development that existing tooling understands, provides for easy testing and schema packaging, and ensures no name conflicts on classpaths if multiple schemas are used together.

Any text editor can be used for authoring DFDL schemas. But because DFDL schemas are a subset of XML Schema, using an XML editor (especially an XML Schema aware editor) can provide intelligent assistance in authoring DFDL Schemas, including attribute and tag completion, validation, indentation, visualizations, etc. Below are resources for configuring various tools specifically for editing or authoring DFDL schemas.

 * [Eclipse IDE](/eclipse-configuration)

