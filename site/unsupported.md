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

Unsupported features and errata of the [DFDL Specification](/docs/dfdl) as of Daffodil 2.3.0 are listed below:

#### DFDL Features

* "type" component of DFDL infoset
* "unionMemberSchema" component of DFDL infoset
* "valid" component of DFDL infoset
* bi-directional text
* byte-value entities (aka raw-byte entities)
* defaulting of values for required elements
* extended ICU symbols 'u' and 'I' in calendarPattern
* floating elements in sequences
* unicodeByteOrderMark
* unordered sequences
* validation (unparsing)

#### XML Schema Features

* fixed
* default

#### Properties and Property Enumerations

* binaryFloatRep="ibm390Hex"
* choiceLength
* choiceLengthKind="explicit"
* documentFinalTerminatorCanBeMissing="yes"
* encodingErrorPolicy="error"
* failureType="recoverableError"
* floating="yes"
* lengthKind="endOfParent"
* nilKind="literalCharacter"
* nilKind="logicalValue"
* occursCountKind="stopValue"
* occursStopValue
* sequenceKind='unordered'
* textBidi="yes"
* textBidiNumeralShapes
* textBidiOrientation
* textBidiSymmetric
* textBidiTextOrdering
* textBidiTextShaped
* textStandardBase (behaves as 10)
* useNilForDefault
* utf16Width="variable"

#### Annotations

* newVariableInstance

#### Miscellaneous

* XPath query-style expressions

#### Errata (Minor Technical Fixes)

Items 5.1 through 5.38 of the [DFDL v1.0 Spec Errata](https://redmine.ogf.org/dmsf_files/13384?download=) are implemented, except for those listed below:

* Erratum 5.1 - Test for escapeEscapeCharacter in escape block data
* Erratum 5.3 - dfdl:escapeCharacterPolicy property
* Erratum 5.6 - "form" attribute ("elementFormDefault" is supported)
* Erratum 5.14 - Check range of binaryDecimalVirtualPoint at runtime
* Erratum 5.29 - Intersect and except operators, dfdl:checkRangeInclusive, dfdl:checkRangeExclusive functions
* Erratum 5.30 - Character-level scanning insufficient due to raw byte entities
