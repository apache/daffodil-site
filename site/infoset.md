---
layout: page
title: Daffodil and the DFDL Infoset
description: Daffodil and the DFDL Infoset
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


Daffodil is an implementation of DFDL which supports multiple methods to
represent the DFDL Infoset, including various XML representations and JSON.
However, the DFDL Infoset is somewhat different from the representations that
Daffodil creates since Daffodil approximates the DFDL Infoset using a subset of
features of XML/JSON. The below tables describe how Daffodil maps the DFDL
Infoset to the supported representations.

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#jdom">JDOM</a></li>
  <li><a data-toggle="tab" href="#w3cdom">W3C DOM</a></li>
  <li><a data-toggle="tab" href="#scalanode">Scala Node</a></li>
  <li><a data-toggle="tab" href="#xmltext">XML Text</a></li>
  <li><a data-toggle="tab" href="#json">JSON</a></li>
</ul>

<div class="tab-content">
  <div id="jdom" class="tab-pane fade in active">
    <table class="table">
      <tr>
        <td class="col-md-3">Document Information Item</td>
        <td class="col-md-9">org.jdom.Document</td>
      </tr>
      <tr>
        <td class="col-md-3">root</td>
        <td class="col-md-9">org.jdom.Element getRootElement()</td>
      </tr>
      <tr>
        <td class="col-md-3">dfdlVersion</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">schema (reserved for future use)</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unicodeByteOrderMark</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">Element Information Item</td>
        <td class="col-md-9">org.jdom.Element</td>
      </tr>
      <tr>
        <td class="col-md-3">namespace</td>
        <td class="col-md-9">org.jdom.Namespace getNamespace()</td>
      </tr>
      <tr>
        <td class="col-md-3">name</td>
        <td class="col-md-9">String getName()</td>
      </tr>
      <tr>
        <td class="col-md-3">document</td>
        <td class="col-md-9">org.jdom.Document getDocument()</td>
      </tr>
      <tr>
        <td class="col-md-3">datatype</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">dataValue</td>
        <td class="col-md-9">
          For simple types other than xs:string, the canonical
          XML representation of the value as returned by String getText(). See <a
          href="#xml-illegal-characters">XML Illegal Characters</a> for xs:string
          types containing XML illegal characters.
        </td>
      </tr>
      <tr>
        <td class="col-md-3">nilled</td>
        <td class="col-md-9">The "nilled" attribute in the "xsi" namespace.</td>
      </tr>
      <tr>
        <td class="col-md-3">children</td>
        <td class="col-md-9">java.util.List&lt;Element&gt; getChildren()</td>
      </tr>
      <tr>
        <td class="col-md-3">parent</td>
        <td class="col-md-9">org.jdom.Parent getParent()</td>
      </tr>
      <tr>
        <td class="col-md-3">schema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">valid</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unionMemberSchema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">"No Value"</td>
        <td class="col-md-9">An org.jdom.Element with no children (not even Text nodes) is the representation of an element with "no value".</td>
      </tr>
      <tr>
        <td class="col-md-3">Augmented Infoset</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
    </table>
  </div>
  <div id="w3cdom" class="tab-pane fade">
    <table class="table">
      <tr>
        <td class="col-md-3">Document Information Item</td>
        <td class="col-md-9">org.w3c.dom.Document</td>
      </tr>
      <tr>
        <td class="col-md-3">root</td>
        <td class="col-md-9">org.w3c.dom.Node getFirstChild()</td>
      </tr>
      <tr>
        <td class="col-md-3">dfdlVersion</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">schema (reserved for future use)</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unicodeByteOrderMark</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">Element Information Item</td>
        <td class="col-md-9">org.w3c.dom.Element</td>
      </tr>
      <tr>
        <td class="col-md-3">namespace</td>
        <td class="col-md-9">String getNamespaceURI()</td>
      </tr>
      <tr>
        <td class="col-md-3">name</td>
        <td class="col-md-9">String getNodeName() if getNamespaceURI() == null, String getLocalName() otherwise</td>
      </tr>
      <tr>
        <td class="col-md-3">document</td>
        <td class="col-md-9">org.jdom.Document getOwnerDocument()</td>
      </tr>
      <tr>
        <td class="col-md-3">datatype</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">dataValue</td>
        <td class="col-md-9">
          For simple types other than xs:string, the canonical
          XML representation of the value as returned by String getWholeText(). See <a
          href="#xml-illegal-characters">XML Illegal Characters</a> for xs:string
          types containing XML illegal characters.
        </td>
      </tr>
      <tr>
        <td class="col-md-3">nilled</td>
        <td class="col-md-9">The "nilled" attribute in the "xsi" namespace.</td>
      </tr>
      <tr>
        <td class="col-md-3">children</td>
        <td class="col-md-9">org.w3c.dom.NodeList getChildNodes()</td>
      </tr>
      <tr>
        <td class="col-md-3">parent</td>
        <td class="col-md-9">org.w3c.dom.Node getParentNode()</td>
      </tr>
      <tr>
        <td class="col-md-3">schema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">valid</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unionMemberSchema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">"No Value"</td>
        <td class="col-md-9">An org.w3c.dom.Element with no children (not even Text nodes) is the representation of an element with "no value".</td>
      </tr>
      <tr>
        <td class="col-md-3">Augmented Infoset</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
    </table>
  </div>
  <div id="scalanode" class="tab-pane fade">
    <table class="table">
      <tr>
        <td class="col-md-3">Document Information Item</td>
        <td class="col-md-9">The document is represented by the root element. There is no separate document item.</td>
      </tr>
      <tr>
        <td class="col-md-3">root</td>
        <td class="col-md-9"><i>not supported</i></td>
      </tr>
      <tr>
        <td class="col-md-3">dfdlVersion</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">schema (reserved for future use)</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unicodeByteOrderMark</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">Element Information Item</td>
        <td class="col-md-9">scala.xml.Elem</td>
      </tr>
      <tr>
        <td class="col-md-3">namespace</td>
        <td class="col-md-9">def namespace: String</td>
      </tr>
      <tr>
        <td class="col-md-3">name</td>
        <td class="col-md-9">def name: String</td>
      </tr>
      <tr>
        <td class="col-md-3">document</td>
        <td class="col-md-9"><i>not supported</i></td>
      </tr>
      <tr>
        <td class="col-md-3">datatype</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">dataValue</td>
        <td class="col-md-9">
          For simple types other than xs:string, the canonical
          XML representation of the value as returned by def text: String. See <a
          href="#xml-illegal-characters">XML Illegal Characters</a> for xs:string
          types containing XML illegal characters.
        </td>
      </tr>
      <tr>
        <td class="col-md-3">nilled</td>
        <td class="col-md-9">The "nilled" attribute in the "xsi" namespace.</td>
      </tr>
      <tr>
        <td class="col-md-3">children</td>
        <td class="col-md-9">def child: Node*</td>
      </tr>
      <tr>
        <td class="col-md-3">parent</td>
        <td class="col-md-9"><i>not supported</i></td>
      </tr>
      <tr>
        <td class="col-md-3">schema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">valid</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unionMemberSchema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">"No Value"</td>
        <td class="col-md-9">A scala.xml.Elem with no children.</td>
      </tr>
      <tr>
        <td class="col-md-3">Augmented Infoset</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
    </table>
  </div>
  <div id="xmltext" class="tab-pane fade">
    <table class="table">
      <tr>
        <td class="col-md-3">Document Information Item</td>
        <td class="col-md-9">The full text is the document.</td>
      </tr>
      <tr>
        <td class="col-md-3">root</td>
        <td class="col-md-9">The first XML tag in the document.</td>
      </tr>
      <tr>
        <td class="col-md-3">dfdlVersion</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">schema (reserved for future use)</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unicodeByteOrderMark</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">Element Information Item</td>
        <td class="col-md-9">An XML tag</td>
      </tr>
      <tr>
        <td class="col-md-3">namespace</td>
        <td class="col-md-9">Defined using standard XML namespacing (e.g. xmlns="..." and element prefixes)</td>
      </tr>
      <tr>
        <td class="col-md-3">name</td>
        <td class="col-md-9">XML tag name</td>
      </tr>
      <tr>
        <td class="col-md-3">document</td>
        <td class="col-md-9">The full text is the document</td>
      </tr>
      <tr>
        <td class="col-md-3">datatype</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">dataValue</td>
        <td class="col-md-9">
          For simple types other than xs:string, the canonical
          XML representation of the value inside the opening/closing XML tags. See <a
          href="#xml-illegal-characters">XML Illegal Characters</a> for xs:string
          types containing XML illegal characters.
        </td>
      </tr>
      <tr>
        <td class="col-md-3">nilled</td>
        <td class="col-md-9">The "nilled" attribute in the "xsi" namespace.</td>
      </tr>
      <tr>
        <td class="col-md-3">children</td>
        <td class="col-md-9">Child XML tags</td>
      </tr>
      <tr>
        <td class="col-md-3">parent</td>
        <td class="col-md-9">Parent XML tags</td>
      </tr>
      <tr>
        <td class="col-md-3">schema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">valid</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unionMemberSchema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">"No Value"</td>
        <td class="col-md-9">An XML tag with no content in between the opening and closing tags</td>
      </tr>
      <tr>
        <td class="col-md-3">Augmented Infoset</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
    </table>
  </div>
  <div id="json" class="tab-pane fade">
    <table class="table">
      <tr>
        <td class="col-md-3">Document Information Item</td>
        <td class="col-md-9">The full text is the document, containing a JSON single object.</td>
      </tr>
      <tr>
        <td class="col-md-3">root</td>
        <td class="col-md-9">The first (and only) JSON string in the doucment object.</td>
      </tr>
      <tr>
        <td class="col-md-3">dfdlVersion</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">schema (reserved for future use)</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unicodeByteOrderMark</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">Element Information Item</td>
        <td class="col-md-9">The first JSON string in an object.</td>
      </tr>
      <tr>
        <td class="col-md-3">namespace</td>
        <td class="col-md-9"><i>not supported</i></td>
      </tr>
      <tr>
        <td class="col-md-3">name</td>
        <td class="col-md-9">The first JSON string in an object.</td>
      </tr>
      <tr>
        <td class="col-md-3">document</td>
        <td class="col-md-9">The full text is the document</td>
      </tr>
      <tr>
        <td class="col-md-3">datatype</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">dataValue</td>
        <td class="col-md-9">
          For simple types other than xs:string, the canonical XML representation
          of the value inside double quotes. For xs:string types, a JSON escaped
          string in double quotes.
        </td>
      </tr>
      <tr>
        <td class="col-md-3">nilled</td>
        <td class="col-md-9">The value of the element is <i>null</i></td>
      </tr>
      <tr>
        <td class="col-md-3">children</td>
        <td class="col-md-9">Child JSON objects</td>
      </tr>
      <tr>
        <td class="col-md-3">parent</td>
        <td class="col-md-9">Parent JSON tags</td>
      </tr>
      <tr>
        <td class="col-md-3">schema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">valid</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">unionMemberSchema</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
      <tr>
        <td class="col-md-3">"No Value"</td>
        <td class="col-md-9">The value of the element is empty double quotes.</td>
      </tr>
      <tr>
        <td class="col-md-3">Augmented Infoset</td>
        <td class="col-md-9"><i>not yet implemented</i></td>
      </tr>
    </table>
  </div>
</div>

### XML Illegal Characters

Since DFDL strings can contain characters that are not allowed in XML at all,
for the XML based representations, these characters are mapped into the Unicode
Private Use Areas (PUA). This is similar to the scheme used by Microsoft
Visio (See: <a href="https://msdn.microsoft.com/en-us/library/office/aa218415%28v=office.10%29.aspx">https://msdn.microsoft.com/en-us/library/office/aa218415%28v=office.10%29.aspx</a>),
but extended to handle all the XML 1.0 illegal characters including those
with 16-bit codepoint values. This mapping is used bi-directionally, that is,
illegal characters are replaced by their legal counterparts when parsing, and
the reverse transformation is performed when unparsing, thereby allowing the
creation of data streams containing the XML illegal characters from legal XML
documents that contain only the mapped PUA corresponding characters.

These are the legal XML characters (for XML v1.0):

```
 #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF] 
```
All other characters are illegal.
Illegal characters from ``#x00`` to ``#x1F`` are mapped to the PUA
by adding ``#xE000`` to their character code. Hence, the NUL (#x0) character code becomes #xE000.

Illegal characters from ``#xD800`` to ``#xDFFF`` are mapped to the PUA by adding
``#x1000`` to their character code. So ``#xD800`` maps to ``#xE800``, and
``#xDFFF`` maps to ``#xEFFF``.

Illegal characters ``#xFFFE`` and ``#xFFFF`` are mapped to the PUA by
subtracting ``#x0F00`` from their character code, so to characters ``#xF0FE``
and ``#xF0FF``.

The legal character ``#xD`` (Carriage Return or CR) is mapped to ``#xA`` (Line Feed, or
LF). The CR character is allowed in the textual representation of XML
documents, but is always converted to LF in the XML Infoset. That is, it is
read by XML processors, but CRLF is converted to just LF, and CR alone is
converted to LF. Daffodil is in a sense a different 'reader' of data into the
XML infoset, so to be consistent with XML we map CR and CRLF to LF. 

It is a processing error when parsing if the data-stream contains
characters in the parts of the PUA used by this mapping for illegal XML
codepoints. When unparsing, the characters such as #xE000 found in the infoset string values are mapped back to the corresponding illegal character code points (#xE000 becomes #x0, aka NUL).

The XML for an infoset can embed the #xE000 character or any of the other "illegal" characters mapped into the PUA conveniently by use of XSD numeric character entities such as "&amp;#xE000;". This is turned into the #xE000 code point when the XML document is loaded. Daffodil will then map this when unparsing, to #x0 (aka NUL). 

It is a processing error if any DFDL infoset string character is created with a
character code greater than ``#x10FFFF``.
