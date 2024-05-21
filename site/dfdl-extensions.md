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

     *This function is deprecated as of Daffodil 2.0.0. Use the ``fn:error(...)`` function instead.*

``dfdlx:trace($value, $label)``

   : A function that can be used in DFDL expressions, similar to the ``fn:trace()`` function. This logs the string ``$label`` followed by ``$value`` converted to a string and returns ``$value``. The second argument must be of type ``xs:string``.

``dfdlx:lookahead(offset, bitSize)``

   : TBD

Bitwise Functions

   : TBD, but the complete list (all ``dfdlx``) is `BitAnd`, `BitNot`, `BitOr`, `BitXor`, `LeftShift`, 
   `RightShift`

``dfdlx:doubleFromRawLong`` and ``dfdlx:doubleToRawLong``

   : TBD

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
