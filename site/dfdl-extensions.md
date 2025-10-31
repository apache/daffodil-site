---
layout: page
title: Daffodil Extensions of DFDL 
group: nav-right
pdf: true
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


<div class="only-jekyll" markdown="1">

### Table of Contents
{:.no_toc}

1. use ordered table of contents 
{:toc}
</div><!-- note the above line {:toc} cannot have whitespace at the start --> 

# Introduction

Daffodil provides extensions to the DFDL specification. 
These functions and properties are in the namespace defined by the URI 
``http://www.ogf.org/dfdl/dfdl-1.0/extensions`` which is normally bound to the ``dfdlx`` prefix 
like so: 


``` xml
<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:dfdl="http://www.ogf.org/dfdl/dfdl-1.0/"
        xmlns:dfdlx="http://www.ogf.org/dfdl/dfdl-1.0/extensions"
>
```

The DFDL language extensions described below have Long Term Support (LTS) in Daffodil 
going forward, and are proposed for inclusion in a future revision of the DFDL 
standard. 
DFDL schema authors can depend on the features and behaviors defined here without fear 
that these extensions will be withdrawn in the future. 

# Expression Functions

## `daf:error(messageArg)`

A function that can be used in DFDL expressions. This functions does not return a value or accept any arguments. When called, it causes a Parse Error or Unparse Error.

     *This function is deprecated as of Daffodil 2.0.0. 
      Use the ``fn:error(...)`` function instead.*

## `dfdlx:trace($value, $label)`

A function that can be used in DFDL expressions, similar to the ``fn:trace()`` function. This logs the string ``$label`` followed by ``$value`` converted to a string and returns ``$value``. The second argument must be of type ``xs:string``.

## `dfdlx:lookAhead(offset, bitSize)`

Read `bitSize` bits, where the first bit is located at an ``offset`` (in bits)
   from the current location. The result is a ``xs:nonNegativeInteger``. Restrictions:
   
- offset >=0
- bitSize >= 1
- distance + bitSize <= Implementation defined limit no less than 512 bits
- Cannot be called during unparse
- Parse Error if the offset results in attempting to look ahead past EOF
- Undefined behavior if the offset results in attempting to look past the current data limit of 
a ``dfdl:lengthKind="explicit"`` surrounding element. 
- The ``dfdl:bitOrder`` and ``dfdl:byteOrder`` are determined by the current schema component
and data location. 
- DFDL property changes between the current location and the location containing
the data being read will not be used.
  
### Examples of `dfdlx:lookAhead`
   
The following two elements both populate element `a` with the value of the next 3 bits as an 
unsignedInt. 
They are not completely equivalent because the first will consume 3 bits of the 
input stream where the second will not advance the input stream.

```xml
<xs:element name="a" type="xs:unsignedInt" dfdl:length="3" dfdl:lengthUnits="bits" />

<xs:element name="a" type="xs:unsignedInt" dfdl:inputValueCalc="{ dfdlx:lookAhead(0,3) }" />
```
The following example demonstrates using lookAhead to branch based on a field in the future. 
In this case the choice of elements `a` vs. `b` depends on the value of the `tag` field which is 
found after fields `a` and `b`:
```
<xs:choice dfdl:choiceDispatchKey="{ dfdlx:lookAhead(16,8) }">
  <xs:element name="a" type="xs:int" dfdl:length="16" dfdl:choiceBranchKey="1"/>
  <xs:element name="b" type="xs:int" dfdl:length="16" dfdl:choiceBranchKey="2"/>
</xs:choice>
<xs:element name="tag" type="xs:int" dfdl:length="8" />
```

## Bitwise Functions: `bitAnd`, `bitOr`, `bitXor`, `bitNot`, `leftShift`, `rightShift`

These functions are defined on types `long`, `int`, `short`, `byte`, `unsignedLong`, 
`unsignedInt`, `unsignedShort`, and `unsignedByte`

### `dfdlx:bitAnd(arg1, arg2)`

This computes the bitwise AND of two integers. 

- Both arguments must be signed, or both must be unsigned.
- If the two arguments are not the same type the smaller one is converted into the type of the 
larger one. 
- If the smaller argument is signed, this conversion does sign-extension.
- The result type is the that of the largest argument. 

### `dfdlx:bitOr(arg1, arg2)`

This computes the bitwise OR of two integers.

- Both arguments must be signed, or both must be unsigned.
- If the two arguments are not the same type the smaller one is converted into the type of the
larger one.
- If the smaller argument is signed, this conversion does sign-extension.
- The result type is the that of the largest argument.

### `dfdlx:bitXor(arg1, arg2)`

This computes the bitwise Exclusive OR of two integers.

- Both arguments must be signed, or both must be unsigned.
- If the two arguments are not the same type the smaller one is converted into the type of the
larger one. 
- If the smaller argument is signed, this conversion does sign-extension.
- The result type is the that of the largest argument.

### `dfdlx:bitNot(arg)`

This computes the bitwise NOT of an integer. Every bit is inverted. The result type is the same 
as the argument type. 

### `dfdlx:leftShift(value, shiftCount)`

This is the _logical_ shift left, meaning that bits are shifted from less-significant positions 
to more-significant positions. 

- The left-most bits shifted out are discarded. 
- Zeros are shifted in for the right-most bits. 
- The result type is the same as the `value` argument type. 
- It is a processing error if the `shiftCount` argument is < 0.
- It is a processing error if the `shiftCount` argument is greater than the number of 
  bits in the type of the value argument. 

### `dfdlx:rightShift(value, shiftCount)`

This is the _arithmetic_ shift right, meaning bits move from most-significant to 
less-significant positions.
If _logical_ (zero-filling) shift right is needed, you must use unsigned types.

- The `value` argument is shifted by the `shiftCount`.
- The right-most bits shifted out are discarded. 
- If the `value` is signed, then the sign bit is shifted in for the left-most bits.
- If the `value` is unsigned, then zeros are shifted in for the left-most bits. 
- The result type is the same as the `value` argument type.
- It is a processing error if the `shiftCount` argument is < 0.
- It is a processing error if the `shiftCount` argument is greater than the number of
  bits in the type of the value argument.

## `dfdlx:doubleFromRawLong(longArg)` and `dfdlx:doubleToRawLong(doubleArg)`

IEEE binary float and double values that are not NaN will parse to base 10 text and unparse back
to the same exact IEEE binary bits. 
However, the same cannot be said for NaN (not a number) values, of which there are many bit 
patterns. 
To preserve float and double NaN values bit for bit you can use these functions to compute
`xs:long` values that enable the DFDL Infoset to preserve the bits of a float or double value 
even if it is a NaN. 



# Properties

## `dfdlx:alignmentKind`

Valid values for this property are `manual` or `automatic` with `automatic` being the default 
behavior.
When specified, the `manual` value turns off all automatic alignment based on the 
`dfdl:alignment` and `dfdl:alignmentUnits` properties.
The schema author must use `dfdl:leadingSkip`, `dfdl:trailingSkip`, or just ensure all the 
elements/terms are aligned based on their length.

This property is sometimes needed to facilitate creation of schemas where interactions occur 
between computed lengths (that is, stored length fields) and 
alignment regions that are automatically being inserted. 
It can be easier to do all alignment manually than to debug these interactions. 

## `dfdlx:parseUnparsePolicy`

A property applied to simple and complex elements, which specifies whether the element supports only parsing, only unparsing, or both parsing and unparse. Valid values for this property are ``parse``, ``unparse``, or ``both``. This allows one to leave off properties that are required for only parse or only unparse, such as ``dfdl:outputValueCalc`` or ``dfdl:outputNewLine``, so that one may have a valid schema if only a subset of functionality is needed.

All elements must have a compatible parseUnparsePolicy with the compilation parseUnparsePolicy (which is defined by the root element daf:parseUnparsePolicy and/or the Daffodil parseUnparsePolicy tunable) or it is a Schema Definition Error. An element is defined to have a compatible parseUnparsePolicy if it has the same value as the compilation parseUnparsePolicy or if it has the value ``both``.

For compatibility, if this property is not defined, it is assumed to be ``both``.

## `dfdlx:layer`

_Layers_ provide algorithmic capabilities for decoding/encoding data or computing 
   checksums. Some are built-in to Daffodil. New layers can be created in Java/Scala and 
   plugged-in to Daffodil dynamically. 
There is [separate Layer documentation](/layers).

## `dfdlx:direction`

This property can appear only on DFDL `defineVariable` statement annotations.
This property has possible values `both` (the default), `parseOnly`, or `unparseOnly`. 
It declares 
whether the variable is to be available for only parsing, only unparsing, or both. 
Since this is a newly introduced extension property and existing schemas won't contain a definition 
for it, it has a default value of `both`. 

This property can conflict with the `dfdlx:parseUnparsePolicy` property which takes the same 
values (`both`, `parseOnly`, and `unparseOnly`).
If `dfdlx:parseUnparsePolicy='parseOnly' then it is a Schema Definition Error if 
variables in the DFDL schema have `dfdlx:direction='unparseOnly'. 
Similarly if `dfdlx:parseUnparsePolicy='unparseOnly' then it is a Schema Definition Error if
variables in the DFDL schema have `dfdlx:direction='parseOnly'. 

It is a Schema Definition Error if a variable defined with direction `parseOnly` is accessed 
from an expression used by the unparser. 
Symmetrically, it is a Schema Definition Error if a variable defined with direction
`unparseOnly` is accessed from an expression used by the parser.
This error is detected at DFDL schema compilation time, not runtime. 

These properties take expressions for their values and are generally evaluated at both parse and 
unparse time. 
Hence, unless the whole schema is constrained by `dfdlx:parseUnparsePolicy`, any expressions for 
these properties[^moreProps] cannot  
cannot reference DFDL variables with `dfdlx:direction` of `parseOnly` or `unparseOnly`. 

- `byteOrder`
- `encoding`
- `initiator`
- `terminator`
- `separator`
- `escapeCharacter`
- `escapeEscapeCharacter`
- `length`
- `occursCount`
- `textStandardDecimalSeparator`
- `textStandardGroupingSeparator`
- `textStandardExponentRep`
- `binaryFloatRep`
- `textBooleanTrueRep`
- `textbooleanFalseRep`
- `calendarLanguage`
- `dfdl:setVariable`, a `dfdl:newVariableInstance` default value expression, or a
  `dfdl:defineVariable` default value expression when
  that variable being set/defaulted is itself referenced from a another expression and the variable 
  being set/defaulted has `dfdlx:direction` of `both` (the default)

[^moreProps] New properties added as part of errata corrections to the DFDL v1.0 standard which 
take expressions for their values will need to be added to this list or those for 
parser-specific or unparser-specific properties. 
  
Parser-specific expressions include

- `dfdl:inputValueCalc`
- `dfdl:length` (when dfdl:lengthKind='explicit')
- `dfdl:occursCount` (when `dfdl:occursCountKind='expression')
- `dfdl:choiceDispatchKey`
- the `message` and `test` attributes of the `dfdl:assert` and `dfdl:discriminator` statement annotations
- `dfdl:setVariable`, a `dfdl:newVariableInstance` default value expression, or a
  `dfdl:defineVariable` default value expression when
  that variable being set/defaulted is itself referenced from a another expression being
  accessed at parser creation time, and the variable being set/defaulted has `dfdlx:direction`
  of `parseOnly`

Unparser-specific expressions include:

- `dfdl:outputValueCalc`
- `dfdl:length` (when `dfdl:lengthKind='explicit')
- `dfdl:outputNewLine`
- `dfdl:setVariable`, a `dfdl:newVariableInstance` default value expression, or a 
  `dfdl:defineVariable` default value expression when 
  that variable being set/defaulted is itself referenced from a another expression being 
  accessed at unparser creation time, and the variable being set/defaulted has `dfdlx:direction` 
  of `unparseOnly` 


## Enumerations: `dfdlx:repType`, `dfdlx:repValues`, and `dfdlx:repValueRanges`

These properties work together to allow DFDL schemas to define _enumerations_;
that is, symbolic representations for integer constants. 
When parsing, Daffodil will convert these integers into the corresponding string values. 
When unparsing, Daffodil will convert strings into the corresponding integers. 

An element of type (or derived from) `xs:string` can be defined using XSD `enumeration` facets 
which constrain the valid values of this string. 
These enumeration values are effectively symbolic constants. 
The `dfdlx:repType` and `dfdlx:repValues` properties are then used to define the correspondence of 
the symbolic strings to the corresponding integer values.

### `dfdlx:repType`

The value of this property is an XSD QName of a simple type definition that must be derived
from `xs:int`, or `xs:unsignedInt`. 
A simple type definition for a string can be annotated with `dfdlx:repType` 
in order to declare that the representation of the string is not as text characters but is a 
numeric integer value. 
The type referenced from `dfdlx:repType` is usually a fixed length binary integer, but can be any
DFDL type derived from `xs:int` or `xs:unsignedInt`, with any DFDL representation properties. 

The mapping between the representation integer and the symbolic constants is specified using the 
`dfdlx:repValues` and/or `dfdlx:repValueRanges` properties. 

### `dfdlx:repValues`

The value of this property is one or more integer values within 
the numeric range defined for the type referenced by `dfdlx:repType`. When more than one value 
is specified, they are in a whitespace separated list. 

This property is placed on the `xs:enumeration` facets of a symbolic string constant having a 
`dfdlx:repType`. 
At parse time, if the value of the `dfdlx:repType` integer is found within the `dfdlx:repValues` 
list, then the infoset value for the symbolic string gets the corresponing enumeration facet value.
It is a parse error if no `xs:enumeration` has a `dfdlx:repValues` nor `dfdlx:repValueRanges` 
(see below) assign a symbolic equivalent to the `dfdlx:repType` integer.
At unparse time, the symbolic constant is mapped to the first integer in the dfdlx:repValues list. 
It is an unparse error if the symbolic string value is not found among the `xs:enumeration` 
facet values of the symbolic string type. 


### `dfdlx:repValueRanges`

The value of this property is a list of integers of even length 2 or greater. The integers at 
odd positions (starting with position 1) define the inclusive lower bound of a range of 
integers.
The integers at even positions (starting with position 2) define the corresponding inclusive 
upper bound of a range of integers.

This property is placed on the `xs:enumeration` facets of a symbolic string constant having a
`dfdlx:repType`.

At parse time, the integer value of the `dfdlx:repType` is used to search the numeric ranges. 
If it is found in any of the numeric ranges for a specific `xs:enumeration` facet, then the 
facet's value is used as the corresponding symbolic value. 
It is a parse error if no `xs:enumeration` has a `dfdlx:repValues` (see above) nor 
`dfdlx:repValueRanges` assign a symbolic equivalent to the `dfdlx:repType` integer. 
At unparse time, the symbolic string value's corresponding `xs:enumeration` facet is found and 
if the `xs:enumeration` contains both `dfdlx:repValues` and `dfdlx:repValueRanges` then the 
`dfdlx:repValues` is used to determine the corresponing `dfdl:repType` integer value to unparse, 
as described above for the `dfdl:repValues` property. 
If the `xs:enumeration` has no `dfdlx:repValues` property, then the smallest numeric value in the  
`dfdlx:repValueRanges` list is unparsed for the `dfdlx:repType` integer. 

TBD: is this correct? Or is it the lower bound of the first range?

TBD: is this correct that dfdlx:repValues always supercedes dfdlx:repValueRanges

### Examples of Enumerations in Daffodil DFDL

A simple example of a basic enum is:

```xml-schema
  <simpleType name="rep3Bit" dfdl:lengthUnits="bits" dfdl:length="3" dfdl:lengthKind="explicit">
    <restriction base="xs:unsignedInt"/>
  </simpleType>
    
  <simpleType name="precedenceEnum" dfdlx:repType="pre:rep3Bit">
    <restriction base="xs:string">
      <enumeration value="Reserved_0" dfdlx:repValues="0"/>
      <enumeration value="Reserved_1" dfdlx:repValues="1"/>
      <enumeration value="Emergency" dfdlx:repValues="2"/>
      <enumeration value="Reserved_3" dfdlx:repValues="3"/>
      <enumeration value="Flash" dfdlx:repValues="4"/>
      <enumeration value="Immediate" dfdlx:repValues="5"/>
      <enumeration value="Priority" dfdlx:repValues="6"/>
      <enumeration value="Routine" dfdlx:repValues="7"/>
    </restriction>
  </simpleType>
  ```

Above we see the `dfdlx:repType` is `rep3Bit` which is a 3 bit `xs:unsignedInt`. This can
represent the values 0 to 7 which one can see are the `dfdlx:repValues` of the `xs:enumeration`
facets for this enumeration string type which is named `precedenceEnum`.

In the above you can also see that the symbolic strings are in one-to-one correspondence with 
every possible value of the 3-bit representation integer. 
This one-to-one correspondence assures that data that is first parsed and then unparsed will 
recreate the exact numeric bits used.

However, in data security applications the following may be preferred:
```xml-schema
 <simpleType name="precedenceEnum" dfdlx:repType="pre:rep3Bit">
    <restriction base="xs:string">
      <enumeration value="Reserved" dfdlx:repValues="0 1 3"/>
      <enumeration value="Emergency" dfdlx:repValues="2"/>
      <enumeration value="Flash" dfdlx:repValues="4"/>
      <enumeration value="Immediate" dfdlx:repValues="5"/>
      <enumeration value="Priority" dfdlx:repValues="6"/>
      <enumeration value="Routine" dfdlx:repValues="7"/>
    </restriction>
  </simpleType>
```

In the above we see that three numeric values, 0, 1, and 3 are the `dfdlx:repValues` mapped to 
the symbolic string `Reserved`. 
This technique has the advantage of blocking covert signals being transmitted by use of the 
different reserved values since when unparsed, the constant string `Reserved` will always be 
_canonicalized_ to integer 0. 
Putting data into canonical form when unparsing generally improves data security.

The next example illustrates use of the `dfdlx:repValueRanges` property:


```xml-schema
  <simpleType name="rep5Bit" dfdl:lengthUnits="bits" dfdl:length="5" dfdl:lengthKind="explicit">
    <restriction base="xs:unsignedInt"/>
  </simpleType>
    
  <simpleType name="versionEnum" dfdlx:repType="pre:rep4Bit">
    <restriction base="xs:string">
      <enumeration value="Undefined" dfdlx:repValues="0" dfdlx:repValueRanges="5 10 12 17"/>
      <enumeration value="B" dfdlx:repValues="1"/>
      <enumeration value="C" dfdlx:repValues="2"/>
      <enumeration value="D" dfdlx:repValues="3"/>
      <enumeration value="E" dfdlx:repValues="4"/>
      <enumeration value="Q" dfdlx:repValues="11"/>
      <enumeration value="NotImplemented" dfdl:repValueRanges="18 31"/>
    </restriction>
  </simpleType>
 ```

In the above the enumeration specifies that many of the values are considered `Undefined` 
including values 0, 5 through 10, and 12 through 17. 
A second range from 18 to 31 correspond to constant `NotImplemented`. 



# Extended Behaviors for DFDL Types

## Type ``xs:hexBinary``

Daffodil allows `dfdlx:lengthUnits='bits'` for this simple type. 
