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

## Testing Locally

To improve reproducibility and to minimize the effects and variability of a
users environment, it is recommended that changes to the site repo be tested
locally with a container. To do so, run one of the following commands.

With docker:

    docker run -it --rm \
      --publish 127.0.0.1:4000:4000 \
      --volume="$PWD:/srv/jekyll" \
      docker.io/jekyll/jekyll:4.2.0 \
      jekyll serve --watch --source site

With rootless podman:

    podman run -it --rm \
      --publish 127.0.0.1:4000:4000 \
      --volume="$PWD:/srv/jekyll" \
      --env JEKYLL_ROOTLESS=1 \
      docker.io/jekyll/jekyll:4.2.0 \
      jekyll serve --watch --source site

Then open [http://localhost:4000](http://localhost:4000) to view the site
served by the Jekyll container. Changes to files in the site directory are
automatically rebuilt and served.

Once satisfied, create a branch and open a pull request using the Daffodil
project [Code Conttributor Workflow](https://cwiki.apache.org/confluence/display/DAFFODIL/Code+Contributor+Workflow)
but using the website repo instead of the code repo.

## Publishing to the Live Site

Daffodil uses [gitpubsub](https://www.apache.org/dev/gitpubsub.html) for
publishing to the website. The static content served via Apache must be served
in the ``content`` directory on the ``asf-site`` orphan branch. When changes
are merged into the main branch on GitHub, a GitHub action will automatically
run and perform the necessary steps to publish the site.
