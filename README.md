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

# Apache Daffodil (incubating) Website

The Apache Daffodil (incubating) web site is based off of the [Apache Website Template](https://github.com/apache/apache-website-template).

The website is generated using [Jekyll](https://jekyllrb.com/).

# How to deploy this web site

## Install Jekyll

Some Linux distributions provide Jekyll via their package managers, for example, for Fedora 25

    $ dnf install rubygem-jekyll

Alternatively, Jekyll can be installed using gem:

    $ gem install jekyll

## Running locally

Before opening a pull request, you can preview your contributions by
running from within the directory:

    $ cd site
    $ jekyll serve --watch --source site

Open [http://localhost:4000](http://localhost:4000) to view the site served by Jekyll.

Once satisfied, create a branch and open a pull request using the Daffodil
project [Code Conttributor Workflow](https://cwiki.apache.org/confluence/display/DAFFODIL/Code+Contributor+Workflow)
but using the website repo instead of the code repo.

## Pushing to the live site

Daffodil uses [gitpubsub](https://www.apache.org/dev/gitpubsub.html) for
publishing to the website. The static content served via apache must be served
in the ``content`` directory on the ``asf-site`` orphan branch. Use the
``publish.sh`` script script exists to create this content:

    $ ./publish.sh
    $ git push asf asf-site
