---
layout: page
title: Home
tagline: Apache Project !
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


The [Data Format Description Language (DFDL)](https://www.ogf.org/ogf/doku.php/standards/dfdl/dfdl)
is a specification, developed by the [Open Grid Forum](https://www.ogf.org/), and also
published as
[ISO/IEC 23415:2004](
https://www.iso.org/standard/87444.html).
DFDL is capable of describing many data formats, including both textual and binary,
scientific and numeric, legacy and modern, commercial record-oriented, and many
industry and military standards. It defines a language that is a subset of W3C
XML schema to describe the logical format of the data, and annotations within
the schema to describe the physical representation.

Daffodil is an open source implementation of the DFDL specification that uses
these DFDL schemas to parse fixed format data into an infoset, which is most
commonly represented as either XML or JSON. This allows the use of
well-established XML or JSON technologies and libraries to consume, inspect,
and manipulate fixed format data in existing solutions. Daffodil is also
capable of the reverse by serializing or "unparsing" an XML or JSON infoset
back to the original data format.
