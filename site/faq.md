---
layout: page
title: Frequently Asked Questions
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

<style type="text/css">
.in, .collapsing {
	margin-left: 20px;
}
.question {
	cursor: pointer;
}
</style>

## Frequently Asked Questions

{% assign faqNum=faqNum | plus:'1'  %}
<a class="question" data-toggle="collapse" data-target="#faq{{faqNum}}">
  Q: When should I use an XSD facet like maxLength, and when should I use the DFDL length property?
</a>
<div id="faq{{faqNum}}" class="collapse" markdown="1">
Here's part of an example from the DFDL tutorial of a street address:

``` xml
<xs:element name="houseNumber" type="xs:string" dfdl:lengthKind="explicit" dfdl:length="6"/>
```

Note that the length of the house number is constrained with DFDL.  XSD can also be used to constrain lengths.

When should you used XSD to do this, and when should you use DFDL?  Should you ever use both? 

You must use the dfdl:length property, because it can't parse the data without it. You may use the XSD facets to check further, and it often makes sense to use both.

Consider

``` xml
<xs:element name="article" type="xs:string" dfdl:length="{ ../header/articleLength }" dfdl:lengthKind='explicit'/>
```

Now the length is coming from a field someplace at runtime. Validating that it is within some additional constraints on maxLength might be very valuable. To do that you nave to write the more verbose:

``` xml
<xs:element name="article" dfdl:length="{ ../header/articleLength }" dfdl:lengthKind='explicit'>
  <xs:simpleType>
    <xs:restriction base="xs:string">
      <xs:maxLength value="140"/>
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

Not too bad actually. And if you can reuse some simple type definitions it's not bad at all.

One further point. Suppose you want to parse the string using the header-supplied length, but it's flat out a parse error if the length turns out to be greater than 140. You can ask the DFDL processor to check the facet maxLength at parse time using an assertion like this:

``` xml
<xs:element name="article" dfdl:length="{ ../header/articleLength }" dfdl:lengthKind='explicit'>
  <xs:simpleType>
    <xs:annotation><xs:appinfo source="http://www.ogf.org/dfdl/dfdl-1.0">
       <dfdl:assert>{ dfdl:checkConstraints() }</dfdl:assert>
    </xs:appinfo></xs:annotation>
    <xs:restriction base="xs:string">
      <xs:maxLength value="140"/>
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

The dfdl:assert statement annotation calls a built-in DFDL function called dfdl:checkConstraints, which tells DFDL to test the facet constraints and issue a parse error if they are not satisfied. This is particularly useful for enumeration constraints where an element value is an identifier of some sort.
</div>




{% assign faqNum=faqNum | plus:'1'  %}
<a class="question" data-toggle="collapse" data-target="#faq{{faqNum}}">
  Q: Should I use dfdl:assert to validate while parsing?
</a>
<div id="faq{{faqNum}}" class="collapse" markdown="1">
In general, no. The dfdl:assert statement annotation should be used to guide the parser. It should test things that must be true in order to successfully parse the data and create an Infoset from it.

But, it should not be used to ensure validation of the values of the data elements.

By way of illustrating what not to do, it is tempting to put facet constraints on simple type definitions in your schema, and then use a dfdl:assert like this:

```xml
<dfdl:assert>{ checkConstraints(.) }</dfdl:assert>
```

so that the parser will validate as it parses, and will fail to parse values that do not satisfy the facet constraints.

Don't do this. Your schema will not be as useful because it will not be able to be used for some applications, for example, applications that want to accept well-formed, but invalid data and analyze, act,  or report on the invalid aspects.

In some sense, embedding checks like this into a DFDL schema is second-guessing the application's needs, and assuming the application does not even want to successfully parse and create an infoset from data that does not obey the facet constraints.
</div>





{% assign faqNum=faqNum | plus:'1'  %}
<a class="question" data-toggle="collapse" data-target="#faq{{faqNum}}">
  Q: How do I prevent my DFDL expressions and regular expressions from being modified by my XML editor?
</a>
<div id="faq{{faqNum}}" class="collapse" markdown="1">
Use CDATA with expressions and regular expressions, and generally to stop XML editors from messing with your DFDL schema layouts.

Most XML editors will wrap long lines. So your

``` xml
<a>foobar</a>
```

just might get turned into

``` xml
<a>foobar
</a>
```

Now most of the time that is fine. But sometimes the whitespace really matters. One such place is when you type a regular expression. In DFDL this can come up in this way:

``` xml
<dfdl:assert testKind="pattern"> *</dfdl:assert>
```

Now the contents of that element is " \*", i.e., a single space, and the "\*" character. That means zero or more spaces in regex language. If you don't want your XML tooling to mess with the whitespace do this instead:

``` xml
<dfdl:assert testKind="pattern"><![CDATA[ *]]></dfdl:assert>
```

CDATA informs XML processors that you very much care about this. Any decent XML tooling/editor will see this and decide it cannot line-wrap this or in any way mess with the whitespace. Also useful if you want to write a complex DFDL expression in the expression language, and you want indentation and lines to be respected. Here's an example:

``` xml
<dfdl:discriminator><![CDATA[{
    if (daf:trace((daf:trace(../../ex:presenceBit,"presenceBit") = 0),"pbIsZero")) then false()
    else if
    (daf:trace(daf:trace(dfdl:occursIndex(),"occursIndex") = 1,"indexIsOne")) then true()
    else if
    (daf:trace(daf:trace(xs:int(daf:trace(../../ex:A1[daf:trace(dfdl:occursIndex()-1,"indexMinusOne")],
                                       "occursIndexMinusOneNode")/ex:repeatBit),
                       "priorRepeatBit") = 0,
              "priorRepeatBitIsZero"))
    then false()
    else true() 
}]]></dfdl:discriminator>
```

If you get done writing something very deeply nested like this (and XPath style languages require this all the time), then you do NOT want anything messing with the whitespace.

About the xml:space='preserve' attribute: According to this thread on the stack overflow web site, xml:space is only about whitespace-only nodes, not nodes that are part whitespace. Within element-only content, the text nodes found between the elements are whitespace-only nodes. Unless you use xml:space='preserve', those are eliminated. None of the above discussion is about whitespace-only nodes. It's about value nodes containing text strings with surrounding whitespace.
</div>



{% assign faqNum=faqNum | plus:'1'  %}
<a class="question" data-toggle="collapse" data-target="#faq{{faqNum}}">
  Q: Why doesn't DFDL allow me to express my format using offsets into a file, instead of lengths?
</a>
<div id="faq{{faqNum}}" class="collapse" markdown="1">
With some study, the DFDL workgroup concluded that these formats nearly always require the full complexity of a transformation system AND a data format description system. DFDL is only about the latter problem.

In other words, it was left out for complexity reasons, not because we didn't think there were examples.

It is a much more complex issue than people think. As we got into it we kept falling down the slippery slope of needing rich transformations to express such things.

We certainly have seen formats where there are a bunch of fields, in the ordinary manner, but instead of expressing their lengths, the forrmat specifies only their starting positions relative to start of record. There are also formats where there are tables of offsets into a subsequent data array.

DFDL requires one to recast such a specification as lengths.

It is not a "either or" scenario where lengths and offsets are equivalent so you can pick one.

Use of lengths is simply a superior and more precise way of expressing the format because use of offsets can obscure aliasing, which is the term for when there are two elements (or more) that describe the same part of the data representation. With lengths, it's clear what every bit means, and that every bit is in fact described or explicitly skipped. You can't just use an offset to skip past a bunch of data leaving it not described at all. You can't have aliasing of the same data.

Aliasing is a difficult issue when parsing. When unparsing it is a nightmare, as it introduces non-determinacy in what the data written actually comes out like. It depends on who writes it last with what alias.

Structures like

    <offset to start><length of thing>
    <offset to start2><length of thing2>
    ...
    <offset to startN><length of thingN>
    thing
    thing2
    ...
    thingN

So long as the things and the corresponding descriptor pairs are in order, these can be described. The lengths need not even be there as they are redundant. If present they can be checked for validity. Overlap can be checked for and deemed invalid.

But, in DFDL the above *must* be represented as two vectors. One of the offsets table, the other of the things. If you want an array of things and then want DFDL to convert that into the offsets and things separately, well DFDL doesn't do transformations of that sort. Do that first in XSLT or other transformation system when unparsing. When parsing, you first parse with DFDL, then transform the data into the logical single vector using XSLT (or other).

<div class="alert alert-warning">
XProc is a language for expressing chains of XML-oriented transformations like this. Calabash is an open-source XProc implementation, and the daffodil-calabash-extension provides Daffodil stages that have been created to enable creation of XProc pipelines that glue together transformations like XSLT with DFDL parse/unparse steps. This can be used to create a unit that runs both DFDL and an XSLT together for parse or for unparse (they would be different XSLTs).
If the things are potentially out of order, especially if the lengths are not stored, but just implied by "from this offset to the start of the next one, whichever one that is", that is simply too complex a transformation for DFDL. 
</div>

If you think about what is required mentally to decode this efficiently, you must grab all the entries, sort them by offset, and then compute lengths, etc.  Shy of building a real programming language (e.g., XQuery) into DFDL there has to be a limit to what level of complexity we allow DFDL to express directly.   And unparsing is entirely non-deterministic... you have to stage an array/blob filled with fill bytes, write pieces to it one by one, potentially overwriting sections. It's really quite hard. Even if you supported this in DFDL somehow, would it in fact write these things out in the order an application does? So will you even be able to re-create data?

There is a sense in which formats expressed as these sorts of "potentially overlapping regions" are simply not adequately specified unless they specify the exact order things are to be written so that the contents of overlap regions is deterministic.

There could be formats where there are offset tables like this, where in principle things could be out of order, or overlapping/aliased, but they simply never are, and allowing them to be is effectively a bad idea as it allows people to do very obscure things - information hiding, polyglot files, etc. PDF is heavily criticized for this. It may be an unstated principle that such formats *do not* do this sort of out-of-order or aliasing stuff.

All that said, practically speaking, people have data with offset tables, and out-of-order might be a possibility that needs to be allowed at least on parsing. So what to do in DFDL?

In this case, DFDL can describe the table of offsets, and a big blob of data. Beyond that something else (e.g., XSLT, or a program) must take over for expressing the sort and extraction of chunks out of the larger blob.

If you think about this, if you want deterministic unparsing behavior, that is what has to be presented to the DFDL unparser anyway, since presenting the resolved content blob means the application has dealt with the order to which the various chunks (which may overlap) have been written.
</div>


{% assign faqNum=faqNum | plus:'1'  %}
<a class="question" data-toggle="collapse" data-target="#faq{{faqNum}}">
  Q: How can I get strings in the data to become element names?
</a>
<div id="faq{{faqNum}}" class="collapse" markdown="1">
If the data contains tags/strings, and you want those strings to become element names in XML, then you *must* do pass 1 to extract the tag information, use them as element names when you create a DFDL schema dynamically, and then parse the data again with this new specialized DFDL schema.

Or you can parse the data with a generic schema where your tag names will be in element values someplace, and do a transformation outside of DFDL to convert them to element names.

Consider the common "comma separated values" or  CSV formats. If you have

```
Name, Address, Phone
Mike, 8840 Standford Blvd\, Columbia MD, 888-888-8888
```

and you want

``` xml
<columnNames>
  <name>Name</name>
  <name>Address</name>
  <name>Phone</name>
</columnNames>
<row>
  <col>Mike</col>
  <col>8840 Standford Blvd, Columbia MD</col>
  <col>888-888-8888</col>
</row>
```
That's what you would get from a generic CSV DFDL schema. If you want this:

``` xml
<row>
  <Name>Mike</Name>
  <Address>8840 Stanford Blvd, Columbia MD</Address>
  <Phone>888-888-8888</Phone>
</row>
```

That's a specific-to-exactly-these-column-names CSV DFDL schema that is required. If you have lots of files with this exact structure you would create this DFDL schema once.

If you have no idea what CSV is coming at you, but want this sort of XML elements anyway, then you have to generate a DFDL schema on the fly from the data (parse just the headers with a generic DFDL schema first - then use that to create the DFDL schema.

Or you parse using the generic schema, then use XSLT or something to convert the result of the generic parse.

Keep in mind that this problem has little to do with DFDL. Given an XML document like the generic one above, but you didn't want that XML, you wanted the specific style XML. Well you have the same problem. You need to grab the column names first, then transform the data using them as the element names.
</div>

<!---
Copy the below snippet and edit to create a new FAQ entry, changing the
question and answer only. Everything else should remain exactly the same.

{% assign faqNum=faqNum | plus:'1'  %}
<a class="question" data-toggle="collapse" data-target="#faq{{faqNum}}">
  Q: Question Goes Here
</a>
<div id="faq{{faqNum}}" class="collapse" markdown="1">
  Answer goes here using markdown
</div>
-->
