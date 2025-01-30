---
layout: page
title: DFDL Extensions
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

Daffodil provides extensions to the DFDL specification. 
These properties are in the namespace defined by the URI 
``http://www.ogf.org/dfdl/dfdl-1.0/extensions`` which is normally bound to the ``dfdlx`` prefix 
like so: 


``` xml
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:dfdl="http://www.ogf.org/dfdl/dfdl-1.0/"
           xmlns:dfdlx="http://www.ogf.org/dfdl/dfdl-1.0/extensions"
>
```

The following symbols defined in this namespace are described below.

### Expression Functions

``daf:error()``

   : A function that can be used in DFDL expressions. This functions does not return a value or accept any arguments. When called, it causes a Parse Error or Unparse Error.

     *This function is deprecated as of Daffodil 2.0.0. 
      Use the ``fn:error(...)`` function instead.*

``dfdlx:trace($value, $label)``

   : A function that can be used in DFDL expressions, similar to the ``fn:trace()`` function. This logs the string ``$label`` followed by ``$value`` converted to a string and returns ``$value``. The second argument must be of type ``xs:string``.

``dfdlx:lookAhead(offset, bitSize)``

   : Read ``bitSize`` bits, where the first bit is located at an ``offset`` (in bits)
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
  
#### Examples of `dfdlx:lookAhead`
   The following two elements both populate element `a` with the value of the next 3 bits as an 
   unsignedInt. They are not completely equivalent because the first will consume 3 bits of the 
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

Bitwise Functions

   : TBD, but the complete list (all ``dfdlx``) is `BitAnd`, `BitNot`, `BitOr`, `BitXor`, `LeftShift`, 
   `RightShift`

``dfdlx:doubleFromRawLong`` and ``dfdlx:doubleToRawLong``

   : Converting binary floating point numbers to/from base 10 text can result in lost information.
The base 10 representation, converted back to binary representation, may not be bit-for-bit 
   identical. These functions can be used to carry 8-byte double precision IEEE floating point 
   numbers as type `xs:long` so that no information is lost. The DFDL schema can still obtain 
   and operate on the floating point value by converting these `xs:long` values into type 
   `xs:double`, and back if necessary for unparsing a new value. 

### Properties

``dfdlx:parseUnparsePolicy``

   : A property applied to simple and complex elements, which specifies whether the element supports only parsing, only unparsing, or both parsing and unparse. Valid values for this property are ``parse``, ``unparse``, or ``both``. This allows one to leave off properties that are required for only parse or only unparse, such as ``dfdl:outputValueCalc`` or ``dfdl:outputNewLine``, so that one may have a valid schema if only a subset of functionality is needed.

     All elements must have a compatible parseUnparsePolicy with the compilation parseUnparsePolicy (which is defined by the root element daf:parseUnparsePolicy and/or the Daffodil parseUnparsePolicy tunable) or it is a Schema Definition Error. An element is defined to have a compatible parseUnparsePolicy if it has the same value as the compilation parseUnparsePolicy or if it has the value ``both``.

     For compatibility, if this property is not defined, it is assumed to be ``both``.

``dfdlx:layer``

   : [Layers](/layers) provide algorithmic capabilities for decoding/encoding data or computing 
   checksums. Some are built-in to Daffodil. New layers can be created in Java/Scala and 
   plugged-in to Daffodil dynamically. 

``dfdlx:direction``

   : TBD

``dfdlx:repType``, ``dfdlx:repValues``, and ``dfdlx:repValueRanges``

   : TBD

### Extended Behaviors

Type ``xs:hexBinary``

   : Daffodil allows `dfdlx:lengthUnits='bits'` for this simple type. 
