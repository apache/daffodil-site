---
layout: page
title: VS Code Extension
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

The Apache Daffodil™ Extension for Visual Studio Code is an extension to the Microsoft® Visual Studio Code (VS Code) editor, designed for Data Format Description Language 1.0 (DFDL) Schema developers. The purpose of the Apache Daffodil™ Extension for Visual Studio Code is to ease the burden on DFDL Schema developers by enabling rapid development of high-quality DFDL Schemas, with syntax highlighting, code completion, data file editing, and debugging of DFDL Schema parsing operations using Apache Daffodil™.

# Usage

Please refer to the [Apache Daffodil™ Extension for Visual Studio Code Wiki pages](https://github.com/apache/daffodil-vscode/wiki).

# Releases

All recent Apache Daffodil™ Extension for Visual Studio Code releases are listed here. Each release below is listed by the version and date on which it was released. Clicking on the version number will take you to the release notes and downloads for that release.

{% assign releases = site.vscode  | where: 'release', 'final' | where: 'apache', 'true' | sort: 'date' %}
{% if releases.size > 0 %}
<table class="table">
    <tr>
        <th class="col-md-1">Version</th>
        <th>Summary</th>
        <th class="col-md-2 text-right">Release&nbsp;Date</th>
    </tr>
    {% for release in releases reversed %}
        {% if release.title %}
            <tr>
                <td style="vertical-align: middle; line-height: 2.5em;" class="col-md-1"><a href="{{ release.url | prepend: site.baseurl }}">{{ release.title }}</a></td>
                <td style="vertical-align: middle;">{{ release.summary }}</td>
                <td style="vertical-align: middle;" class="col-md-2 text-right">{{ release.date | date: "%Y-%m-%d" }}</td>
            </tr>
        {% endif %}
    {% endfor %}
</table>
{% else %}
<div class="alert alert-warning">
No official Apache releases have been made yet. <a href="/community">Get involved</a> and help us on our way!
</div>
{% endif %}
