---
layout: page
group: nav-right
title: "Example Document"
date: "2025-10-10"
docRel: "A"
watermark: "DRAFT"   # <-- comment out this line to remove watermark
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

<!-- Table of contents -->
<!-- XPANDOC:BEGIN --> 
<!--
\newpage
\tableofcontents
--> 
<!-- XPANDOC:END -->

<!-- 
Version History

Pandoc does not do markdown normal tables with grid rules
So we are using regular latex for this table. 
-->

<!-- XPANDOC:BEGIN -->
<!--
\newpage
\section*{Version History}
\begin{center}
\begin{tabularx}{\textwidth}{|Y|Y|Y|Y|Y|}
\hline
\textbf{Description} & \textbf{Rev} & \textbf{Date yyyy-mm-dd} & \textbf{Author} & \textbf
{Comments} \\
\hline
Version 0.0.1 & Rev A & 2025-10-10 &  \\
\hline
&  &  &  &  \\
\hline
&  &  &  &  \\
\hline
\end{tabularx}
\end{center}
\newpage
-->
<!-- XPANDOC:END -->

# Overview

Some overview paragraph here.

#### Notices

This schema, including all its components, might need notification statements. 


# New Features

- Something
  - Sub bullet 
    - sub sub bullet
    - sub sub bullet
    
# Issues Fixed

- This could be an issue

# Dependencies

- Apache Daffodil[^fn1][versions 3.11.0, 3.10.0, 3.9.0, 3.8.0, 3.7.0, and 3.6.0](https://daffodil.
  apache.org/releases)
- The [sbt-daffodil plugin version 1.6.0](https://daffodil.apache.org/sbt) or higher

<!-- PANDOC:BEGIN -->
<!--
\newpage
-->
<!-- PANDOC:END -->

[^fn1]: This is just a footnote example. You do not need to footnote things to specify that they are apache trademarks. That's in the footer of each page. 
