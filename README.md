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

# Apache Daffodil Website

The Apache Daffodil website is based off of the [Apache Website Template](https://github.com/apache/apache-website-template).

The website is generated using [Jekyll](https://jekyllrb.com/) and some plug-ins for it.

# How to deploy this web site

## Install Ruby Bundler

Some Linux distributions provide the Ruby Bundler via their package managers, for example, for Fedora:

    $ dnf install rubygem-bundler

## Install or Update Site Dependencies

    $ gem install

or

    $ gem update

## Install Jekyll Plug-ins for AsciiDoc and Diagram Rendering

Some content is developed using the AsciiDoc Markdown variant, which supports
embedded diagrams created from diagram-specifying text formats. 

(You probably want to install these as super-user using sudo.)

    $ apt install python-pip
    $ pip install blockdiag
    $ pip install seqdiag
    $ pip install actdiag
    $ pip install nwdiag

NOTE: `nwdiag` actually supports more than one diagram type. It supports nwdiag, packetdiag, rackdiag, etc.

## Running Locally

Before opening a pull request, you can preview your contributions by
running from within the directory:

    $ jekyll serve --watch --source site

If that fails to work due to missing jekyll plugin versions, try:

    $ bundle exec jekyll serve --watch --source site

Open [http://localhost:4000](http://localhost:4000) to view the site served by Jekyll.

Once satisfied, create a branch and open a pull request using the Daffodil
project [Code Conttributor Workflow](https://cwiki.apache.org/confluence/display/DAFFODIL/Code+Contributor+Workflow)
but using the website repo instead of the code repo.

## Pushing to the Live Site

Daffodil uses [gitpubsub](https://www.apache.org/dev/gitpubsub.html) for
publishing to the website. The static content served via apache must be served
in the ``content`` directory on the ``asf-site`` orphan branch. When the changes
are merged into the master branch on GitHub, a GitHub action will automatically
be triggered and it will perform the necessary steps to publish the site.
