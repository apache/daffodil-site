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

<style type='text/css'>
th {
	background-color: #f4f4f4;
}

td, th {
	padding: 5px 10px;
	border-top: solid 1px #cccccc;
	width: 20px;
}

table {
    display:table;
    width:100%;
}

th:last-child {
    width:100%;
}
</style>

## Unsupported Features & Errata

The following table lists unsupported features and errata of the DFDL Specification since Daffodil 1.0.0 and if/when those features were implemented. Any features/errata not listed in this table were implemented prior to 1.0.0.

{% ok %} = supported &emsp; {% err %} = unsupported &emsp; {% warn %} = partially supported

|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |Unparsing
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{% err  %}|{% warn %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|unparser
|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|outputNewLine
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|fillByte
|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textPadKind
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textOutputMinLength
|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|generateEscapeBlock
|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|extraEscapedCharacters
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|truncateSpecifiedLengthString
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|outputValueCalc
                                                         
                                                         
|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |Types
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|decimal
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|integer
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|nonNegativeInteger
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|hexBinary
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|boolean
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|date (binary)
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|time (binary)
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|dateTime (binary)
                                                         
                                                         
|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |XML Schema Features
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|fixed
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|default
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|elementFormDefault
                                                         
                                                         
|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |DFDL Features
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|defaulting of values for required elements
|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|'packed' binary number representations (packed, bcd, etc.)
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|'zoned' binary number representations
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|advanced text number format properties
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|bi-directional text
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|unordered sequences
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|floating elements in sequences
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|external variables
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|byte-value entities (aka raw-byte entities)
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|validation (parsing)
|{%  ok  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|validation (unparsing)
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|alignment
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|'type' component of DFDL infoset
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|'unionMemberSchema' component of DFDL infoset
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|'valid' component of DFDL infoset
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|unicodeByteOrderMark
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|all runtime-computed format properties
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|runtime-computation for escapeCharacter, escapeEscapeCharacter, byteOrder
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|IANA standard encodings other than utf-8, utf-16BE, utf-16LE, utf-32BE, utf-32LE, and ASCII
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|optional qualified names in expression language
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|check for non-portable regular expressions
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|delimited binary
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|extended ICU symbols 'u' and 'I' in calendarPattern
                                                         
                                                         
|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |Daffodil Specific
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|save/reload parser
                                                         
                                                         
|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |Properties and Property Enumerations
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|ignoreCase="yes"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|utf16Width="variable"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|textNumberRep="zoned"
|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|binaryNumberRep="packed"
|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|binaryNumberRep="bcd"
|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|binaryNumberRep="ibm4690Packed"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|binaryFloatRep="ibm390Hex"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|nilKind="logicalValue"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|nilKind="literalCharacter"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|lengthKind="prefixed"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|lengthKind="endOfParent"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|occursCountKind="stopValue"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|documentFinalTerminatorCanBeMissing="yes"
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textNumberPattern
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textNumberCheckPolicy
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textNumberRounding
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textNumberRoundingMode
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textNumberRoundingIncrement
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textStandardGroupingSeparator
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textStandardDecimalSeparator
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textStandardExponentRep
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textStandardInfinityRep
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textStandardNaNRep
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textStandardZeroRep
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|textStandardBase (behaves as 10)
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|textZonedSignStyle
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|decimalSigned
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textBooleanTrueRep
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textBooleanFalseRep
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textBooleanPadCharacter
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|textBooleanJustification
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|binaryBooleanTrueRep
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|binaryBooleanFalseRep
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|textBidi (behaves as "no")
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|textBidiTextOrdering
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|textBidiOrientation
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|textBidiSymmetric
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|textBidiTextShaped
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|textBidiNumeralShapes
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|alignment
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|alignmentUnits
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|leadingSkip
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|trailingSkip
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|prefixIncludesPrefixLength
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|prefixLengthType
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|binaryDecimalVirtualPoint
|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|binaryNumberCheckPolicy
|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|binaryPackedSignCodes
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|binaryCalendarRep
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|binaryCalendarEpoch
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|useNilForDefault
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|sequenceKind='unordered'
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|floating="yes"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|choiceLengthKind="explicit"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|choiceLength
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|occursStopValue
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|seperatorSuppressionPolicy (overrides separatorPolicy)
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|separatorPolicy
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|bitOrder
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|encodingErrorPolicy="replace"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|encodingErrorPolicy="error"
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|failureType="recoverableError"
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|choiceDispatchKey
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|choiceBranchKey
                                                         
|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |Functions
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|contentLength
|{% err  %}|{% err  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|valueLength
                                                         
|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |Annotations
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|newVariableInstance
                                                         
|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |Miscellaneous
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|File sizes greater than 4GB
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Java version <= 6
|{%  ok  %}|{%  ok  %}|{% err  %}|{% err  %}|{% err  %}|Java version 7
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|Java version 8
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Java version 9
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Java version 10
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|Scala version 2.11
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{%  ok  %}|Scala version 2.12
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Scala version 2.13
|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|{%  ok  %}|Strict DFDL expressions adherence (i.e. disallow features of XPath not available in DFDL expressions)
|{% warn %}|{% warn %}|{% warn %}|{% warn %}|{% warn %}|XPath 2.0 Support (query-style expressions not supported)
                                                         
|  1.0.0   |  1.1.0   |  2.0.0   |  2.1.0   |  2.2.0   |[DFDL v1.0 Spec Errata](https://redmine.ogf.org/dmsf_files/13384?download=) (Minor Technical Fixes)
|:--------:|:--------:|:--------:|:--------:|:--------:|----------
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Erratum 5.1 - Test for escapeEscapeCharacter in escape block data
|{% err  %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.2 - Evaluation order of expressions
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Erratum 5.3 - dfdl:escapeCharacterPolicy property
|{% err  %}|{% err  %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.4
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.5
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Erratum 5.6 - ''form'' attribute (''elementFormDefault'' is supported)
|{% err  %}|{% err  %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.7
|{% err  %}|{% err  %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.8
|{% err  %}|{% err  %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.9 - Behavior when maxOccurs is zero or dfdl:occursCount is zero.
|{% err  %}|{% err  %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.10 - Fixed length elements with non-zero length are never _empty_
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.11 - QName resolution in expression path steps
|{% err  %}|{% err  %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.12 - Minimum bits for xs:decimal is 8.
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.13
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Erratum 5.14 - Check range of binaryDecimalVirtualPoint at runtime
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% ok   %}|Erratum 5.15 - Specify dfdl:lengthUnits 'bits' for packed calendars
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Erratum 5.16 - Disallow binarySeconds and binaryMillseconds as representations for date and time for dfdl:lengthKind 'prefixed' or 'implicit'.
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.17 
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.18 - Compute dfdl:length expression when unparsing
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.19 - Unparser respects maxOccurs for dfdl:occursCountKinds where applicable
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.20 - No-forward-reference expression constraints missing
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.21 - Case sensitive for dfdl:choiceDispatchKey/dfdl:choiceBranchKey comparisons
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.22 - Escape block end must be found before end-of-data
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.23 - Corrections for property descriptions for nillable complex-type elements
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.24 
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.25 - dfdl:inputValueCalc allowed on root of a choice branch
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.26
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.27 - Bit order clarification
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.28 - Empty string value not allowed for dfdl:textStandardNaNRep and dfdl:textStandardInfinityRep
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Erratum 5.29 - intersect and except operators, dfdl:checkRangeInclusive, dfdl:checkRangeExclusive functions
|{% err  %}|{% err  %}|{% err  %}|{% err  %}|{% err  %}|Erratum 5.30 - Character-level scanning insufficient due to raw byte entities
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.31 
|{% err  %}|{% err  %}|{% err  %}|{% ok   %}|{% ok   %}|Erratum 5.32 - ES and WSP* alone - clarification
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.33 - dfdl:textBooleanTrueRep cannot be empty string
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.34 - dfdl:textBooleanJustification property missing from list
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.35
|{% err  %}|{% err  %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.36 - dfdl:choiceBranchKey can be a list of string literals
|{% err  %}|{% err  %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.37 - no forward reference from dfdl:choiceDispatchKey expression
|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|{% ok   %}|Erratum 5.38 - \[array\] member of Infoset Element Information Item
