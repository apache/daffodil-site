---
layout: page
title: Examples
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


Below are two examples of how Daffodil parses Comma-Separated Values (CSV) and Packet Capture data (PCAP) data to XML. For simplicity, each example uses the Daffodil [Command Line Interface](/cli) to parse input data to output XML.

### Comma-Separated Values (CSV)

This DFDL schema is found at the DFDLSchemas GitHub [CSV repository](https://github.com/DFDLSchemas/CSV). 

```bash
$ daffodil parse --schema CSV/src/main/resources/com/tresys/csv/xsd/csv.dfdl.xsd CSV/src/test/resources/com/tresys/csv/data/simpleCSV.csv
```
The above command uses the csv.dfdl.xsd schema to parse the simpleCSV.csv input data. The simpleCSV.csv contains the following data:

```
last,first,middle,DOB
smith,robert,brandon,1988-03-24
johnson,john,henry,1986-01-23
jones,arya,cat,1986-02-19
```

The result of the parse is the following XML:

```xml
<ex:file xmlns:ex="http://example.com">
  <header>
    <title>last</title>
    <title>first</title>
    <title>middle</title>
    <title>DOB</title>
  </header>
  <record>
    <item>smith</item>
    <item>robert</item>
    <item>brandon</item>
    <item>1988-03-24</item>
  </record>
  <record>
    <item>johnson</item>
    <item>john</item>
    <item>henry</item>
    <item>1986-01-23</item>
  </record>
  <record>
    <item>jones</item>
    <item>arya</item>
    <item>cat</item>
    <item>1986-02-19</item>
  </record>
</ex:file>
```

### Packet Capture Data (PCAP)

This DFDL schema is found in the DFDLSchemas GitHub [PCAP repository](https://github.com/DFDLSchemas/PCAP).

The PCAP file format is a binary file format used to capture network packets. For information on this file format, visit the [Wireshark Libpcap File Format](http://wiki.wireshark.org/Development/LibpcapFileFormat) page.

```bash
$ daffodil parse --schema PCAP/src/main/resources/com/tresys/pcap/xsd/pcap.dfdl.xsd PCAP/src/test/resources/com/tresys/pcap/data/icmp.cap
```

The above command uses the pcap.dfdl.xsd schema to parse the icmp.cap input file. Viewed as a hex dump, the icmp.cap file looks like:

```
0000000     c3d4 a1b2 0002 0004 0000 0000 0000 0000
0000020     ffff 0000 0001 0000 6fc4 51c1 ccf8 000c
0000040     004a 0000 004a 0000 5000 e056 4914 0c00
...
0001300     0000 5c2f 0002 0024 6261 6463 6665 6867
0001320     6a69 6c6b 6e6d 706f 7271 7473 7675 6177
0001340     6362 6564 6766 6968
```

The result of the parse is the following XML:

```xml
<pcap:PCAP xmlns:pcap="urn:pcap:2.4">
  <PCAPHeader>
    <MagicNumber>D4C3B2A1</MagicNumber>
    <Version>
      <Major>2</Major>
      <Minor>4</Minor>
    </Version>
    <Zone>0</Zone>
    <SigFigs>0</SigFigs>
    <SnapLen>65535</SnapLen>
    <Network>1</Network>
  </PCAPHeader>
  <Packet>
    <PacketHeader>
      <Seconds>1371631556</Seconds>
      <USeconds>838904</USeconds>
      <InclLen>74</InclLen>
      <OrigLen>74</OrigLen>
    </PacketHeader>
    <pcap:LinkLayer>
      <pcap:Ethernet>
        <MACDest>005056E01449</MACDest>
        <MACSrc>000C29340BDE</MACSrc>
        <Ethertype>2048</Ethertype>
        <pcap:NetworkLayer>
          <pcap:IPv4>
            <IPv4Header>
              <Version>4</Version>
              <IHL>5</IHL>
              <DSCP>0</DSCP>
              <ECN>0</ECN>
              <Length>60</Length>
              <Identification>55107</Identification>
              <Flags>0</Flags>
              <FragmentOffset>0</FragmentOffset>
              <TTL>128</TTL>
              <Protocol>1</Protocol>
              <Checksum>11123</Checksum>
              <IPSrc>192.168.158.139</IPSrc>
              <IPDest>174.137.42.77</IPDest>
            </IPv4Header>
            <PayloadLength>40</PayloadLength>
            <Protocol>1</Protocol>
            <pcap:ICMPv4>
              <Type>8</Type>
              <Code>0</Code>
              <Checksum>10844</Checksum>
              <Data>02002100</Data>
            </pcap:ICMPv4>
          </pcap:IPv4>
        </pcap:NetworkLayer>
      </pcap:Ethernet>
    </pcap:LinkLayer>
  </Packet>
  ...
</pcap:PCAP>
```
