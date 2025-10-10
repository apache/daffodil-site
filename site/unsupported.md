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

Unsupported features of the [DFDL Specification](/docs/dfdl) as of Daffodil 3.9.0 are listed below.

Note that this doesn't include just plain bugs in Daffodil, any of which could affect
support for a feature, but rather the below is a list of features
that there has been no intention to support as of this release. 

#### DFDL Features

* Intersect and except operators {% jira 2379 %}
* defaulting of values for required elements - when unparsing {% jira 115 %}
* validation (when unparsing) {% jira 1582 %}
* byte-value entities (aka raw-byte entities){% jira 258 %}
* nested prefix lengths {% jira 2030 %}
* XPath query-style expressions {% jira 1118 %}
* "type" component of DFDL infoset {% jira 182 %}
* "unionMemberSchema" component of DFDL infoset {% jira 1633 %}
* "valid" component of DFDL infoset {% jira 813 %}
* extended ICU symbol 'I' in calendarPattern {% jira 1462 %}
* floating elements in sequences {% jira 643 %}
* "form" attribute (note that "elementFormDefault" is supported) {% jira 2416 %}
* unicodeByteOrderMark (Note this has been removed from the DFDL Specification v1.0)
* bi-directional text (Note this has been removed from the DFDL Specification v1.0,
  but may return in a future version of the DFDL spec.)
* dfdl:contentLength() and dfdl:valueLength() with 'characters' units and variable-width encodings {% jira 1516 %}
* dfdl:outputValueCalc calling dfdl:valueLength() for string with dfdl:truncateSpecifiedLengthString 'yes' {% jira 1598 %}

#### XML Schema Features

* fixed {% jira 117 %}
* default {% jira 115 %} {% jira 1277 %}

#### Properties and Property Enumerations

* dfdl:lengthUnits 'characters' with dfdl:lengthKind 'prefixed' {% jira 2029 %}
* dfdl:binaryFloatRep="ibm390Hex" {% jira 244 %}
* dfdl:documentFinalTerminatorCanBeMissing="yes" {% jira 230 %}
* dfdl:encodingErrorPolicy="error" (Note: this is accepted, but behaves as "replace"){% jira 935 %}
* dfdl:floating="yes" {% jira 643 %}
* dfdl:lengthKind="endOfParent" {% jira 238 %}
* dfdl:nilKind="logicalValue" {% jira 201 %}
* dfdl:nilKind='literalValue' with dfdl:representation='binary' {% jira 638 %}
* dfdl:occursCountKind="stopValue", dfdl:occursStopValue {% jira 501 %}
* dfdl:utf16Width="variable" {% jira 551 %}
* dfdl:calendarObserveDST {% jira 521 %}
* dfdl:calendarCenturyStart {% jira 519 %}  
* dfdl:escapeCharacterPolicy {% jira 2415 %}
* dfdl:encoding using CCSIDs {% jira 2000 %}
* dfdl:useNilForDefault {% jira 1412 %}

The above listings are derived from
this [DFDL Language New Features JIRA Report
](https://s.apache.org/daffodil-unimplemented-dfdl-language-features).
