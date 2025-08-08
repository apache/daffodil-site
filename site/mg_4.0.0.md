---
layout: page
title: Migration Guide
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

# 3.11.0 to 4.0.0

The most important changes to be aware of in this release are:

- Daffodil has merged daffodil-runtime1, daffodil-runtime1-unparser, daffodil-lib, daffodil-sapi,
daffodil-japi and daffodil-io into daffodil-core.
- Daffodil has replaced Validation Modes with a factory method from the ValidatorFactory class called `make`.
- com.typesafe.config class has been replaced with java.util.Properties class for Validators configuration

## Dependencies

Since daffodil-sapi/japi have been merged into daffodil-core, the dependencies when using scala/java
have changed to daffodil-core.

<div>
<ul class="nav nav-tabs">
<li class="active"><a data-toggle="tab" href="#java_dep">Java</a></li>
<li><a data-toggle="tab" href="#scala_dep">Scala</a></li>
</ul>
<div class="tab-content">
<div id="java_dep" class="tab-pane active" markdown="1">

```xml
<dependency>
  <groupId>org.apache.daffodil</groupId>
  <artifactId>daffodil-core_3.3.6</artifactId>
  <version>4.0.0</version>
</dependency>
```
</div>
<div id="scala_dep" class="tab-pane" markdown="1">

```scala
libraryDependencies += "org.apache.daffodil" %% "daffodil-core" % "4.0.0"
```
</div>
</div>
</div>

## Compiling Schemas
This remains generally unchanged for Java users as passing in strings is still supported, one may also pass in 
Java `Optional`, where Scala `Option`s used to be used. For Scala users, use of `scala.jdk.OptionConverters` may
be used, as well as passing in string arguments.

<div>
<ul class="nav nav-tabs">
<li class="active"><a data-toggle="tab" href="#java_compile">Java</a></li>
<li><a data-toggle="tab" href="#scala_compile">Scala</a></li>
</ul>
<div class="tab-content">
<div id="java_compile" class="tab-pane active" markdown="1">

```java
File schemaFile = new File("/some/schema/file.xsd");
Optional<String> optRootName = Optional.of("e1");
Optional<String> optRootNamespace = Optional.of("http://example.com");
org.apache.daffodil.api.ProcessorFactory pf = c.compileFile(schemaFile, optRootName, optRootNamespace);
```
</div>
<div id="scala_compile" class="tab-pane" markdown="1">

```scala
import scala.jdk.OptionConverters._

val schemaFile: File = new File("/some/schema/file.xsd")
val optRootName: Option[String] = Some("e1").toJava
val optRootNamespace: Option[String] = Some("http://example.com").toJava
val pf: org.apache.daffodil.api.ProcessorFactory = c.compileFile(schemaFile, optRootName, optRootNamespace) 
```
</div>
</div>
</div>

## Adding Validation to Compiler
Validation Modes (i.e `withValidationMode(ValidationMode.*)`) were removed and now validators must be used directly 
(i.e `withValidator(Validators.get(...).make(...))`).

<div>
<ul class="nav nav-tabs">
<li class="active"><a data-toggle="tab" href="#java_validate">Java</a></li>
<li><a data-toggle="tab" href="#scala_validate">Scala</a></li>
</ul>
<div class="tab-content">
<div id="java_validate" class="tab-pane active" markdown="1">

```java
import java.util.Properties;

org.apache.daffodil.api.ProcessorFactory pf = c.compileFile(schemaFile, rootName, rootNamespace);
String mainValidationSchema = "file:/path/to/other/schema.xsd";
Properties config = ValidatorFactory.makeConfig(mainValidationSchema);
org.apache.daffodil.api.DataProcessor dp = pf.onPath("/").withValidator(Validators.get("xerces").make(config)); 
```
</div>
<div id="scala_validate" class="tab-pane" markdown="1">

```scala
val pf: org.apache.daffodil.api.ProcessorFactory = c.compileFile(schemaFile, optRootName, optRootNamespace)
val mainValidationSchema = "file:/path/to/other/schema.xsd";
val config = ValidatorFactory.makeConfig(mainValidationSchema)
val dp: org.apache.daffodil.api.DataProcessor = pf.onPath("/").withValidator(Validators.get("xerces").make(config)) 
```
</div>
</div>
</div>

## Parsing Data
Factory methods to get `InputSourceDataInputStream` and `InfosetOutputter` objects have been added via 
`Infoset.getInputSourceDataInputStream` and `Infoset.get*InfosetOutputter` 

<div>
<ul class="nav nav-tabs">
<li class="active"><a data-toggle="tab" href="#java_parse">Java</a></li>
<li><a data-toggle="tab" href="#scala_parse">Scala</a></li>
</ul>
<div class="tab-content">
<div id="java_parse" class="tab-pane active" markdown="1">

```java
    java.io.File file = getResource("/test/api/myData.dat");
    java.io.FileInputStream fis = new java.io.FileInputStream(file);
    try (InputSourceDataInputStream dis = Infoset.getInputSourceDataInputStream(fis)) {
    JDOMInfosetOutputter outputter = Infoset.getJDOMInfosetOutputter();
    ParseResult res = dp.parse(dis, outputter);
    } 
```
</div>
<div id="scala_parse" class="tab-pane" markdown="1">

```scala
    val file = getResource("/test/api/myData.dat")
    val fis = new java.io.FileInputStream(file)
    Using.resource(Infoset.getInputSourceDataInputStream(fis)) { input =>
      val outputter = Infoset.getScalaXMLInfosetOutputter()
      val res = dp.parse(input, outputter)
    }
```
</div>
</div>
</div>

## Unparsing Infoset
Factory methods to get an `InfosetInputter` object has been added via `Infoset.get*InfosetInputter`

<div>
<ul class="nav nav-tabs">
<li class="active"><a data-toggle="tab" href="#java_unparse">Java</a></li>
<li><a data-toggle="tab" href="#scala_unparse">Scala</a></li>
</ul>
<div class="tab-content">
<div id="java_unparse" class="tab-pane active" markdown="1">

```java
    java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
    java.nio.channels.WritableByteChannel wbc = java.nio.channels.Channels.newChannel(bos);
    InfosetInputter inputter = Infoset.getJDOMInfosetInputter(outputter.getResult());
    UnparseResult res2 = dp.unparse(inputter, wbc);
```
</div>
<div id="scala_unparse" class="tab-pane" markdown="1">

```scala
    val bos = new java.io.ByteArrayOutputStream()
    val wbc = java.nio.channels.Channels.newChannel(bos)
    val inputter = Infoset.getScalaXMLInfosetInputter(outputter.getResult())
    val res2 = dp.unparse(inputter, wbc)
```
</div>
</div>
</div>
