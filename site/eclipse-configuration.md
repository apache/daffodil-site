---
layout: page
title: Eclipse Configuration
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

The Eclipse IDE can be used to assist a user in the authoring of DFDL schemas. This page contains instructions for setting up the Eclipse Integrated-Development-Environment (IDE), and to configure its XML editing features so that they provide some level of support for authoring DFDL schemas.

DFDL extends a subset of XML Schema. Note however: an XML Schema is an XML document.

Now, turns out there is an XML Schema for DFDL Schemas. It was created by taking the XML Schema for XML Schemas, and subsetting it to just what DFDL uses, and then adding into it the XML Schema for DFDL's annotation objects.

### Installing Eclipse XML Plugin

The XML settings all assume you have installed Eclipse's XML support. If not already installed, the "Eclipse XML Editors and Tools" plugin can be Eclipse's update site.

### Eclipse XML Settings

Following are steps to modify the Eclipse XML settings to aid in the creation of DFDL schemas:

#### Enable Validation of DFDL Files

1. Window > Preferences > Validation
	1. Turn off XML Schema Validator
	1. Turn off DTD Validator
	1. Click the ... settings box to the right of XML Validator
		1. Select Include Group
		1. Click Add Rule
		1. Select File Extension
		1. Click Next
		1. Add extension: ``dfdl.xsd``
		1. Click Finish
1. Window > Preferences > General > Content Types
	1. Select Text > XML
	1. Click Add...
	1. Set Content type to ``*.dfdl.xsd``
1. Window > Preferences > XML > XML Files > Editor
	1. Uncheck Format Comments

If also editing TDML file in Eclipse, repeat the above steps, replacing all instances of ``dfdl.xsd`` with ``tdml``.

#### Add XML Schemas for DFDL to the XML Catalog

Download the following files to a local directory. Alternatively, these files are included in the Daffodil source code in the ``src/main/resources/org/apache/daffodil/xsd/`` directory in either ``daffodil-lib/`` or ``daffodil-propgen/``.

*  [datatypes.dtd](https://raw.githubusercontent.com/apache/incubator-daffodil/master/daffodil-lib/src/main/resources/org/apache/daffodil/xsd/datatypes.dtd)
*  [tdml.xsd](https://raw.githubusercontent.com/apache/incubator-daffodil/master/daffodil-lib/src/main/resources/org/apache/daffodil/xsd/tdml.xsd)
*  [XMLSchema.dtd](https://raw.githubusercontent.com/apache/incubator-daffodil/master/daffodil-lib/src/main/resources/org/apache/daffodil/xsd/XMLSchema.dtd)
*  [XMLSchema_for_DFDL.xsd](https://raw.githubusercontent.com/apache/incubator-daffodil/master/daffodil-lib/src/main/resources/org/apache/daffodil/xsd/XMLSchema_for_DFDL.xsd)
*  [DFDL_part1_simpletypes.xsd](https://raw.githubusercontent.com/apache/incubator-daffodil/master/daffodil-propgen/src/main/resources/org/apache/daffodil/xsd/DFDL_part1_simpletypes.xsd)
*  [DFDL_part2_attributes.xsd](https://raw.githubusercontent.com/apache/incubator-daffodil/master/daffodil-propgen/src/main/resources/org/apache/daffodil/xsd/DFDL_part2_attributes.xsd)
*  [DFDL_part3_model.xsd](https://raw.githubusercontent.com/apache/incubator-daffodil/master/daffodil-propgen/src/main/resources/org/apache/daffodil/xsd/DFDL_part3_model.xsd)

Modify the Eclipse settings to reference these files:

1. Windows > Preferences > XML > XML Catalog
1. For each of the following files, select 'Add..' and provide the location on the 'File System...' or 'Workspace...', along with the key and key type

   <table class="table">
     <tr>
       <th>File</th>
       <th>Key Type</th>
       <th>Key</th>
     </tr>
     <tr>
       <td>XMLSchema.dtd</td>
       <td>Public ID</td>
       <td>-//W3C//DTD XMLSCHEMA 200102//EN</td>
     </tr>
     <tr>
       <td>datatypes.dtd</td>
       <td>Public ID</td>
       <td>datatypes</td>
     </tr>
     <tr>
       <td>XMLSchema_for_DFDL.xsd</td>
       <td>URI</td>
       <td>http://www.w3.org/2001/XMLSchema</td>
     </tr>
     <tr>
       <td>DFDL_part3_model.xsd</td>
       <td>URI</td>
       <td>http://www.ogf.org/dfdl/dfdl-1.0/</td>
     </tr>
     <tr>
       <td>tdml.xsd</td>
       <td>URI</td>
       <td>http://www.ibm.com/xmlns/dfdl/testData</td>
     </tr>
   </table>
