---
layout: page
title: Releases
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

All recent Daffodil releases are listed here, along with several historical releases. Each release below is listed by the version and date on which it was released. Clicking on the version number will take you to the release notes and downloads for that release.

### Apache Releases

{% assign releases = site.releases  | where: 'released', 'true' | where: 'apache', 'true' | sort: 'date' %}
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
                <td class="col-md-1"><a href="{{ release.url | prepend: site.baseurl }}">{{ release.title }}</a></td>
                <td>{{ release.summary }}</td>
                <td class="col-md-2 text-right">{{ release.date | date: "%Y-%m-%d" }}</td>
            </tr>
        {% endif %}
    {% endfor %}
</table>
{% else %}
<div class="alert alert-warning">
No official Apache releases have been made yet. <a href="/community">Get involved</a> and help us on our way!
</div>
{% endif %}

### Pre-Apache Releases

<div class="alert alert-warning">
    All releases below are from prior to Daffodil's acceptance into
    the Incubator. They are not Apache Software Foundation releases,
    and are licensed under the <a href="https://opensource.org/licenses/NCSA">NCSA license</a>.
</div>

{% assign releases = site.releases  | where: 'released', 'true' | where: 'apache', 'false' | sort: 'date' %}
<table class="table">
    <tr>
        <th class="col-md-1">Version</th>
        <th>Summary</th>
        <th class="col-md-2 text-right">Release Date</th>
    </tr>
    {% for release in releases reversed %}
        {% if release.title %}
            <tr>
                <td class="col-md-1"><a href="{{ release.url | prepend: site.baseurl }}">{{ release.title }}</a></td>
                <td>{{ release.summary }}</td>
                <td class="col-md-2 text-right">{{ release.date | date: "%Y-%m-%d" }}</td>
            </tr>
        {% endif %}
    {% endfor %}
</table>
