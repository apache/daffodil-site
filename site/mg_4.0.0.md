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

- Daffodil has merged daffodil-udf, daffodil-runtime1, daffodil-runtime1-unparser, daffodil-lib,
  daffodil-sapi, daffodil-japi and daffodil-io into daffodil-core.
- Daffodil has replaced the Validation Modes(`withValidationMode`)/`withValidator` with the `withValidation(validatorName[, validationConfigurationURI])` method. Built-in validator names are xerces, daffodil, schematron and off. 
- com.typesafe.config class has been replaced with java.util.Properties class for Validators configuration

## Dependencies

Since daffodil-udf and daffodil-sapi/japi have been merged into daffodil-core, the dependencies when
 using scala/java or udfs have changed to daffodil-core.

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
  <artifactId>daffodil-core_3</artifactId>
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
This remains generally unchanged for Java users as passing in strings (or nulls) is still supported. For Scala users, Options are no longer supported in the api and strings (or nulls) must be passed in instead.

<div>
<ul class="nav nav-tabs">
<li class="active"><a data-toggle="tab" href="#java_compile">Java</a></li>
<li><a data-toggle="tab" href="#scala_compile">Scala</a></li>
</ul>
<div class="tab-content">
<div id="java_compile" class="tab-pane active" markdown="1">

```java
File schemaFile = new File("/some/schema/file.xsd");
String rootName = "e1"; // can also be null to default to root element
String rootNamespace = "http://example.com"; // can also be null to default to root element namespace
org.apache.daffodil.api.ProcessorFactory pf = c.compileFile(schemaFile, rootName, rootNamespace);
```
</div>
<div id="scala_compile" class="tab-pane" markdown="1">

```scala
val schemaFile: File = new File("/some/schema/file.xsd")
val rootName: String = "e1" // can also be null to default to root element
val rootNamespace: String = "http://example.com"  // can also be null to default to root element namespace
val pf: org.apache.daffodil.api.ProcessorFactory = c.compileFile(schemaFile, rootName, rootNamespace) 
```
</div>
</div>
</div>

## Adding Validation to Compiler
Validation Modes (i.e `withValidationMode(ValidationMode.*)`) and the `withValidator(validatorObj)`  were removed in place of `withValidation(validator.name[, validationConfigurationURI])`.

<div>
<ul class="nav nav-tabs">
<li class="active"><a data-toggle="tab" href="#java_validate">Java</a></li>
<li><a data-toggle="tab" href="#scala_validate">Scala</a></li>
</ul>
<div class="tab-content">
<div id="java_validate" class="tab-pane active" markdown="1">

```java
org.apache.daffodil.api.ProcessorFactory pf = c.compileFile(schemaFile, rootName, rootNamespace);
URI mainValidationSchemaUri = URI.create("file:///path/to/other/schema.xsd");
org.apache.daffodil.api.DataProcessor dp = pf.onPath("/").withValidation("xerces", mainValidationSchemaUri); 
```
</div>
<div id="scala_validate" class="tab-pane" markdown="1">

```scala
val pf: org.apache.daffodil.api.ProcessorFactory = c.compileFile(schemaFile, rootName, rootNamespace)
val mainValidationSchemaUri = URI.create("file:///path/to/other/schema.xsd";
val dp: org.apache.daffodil.api.DataProcessor = pf.onPath("/").withValidation("xerces", mainValidationSchemaUri) 
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
  org.apache.daffodil.api.infoset.JDOMInfosetOutputter outputter = Infoset.getJDOMInfosetOutputter();
  org.apache.daffodil.api.ParseResult res = dp.parse(dis, outputter);
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
org.apache.daffodil.api.infoset.InfosetInputter inputter = Infoset.getJDOMInfosetInputter(outputter.getResult());
org.apache.daffodil.api.UnparseResult res2 = dp.unparse(inputter, wbc);
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

## Using Custom Plugin Layers
Custom Plug-in layers must extend the `org.apache.daffodil.api.layers.Layer` class, and be 
referenced in a `META-INF/services` file with the same class reference as the name. This 
path has changed in Daffodil 4.0.0.

<div>
<ul class="nav nav-tabs">
<li class="active"><a data-toggle="tab" href="#java_layers">Java</a></li>
<li><a data-toggle="tab" href="#scala_layers">Scala</a></li>
</ul>
<div class="tab-content">
<div id="java_layers" class="tab-pane active" markdown="1">

```java
// example layer class
import org.apache.daffodil.api.layers.Layer;

public final class GZipLayer extends Layer {
  // implementation details
}

// in META-INF/services/org.apache.daffodil.api.layers.Layer
org.apache.daffodil.layers.runtime1.GZipLayer
```
</div>
<div id="scala_layers" class="tab-pane" markdown="1">

```scala
// example layer class
import org.apache.daffodil.api.layers.Layer

abstract class ByteSwap(name: String, wordsize: Int)
  extends Layer(name, "urn:org.apache.daffodil.layers.byteSwap") {...}

// in META-INF/services/org.apache.daffodil.api.layers.Layer
org.apache.daffodil.layers.runtime1.GZipLayer
```
</div>
</div>
</div>

## Using User Defined Functions
UDF Providers must extend the `org.apache.daffodil.api.udf.UserDefinedFunctionProvider` class, and be
referenced in a `META-INF/services` file with the same class reference as the name. This
path has changed in Daffodil 4.0.0.

<div>
<ul class="nav nav-tabs">
<li class="active"><a data-toggle="tab" href="#java_udfs">Java</a></li>
<li><a data-toggle="tab" href="#scala_udfs">Scala</a></li>
</ul>
<div class="tab-content">
<div id="java_udfs" class="tab-pane active" markdown="1">

```java
// example layer class
import org.apache.daffodil.api.udf.UserDefinedFunctionProvider;

public class StringFunctionsProvider extends UserDefinedFunctionProvider {
  // implementation details
}

// in META-INF/services/org.apache.daffodil.api.udf.UserDefinedFunctionProvider
org.jgoodudfs.example.StringFunctions.StringFunctionsProvider
```
</div>
<div id="scala_udfs" class="tab-pane" markdown="1">

```scala
// example layer class
import org.apache.daffodil.api.udf.UserDefinedFunctionProvider

class StringFunctionsProvider extends UserDefinedFunctionProvider {...}

// in META-INF/services/org.apache.daffodil.api.udf.UserDefinedFunctionProvider
org.sgoodudfs.example.StringFunctions.StringFunctionsProvider
```
</div>
</div>
</div>