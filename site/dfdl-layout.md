---
layout: page
title: Standard DFDL Schema Project Layout
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

There is a specific way of organizing a DFDL schema project that has been found
to be helpful. It uses specific directory naming conventions and tree structure
to manage name conflicts in a manner similar to how Java package names
correspond to directory names.

### Quick Start

To quickly get started and generate this directory structure, you can install
[SBT](https://www.scala-sbt.org/) and run the following command:

```
sbt new apache/daffodil-schema.g8
```

This prompts for various properties and creates the directory structure
described below, including git and sbt configuration files, a basic DFDL schema
file, and TDML and test files.

### Conventions

This set of conventions provides a number of benefits:

* No name conflicts or ambiguity on classpath if multiple DFDL schemas are used
  together
* You can copy multiple DFDL schemas into one directory tree and there will be
  no conflicts of file names
* sbt can be used to
    * Package the schema into a jar, which can then be on a classpath, become
      part of a larger application, etc.
    * Auto-download all dependencies of the schema, including Daffodil itself.
    * Run a suite of tests via 'sbt test'
    * Publish a local version of the schema for use in other projects that also
      follow this layout.
* Eclipse IDE for development and test of the schema. Multiple such schemas all
  work together without conflict in the IDE.
* Encourages organizing DFDL schemas into reusable libraries. 
    * A DFDL schema project need not define a whole data format. It can define
      a library of pieces to be included/imported by other formats.

These conventions are actually usable for regular XML-schema projects, that is,
they're not really DFDL-specific conventions. They're general conventions for
organizing projects so as to achieve the above benefits.

### Standard File Tree

Let's assume the DFDL schema contains two files named rfmt.dfdl.xsd, and
format.dfdl.xsd, and that our format is named RFormat (rfmt) with an
organization web identity of example.com.

The standard file tree would be:

    rfmt/
    ├── .gitattributes         - Git revision control system 'attributes' (see below)
    ├── .gitignore             - Git revision control system 'ignore' file (should contain
    │                            'target' and 'lib_managed' entries)
    ├── build.sbt              - Simple Build Tool (sbt) specification file. Edit to change version
    │                            of Daffodil needed, or versions of other DFDL schemas needed
    ├── README.md              - Documentation about the DFDL schema in Markdown file format
    ├── project/
    │   └── build.properties   - Defines the sbt version
    └── src/
        ├── main/
        │   └── resources/
        │       └── com/
        │           └── example/
        │               └── rfmt/
        │                   ├── xsd/
        │                   │   ├── rfmt.dfdl.xsd    - Primary RFormat DFDL schema file
        │                   │   └── format.dfdl.xsd  - DFDL schema file imported/included from rfmt.dfdl.xsd
        │                   └── xsl/
        │                       └── xforms.xsl       - Resources other than XSD go in other directories
        └── test/
            ├── resources/
            │   └── com/
            │       └── example/
            │           └── rfmt/
            │               ├── Tests1.tdml          - TDML test files
            │               ├── data/                - Test data files not embedded in a TDML file
            │               │   └── test01.rfmt      - or .bin, .dat, .txt, etc.
            │               └── infosets/            - Test infoset files not embedded in a TDML file
            │                   └── test01.rfmt.xml
            └── scala/
                └── com/
                    └── example/
                        └── rfmt/
                            └── Tests1.scala   - Scala test driver file

### build.sbt

Use the below template for the build.sbt file:

``` scala
name := "dfdl-rfmt"
 
organization := "com.example"
 
version := "0.0.1"
 
scalaVersion := "2.12.11"
 
libraryDependencies ++= Seq(
  "org.apache.daffodil" %% "daffodil-tdml-processor" % "3.0.0" % "test",
  "com.novocode" % "junit-interface" % "0.11" % "test",
  "junit" % "junit" % "4.12" % "test",
)

testOptions += Tests.Argument(TestFrameworks.JUnit, "-v")

crossPaths := false
```

Edit the version of daffodil-tdml above to match the version you are using. 

### .gitattributes

In some cases, git may mangle line endings of files so that they match the line
ending of the system. In most cases, this is done in such a way that it you may
never notice. However, in cases where file formats require specific line
endings, this mangling of test data can lead to test failures. To prevent this,
we recommend that a .gitattributes file be created in the root of the format
directory with the following content to disabling the mangline:

```
/src/test/resources/**/data/** text=false
```
The above tells git that any test files in the data directory should be treated
as if they were binary, and thus not to mangle newlines.

### Eclipse IDE

If you organize your DFDL schema project using the above conventions, and then
run ``sbt compile``, the ``lib_managed`` directory will be populated. Then if
you create a new Eclipse scala project from the directory tree, Eclipse will
see the ``lib_managed`` directory and construct a classpath containing all
those jars.

### XSD Conventions

DFDL schemas should have the ``.dfdl.xsd`` suffix to distinguish them from
ordinary XML Schema files.

A DFDL schema should have a target namespace.

Stylistically, the XSD ``elementFormDefault="unqualified"`` is the preferred
style for DFDL schemas.

### Using a DFDL Schema

The ``xs:include`` or ``xs:import`` elements of a DFDL Schema can
import/include a DFDL schema that follows these conventions like this:

``` xml
<xs:import namespace="urn:example.com/rfmt" schemaLocation="com/example/rfmt/xsd/rfmt.dfdl.xsd"/>
```

The above is for using a DFDL schema as a library, from another different DFDL
schema.

Within a DFDL schema, one DFDL schema file can reference another peer file that
appears in the same directory (the src/main/resources/.../xsd directory) via:

``` xml
<xs:include schemaLocation="format.dfdl.xsd"/>
```

That is, peer files need not carry the long ``com/example/rfmt/xsd/`` prefix
that makes the reference globally unique.

However, if one schema wants to include another different schema, then this
standard way of organizing schema projects ensures that when packaged into jar
files, the ``/src/main/resources`` directory contents are at the "root" of the
jar file so that the ``schemaLocation`` of the ``xs:import`` or ``xs:include``
containing the fully qualified path (``com/example/rfmt/xsd/rfmt.dfdl.xsd``)
will be found on the ``CLASSPATH`` unambiguously. This convention is what
allows the schema files themselves to have short names like rfmt.dfdl.xsd, and
format.dfdl.xsd. Those names only need to be unique within a single schema
project. Across schema projects our standard DFDL schema project layout insures
unambiguous qualification is available.

### Git Revision Control

You don't have to use Git version control, but many people do, and github.com
is one of the reasons for this popularity.

Each DFDL schema should have its own Git repository if it is going to be
revised independently. We encourage users to join the
[DFDLSchemas](https://dfdlschemas.github.io/) project on github and create
repositories and publish schemas for any publicly-available formats there. For
other formats that are not publicly available, one may want to put a
placeholder for them on DFDLSchemas anyway (as IBM has done for some formats
like Swift-MT.)

### Jar File Packaging

A DFDL schema using the recommended file structure as described here, can be
packaged into a jar for convenient import/include from other schemas.

The sbt command does all the work:

``` bash
sbt package      # creates jar
sbt publishLocal # puts it into local .ivy2 cache where other maven/sbt will find it.
```

The resulting jar has the src/main/resources directory in it at the root of the
jar. If this jar is on the classpath, then other schemas containing XSD import
or include statements will search the jar with the schema location.

That enables a different schema's ``build.sbt`` to contain a library dependency
on our hypthetical dfdl-rfmt schema using a dependency like this:

``` scala
"com.example" % "dfdl-rfmt" % "0.0.1" % "test"
```

That will result in the contents of the ``src/main/resources`` directory above
being on the classpath. XSD include and import statements search the classpath
directories.
