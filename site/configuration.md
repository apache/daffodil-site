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

Daffodil has the capability to read in parameters via an external XML file, defined by the [dafext.xsd](https://github.com/apache/daffodil/blob/main/daffodil-propgen/src/main/resources/org/apache/daffodil/xsd/dafext.xsd) schema. Below are the parameters that can be defined.

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

See [tunables](/tunables) for a description of the available tunable parameters.