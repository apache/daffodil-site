---
layout: page
title: Configuration
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

Daffodil has the capability to read in parameters via an external XML file, defined by the [dafext.xsd](https://github.com/apache/incubator-daffodil/blob/master/daffodil-propgen/src/main/resources/org/apache/daffodil/xsd/dafext.xsd) schema. Below are the parameters that can be defined.

### External Variables

External variables can be defined using the ``externalVariablesBindings`` tag. For example, the following configuration file defines two variables, ``var1`` and ``var2``, in the ``http://example.com`` namespace.

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<dfdlConfig xmlns="http://www.w3.org/2001/XMLSchema" xmlns:ex="http://example.com">
  <externalVariableBindings>
    <bind name="ex:var1">-9</bind>
    <bind name="ex:var2">Foo</bind>
  </externalVariableBindings>
</dfdlConfig>
```

The following defined in a DFDL schema would allow the external variables to be set or overridden:

``` xml
<dfdl:defineVariable name="var1" external="true" type="xsd:int">1</dfdl:defineVariable>
<dfdl:defineVariable name="var2" external="true" type="xsd:string">Bar</dfdl:defineVariable>
```

### Tunable Parameters

Tunable parameters can be modified to change Daffodil schema compilation and data parsing properties. For example, the following sets the ``maxOccursBounds`` tunable to 1024:

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<dfdlConfig xmlns="http://www.w3.org/2001/XMLSchema" xmlns:ex="http://example.com">
  <tunables>
    <maxOccursBounds>1024</maxOccursBounds>
  </tunables>
</dfdlConfig>
```

Below is a description of the available tunable parameters:

``generatedNamespacePrefixStem``

   : If elementFormDefault is qualified, but no prefix is associated with the targetNamespace, a prefix will be created using this value, with numbers appended if necessary to ensure uniqueness. Defaults to "tns".

``inputFileMemoryMapLowThreshold``

   : In certain I/O optimized situations (text-only, encodingErrorPolicy='replace', fixed-width encoding) input files larger than this will be mmapped. Input files smaller than this will be simply read using ordinary I/O (because for small files that is just faster). This exists because mmap is more expensive than ordinary I/O for small files. Defaults to 225.

``maxBinaryDecimalVirtualPoint``

   : An upper limit on the value of the dfdl:binaryDecimalVirtualPoint property. Defaults to 200.

``maxFieldContentLengthInBytes``

   : A maximum limit for various daffodil I/O properties, including the maximim size of a simple element and maximum regular expression characters to match. Defaults to 220.

``maxLengthForVariableLengthDelimiterDisplay``

   : When unexpected text is found where a delimiter is expected, this is the maximum number of bytes (characters) to display when the expected delimiter is a variable length delimiter. Defaults to 10.

``maxOccursBounds``

   : A maximum limit for the number of repeats of array elements. Defaults to 1024.

``maxSkipLengthInBytes``

   : A maximum limit for the number of bytes that can be skipped in a skip region. Defaults to 1024.

``minBinaryDecimalVirtualPoint``

   : A lower limit on the value of the dfdl:binaryDecimalVirtualPoint property. Defaults to -200.

``parseUnparsePolicy``

   : Whether to compile a schema to support parsing ("parseOnly"), unparsing ("unparseOnly"), both parsing and unparsing ("both"), or to use the daf:parseUnparsePolicy property from the root node ("schema"). Defaults to "both".

``requireBitOrderProperty``

   : If true, require that the bitOrder property is specified. If false, use a default value for bitOrder if not defined in a schema. Defaults to false.

``requireEncodingErrorPolicyProperty``

   : If true, require that the encodingErrorPolicy property is specified. If false, use a default value if not defined in a schema. Defaults to false.

``unqualifiedPathStepPolicy``

   : Specified how unqualified path steps are resolved. Defaults to ``noNamespace``. Value values are:
    
     ``noNamespace``

        : Unqualified path steps remain unqualified and will only match elements in NoNamespace. A prefix must be provided to match namespaced elements.

     ``defaultNamespace``

        : Unqualified path steps will always use the default namespace. If a default namespace is defined, it is not possible to match a NoNamespace element with this policy. Because of this, this may not work well with elementFormDefault="unqualified".

     ``preferDefaultNamespace``

        : Attempt to use the default namespace to resolve an unqualified path step. If that fails to match an element, then try to resolve using NoNamespace.
