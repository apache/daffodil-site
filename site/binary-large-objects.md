---
description: Binary Large Objects Feature
group: 'nav-right'
layout: page
title: 'Binary Large Objects Feature'
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
## Table of Contents
{:.no_toc}
<!-- The {: .no_toc } excludes the above heading from the ToC --> 

1. yes, this is the standard Jekyll way to do a ToC (this line gets removed)
{:toc}
<!-- note the above line {:toc} cannot have whitespace at the start --> 


<!--
This page is linked from https://s.apache.org/daffodil-blob-feature.
 If this page content moves, please update that link from https://s.apache.org.
-->

# Introduction

Daffodil has implemented a DFDL extension that allows data much larger than memory to be manipulated.

A variety of data formats, such as for image and video files, consist of fields of what is effectively metadata, surrounding large blocks of data containing compressed image or video data.

An important use case for DFDL is to expose this metadata for easy use, and to provide access to 
the large data via a streaming mechanism akin to opening a file, thereby avoiding
large `xs:hexBinary` strings in the infoset.

In RDBMS systems, BLOB (Binary Large Object) is the type used when the data row returned from an SQL query will not contain the actual value data, but rather a handle that can be used to open/read/write/close the BLOB.

Daffodil has an analogous BLOB capability. 
This enables processing of images or video of arbitrary size without the need to ever hold all the data in memory.

This also bypasses the limitation on object size.


# Type `xs:anyURI` and Property `dfdlx:objectKind`

DFDL is extended to allow simple types to have the `xs:anyURI` type. 
Elements with this type will be treated as BLOB objects.

The `dfdlx:objectKind` property is added to define what type of object it is. 
The valid value for this property is only `"bytes"` specifying binary large objects.
All other values reserved for future extensions of this feature.

An example of this usage in a DFDL schema may look something like this:

```xml
<xs:schema
  xmlns:dfdlx="http://www.ogf.org/dfdl/dfdl-1.0/extensions"
  xmlns:dfdl="http://www.ogf.org/dfdl/dfdl-1.0/">

  <xs:element name="data" type="xs:anyURI" 
    dfdlx:objectKind="bytes"
    dfdl:lengthUnits="bytes"
    dfdl:length="1024" />

</xs:schema>
```

The resulting infoset (as XML) will look something like this:

```xml
<data>file:///path/to/blob/data</data>
```

With the 1024 bytes of data being written to a file at location `/path/to/blob/data`.

The BLOB URI must always use the _file scheme_ and must be absolute. 

# Daffodil BLOB API

API calls are used to specify where Daffodil should write the BLOB files.

Two functions are used on the Daffodil `InfosetOutputter`.

The first API function allows a way to set the properties used when
creating BLOB files, including the output directory, and prefix/suffix
for the BLOB file.

```scala
/**
 * Set the attributes for how to create blob files.
 *
 * @param dir the Path the the directory to create files. If the directory
 *            does not exist, Daffodil will attempt to create it before
 *            writing a blob.
 * @param prefix the prefix string to be used in generating a blob file name
 * @param suffix the suffix string to be used in generating a blob file name
 */
final def setBlobAttributes(directory: Path, prefix: String, suffix: String)
```

The second API function allows a way for the API user to get a list of
all BLOB files that were created during `parse()`.

```scala
/**
 * Get the list of blob paths that were output in the infoset.
 *
 * This is the same as what would be found by iterating over the infoset.
 */
final def getBlobFiles(): Seq[Path]
```

Note that no changes to the `unparse()` API are required, since the BLOB URI provides 
all the necessary information to retrieve files containing BLOB data.

BLOB files are not automatically deleted.
It is the responsibility of the API user to determine when files are no 
longer needed and remove them.

# DFDL Expressions

Any expression access to the _data_ of a BLOB element will result in a
Schema Definition Error during schema compilation.

The _length_ of a BLOB element is available since it is very common in
data formats to include both a BLOB payload and the length of that
payload. On unparse, we can calculate the length of the BLOB data so
that the value can be output in a length field in the data. This is
done using the regular `dfdl:contentLength()` and `dfdl:valueLength()`
functions.


# Testing DFDL Schemas using BLOBs via the TDML Runner

The TDML language is extended to support the `xsi:type="xs:anyURI"` annotation on XML data elements.

For example:

```xml
<tdml:dfdlInfoset>
  <data xsi:type="xs:anyURI">path/to/blob/data</data>
</tdml:dfdlInfoset>
```

The path provided as the URI value can be, and usually will be, a relative path within the 
`src/test/resources` directory of the DFDL schema project. 
During Infoset comparisons the TDML Runner will compare the contents of this file 
with the BLOB file in the corresponding element (having type `xs:anyURI`) of the infoset.  

BLOB files created when running the tests are deleted when the test completes.

# Command Line Interface

The CLI supports ad-hoc testing of the use of BLOBs.
BLOBs are written to the directory given by the JVM _System Property_ `user.dir` into 
a subdirectory of it named `daffodil-blobs`. 
If it does not exist, Daffodil will attempt to create the `daffodil-blobs` directory.
The CLI does not delete any BLOB files. 
