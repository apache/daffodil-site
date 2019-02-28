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

## Standard DFDL Schema Project layout

There is a specific way of organizing a DFDL schema project that has been found to be helpful. It uses specific directory naming conventions and tree structure to manage name conflicts in a manner similar to how Java package names * correspond to directory names. This set of conventions provides a number of benefits:

* No name conflicts or ambiguity on classpath if multiple DFDL schemas are used together
* You can copy multiple DFDL schemas into one directory tree and there will be no conflicts of file names
* sbt can be used to
    * Package the schema into a jar, which can then be on a classpath, become part of a larger application, etc.
    * Auto-download all dependencies of the schema, including Daffodil itself.
    * Run a suite of tests via 'sbt test'
    * Publish a local version of the schema for use in other projects that also follow this layout.
* Eclipse IDE for development and test of the schema. Multiple such schemas all work together without conflict in the IDE.
* Encourages organizing DFDL schemas into reusable libraries. 
    * A DFDL schema project need not define a whole data format. It can define a library of pieces to be included/imported by other formats.

These conventions are actually usable for regular XML-schema projects, that is, they're not really DFDL-specific conventions. They're general conventions for organizing projects so as to achieve the above benefits.

### Conventions

We're using Apache (apache.org) here as an example. Substitute your organization's details. Let's assume the DFDL schema contains two files named main.dfdl.xsd, and format.dfdl.xsd, and that our format is named RFormat.

The standard file tree would be:

    RFormat/
    ├── src/
    │   ├── main/
    │   │   └── resources/
    │   │       └── org/
    │   │           └── apache/
    │   │               └── RFormat/
    │   │                   ├── xsd/
    │   │                   │   ├── main.dfdl.xsd    - main DFDL schema file
    │   │                   │   └── format.dfdl.xsd  - DFDL schema file imported/included from main
    │   │                   └── xsl/
    │   │                       └── xforms.xsl       - resources other than XSD go in other directories
    │   └── test/
    │       ├── resources/
    │       │   └── org/
    │       │       └── apache/
    │       │           └── RFormat/
    │       │               └── tests1.tdml    - TDML test files
    │       └── scala/
    │           └── org/
    │               └── apache/
    │                   └── RFormat/
    │                       └── Tests1.scala   - Scala test driver file
    │
    ├── build.sbt    - simple build tool (sbt) specification file. Edit to change version of Daffodil
    │                  needed, or versions of other DFDL schemas needed
    ├── README.md    - Documentation about the DFDL schema in Markdown file format
    ├── .classpath   - Eclipse classpath file (optional)
    ├── .project     - Eclipse project file (optional)
    └── .gitignore   - Git revision control system 'ignore' file (should contain 'target' and
                       'lib_managed' entries)

### build.sbt

Use the below template for the build.sbt file:

``` scala
name := "dfdl-RFormat"
 
organization := "org.apache"
 
version := "0.0.1"
 
scalaVersion := "2.11.8"
 
crossPaths := false
 
testOptions in ThisBuild += Tests.Argument(TestFrameworks.JUnit, "-v")
 
libraryDependencies in ThisBuild := Seq(
  "org.apache.daffodil" %% "daffodil-tdml" % "2.1.0" % "test",
  "junit" % "junit" % "4.11" % "test",
  "com.novocode" % "junit-interface" % "0.10" % "test",
)
```

Edit the version of daffodil-tdml above to match the version you are using. 

### Eclipse IDE

If you organize your DFDL schema project using the above conventions, and then run ``sbt compile``, the ``lib_managed`` directory will be populated. Then if you create a new Eclipse scala project from the directory tree, Eclipse will see the ``lib_managed`` directory and construct a classpath containing all those jars.

### XSD Conventions

DFDL schemas should have the ``.dfdl.xsd`` suffix to distinguish them from ordinary XML Schema files.

A DFDL schema should have a target namespace.

Stylistically, the XSD ``elementFormDefault="unqualified"`` is the preferred style for DFDL schemas.

### Using a DFDL Schema

The ``xs:include`` or ``xs:import`` elements of a DFDL Schema can import/include a DFDL schema that follows these conventions like this:

``` xml
<xs:import namespace="urn:apache.org/RFormat" schemaLocation="org/apache/RFormat/xsd/main.dfdl.xsd"/>
```

The above is for using a DFDL schema as a library, from another different DFDL schema. 

Within a DFDL schema, one DFDL schema file can reference another peer file that appears in the same directory (the src/main/resources/.../xsd directory) via:

``` xml
<xs:include schemaLocation="format.dfdl.xsd"/>
```

That is, peer files need not carry the long ``org/apache/RFormat/xsd/`` prefix that makes the reference globally unique.

However, if one schema wants to include another different schema, then this standard way of organizing schema projects ensures that when packaged into jar files, the ``/src/main/resources`` directory contents are at the "root" of the jar file so that the ``schemaLocation`` of the ``xs:import`` or ``xs:include`` containing the fully qualified path (``org/apache/RFormat/xsd/main.dfdl.xsd``) will be found on the ``CLASSPATH`` unambiguously. This convention is what allows the schema files themselves to have short names like main.dfdl.xsd, and format.dfdl.xsd. Those names only need to be unique within a single schema project. Across schema projects our standard DFDL schema project layout insures unambiguous qualification is available.

### Git Revision Control

You don't have to use Git version control, but many people do, and github.com is one of the reasons for this popularity.

Each DFDL schema should have its own Git repository if it is going to be revised independently. We encourage users to join the [DFDLSchemas](https://dfdlschemas.github.io/) project on github and create repositories and publish schemas for any publicly-available formats there. For other formats that are not publicly available, one may want to put a placeholder for them on DFDLSchemas anyway (as IBM has done for some formats like Swift-MT.)

### Jar File Packaging

A DFDL schema using the recommended file structure as described here, can be packaged into a jar for convenient import/include from other schemas.

The sbt command does all the work:

    sbt package      # creates jar
    sbt publishLocal # puts it into local .ivy2 cache where other maven/sbt will find it.

The resulting jar has the src/main/resources directory in it at the root of the jar. If this jar is on the classpath, then other schemas containing XSD import or include statements will search the jar with the schema location.

That enables a different schema's ``build.sbt`` to contain a library dependency on our hypthetical dfdl-RFormat schema using a dependency like this:

```
"org.apache" % "dfdl-RFormat" % "0.0.1" % "test"
```

That will result in the contents of the ``src/main/resources`` directory above being on the classpath. XSD include and import statements search the classpath directories.
