---
layout: page
title: Unsupported Features and Errata
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

Unsupported features and errata of the [DFDL Specification](/docs/dfdl) as of Daffodil 2.7.0 are listed below:

#### DFDL Features

* "type" component of DFDL infoset {% jira 182 %}, {% jira 1852 %}
* "unionMemberSchema" component of DFDL infoset {% jira 1633 %}
* "valid" component of DFDL infoset {% jira 813 %}
* bi-directional text (Note this is being removed from the DFDL 
Specification v1.0 per Erratum 5.43, 
but may return as an experimental feature, or in a 
future version of the DFDL spec.) 
* byte-value entities (aka raw-byte entities){% jira 258 %}
* defaulting of values for required elements - when unparsing {% jira 115 %}
* extended ICU symbol 'I' in calendarPattern {% jira 1462 %}
* floating elements in sequences {% jira 643 %}
* unicodeByteOrderMark (Note this is being removed from the DFDL Specification v1.0 per Erratum 5.50)
* validation (when unparsing) {% jira 1582 %}

#### XML Schema Features

* fixed {% jira 117 %}
* default {% jira 115 %}

#### Properties and Property Enumerations

* binaryFloatRep="ibm390Hex" {% jira 244 %}
* documentFinalTerminatorCanBeMissing="yes" {% jira 230 %}
* encodingErrorPolicy="error" (Note: this is accepted, but behaves as "replace"){% jira 935 %}
* floating="yes" {% jira 643 %}
* lengthKind="endOfParent" {% jira 238 %}, {% jira 567 %}
* nilKind="logicalValue" {% jira 201 %}
* occursCountKind="stopValue", occursStopValue {% jira 501 %}
* utf16Width="variable" {% jira 551 %}

#### Miscellaneous

* XPath query-style expressions {% jira 1118 %}

#### Errata (Minor Technical Fixes)

Items 5.1 through 5.63 of the [DFDL v1.0 Spec Errata](https://redmine.ogf.org/dmsf_files/13384?download=) are implemented, except for those listed below:

* Erratum 5.1 - Test for escapeEscapeCharacter in escape block data {% jira 2421 %}
* Erratum 5.3 - dfdl:escapeCharacterPolicy property {% jira 2415 %}
* Erratum 5.6 - "form" attribute (note that "elementFormDefault" is supported) {% jira 2416 %}
* Erratum 5.14 - Check range of binaryDecimalVirtualPoint at runtime {% jira 2417 %}
* Erratum 5.29 - Intersect and except operators, dfdl:checkRangeInclusive, dfdl:checkRangeExclusive functions 
{% jira 2379 %}, {% jira 1515 %}
* Erratum 5.30 - Character-level scanning insufficient due to raw byte entities {% jira 258 %}
* Erratum 5.39 - Choice branches that are zero-occurrence arrays are missing. {% jira 2420 %}
* Erratum 5.40 - complex type cannot have hiddenGroupRef as its model group {% jira 2419 %}
* Erratum 5.47 - Encoding/Decoding errors - dfdl:encodingErrorPolicy="error" not implemented.{% jira 935 %}
* Erratum 5.62 - documentFinalTerminatorCanBeMissing - property is not implemented.{% jira 230 %}