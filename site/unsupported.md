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

Unsupported features of the [DFDL Specification](/docs/dfdl) as of Daffodil 3.0.0 are listed below:

#### DFDL Features

* COBOL: textNumberPattern: 'V' and 'P' Symbols {% jira 853 %}
* Intersect and except operators, dfdl:checkRangeInclusive, dfdl:checkRangeExclusive functions {% jira 2379 %}, {% jira 1515 %}
* defaulting of values for required elements - when unparsing {% jira 115 %}
* validation (when unparsing) {% jira 1582 %}
* byte-value entities (aka raw-byte entities){% jira 258 %}
* "type" component of DFDL infoset {% jira 182 %}, {% jira 1852 %}
* "unionMemberSchema" component of DFDL infoset {% jira 1633 %}
* "valid" component of DFDL infoset {% jira 813 %}
* extended ICU symbol 'I' in calendarPattern {% jira 1462 %}
* floating elements in sequences {% jira 643 %}
* "form" attribute (note that "elementFormDefault" is supported) {% jira 2416 %}
* unicodeByteOrderMark (Note this has been removed from the DFDL Specification v1.0)
* bi-directional text (Note this has been removed from the DFDL Specification v1.0,
  but may return in a future version of the DFDL spec.)
  
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
* calendarObserveDST {% jira 521 %}
* dfdl:escapeCharacterPolicy {% jira 2415 %}

#### Miscellaneous

* XPath query-style expressions {% jira 1118 %}

#### Minor Technical Issues/Non-Conformances

* Test for escapeEscapeCharacter in escape block data {% jira 2421 %}
* Check range of binaryDecimalVirtualPoint at runtime {% jira 2417 %}
* Character-level scanning insufficient due to raw byte entities {% jira 258 %}
* Choice branches that are zero-occurrence arrays are missing. {% jira 2420 %}
* Complex type cannot have hiddenGroupRef as its model group {% jira 2419 %}
