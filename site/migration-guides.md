---
layout: page
title: Migration Guides
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
### Migration Guides

{% assign guides = site.pages
| where_exp: "p", "p.path contains 'migration-guides/'"
| sort: "date" %}

{% if guides.size > 0 %}
<table class="table">
  <tr>
    <th class="col-md-1">Version</th>
    <th>Summary</th>
    <th class="col-md-2 text-right">Date</th>
  </tr>
  {% for p in guides reversed %}
    {% assign version = p.version | default: p.title | replace: "Migration Guide",""
        | default: p.url | split: "/" | last | replace: ".html","" %}
    {% assign date_val = p.date | default: p.last_modified_at %}
    {% assign summary = p.summary | default: p.excerpt | default: "" %}
    <tr>
      <td style="vertical-align: middle; line-height: 2.5em;" class="col-md-1">
        <a href="{{ p.url | prepend: site.baseurl }}">{{ version }}</a>
      </td>
      <td style="vertical-align: middle;">
        {{ summary }}
      </td>
      <td style="vertical-align: middle;" class="col-md-2 text-right">
        {% if date_val %}{{ date_val | date: "%Y-%m-%d" }}{% else %}&mdash;{% endif %}
      </td>
    </tr>
  {% endfor %}
</table>
{% else %}
<div class="alert alert-warning">
No migration guides found yet. Add files under <code>migration-guides/</code> like <code>4.0.0.md</code>.
</div>
{% endif %}
