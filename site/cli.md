---
layout: page
title: Command Line Interface
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

## Command Line Interface

The binary Daffodil [releases](/releases) contain a ``/bin`` directory that contains two scripts: ``daffodil.bat`` for Windows and ``daffodil`` for Linux. These files must be executed on the command line. The general usage is:

    daffodil [GLOBAL_OPTIONS] <subcommand> [SUBCOMMAND_OPTIONS]

The available subcommands are: [parse](#parse-subcommand), [unparse](#unparse-subcommand), [save-parser](#save-parser-subcommand), [test](#test-subcommand), and [performance](#performance-subcommand).

### Environment Variables

Setting environment variables may be necessary to allow for importing/includes to work and when running TDML files.

``DAFFODIL_CLASSPATH``

   : The Daffodil CLI will look on the classpath for includes and imports, jars containing schemas, and some TDML files. To define additional directories specific to Daffodil to look for files, set the ``DAFFODIL_CLASSPATH`` environment variable, for example:

         $ export DAFFODIL_CLASSPATH="/path/to/imports/:/path/to/includes/"

     In addition to defining directories to search for imports and includes, you can add a CatalogManager.properties file to the ``DAFFODIL_CLASSPATH`` to direct Daffodil to a relative path location of a user XML Catalog.

``DAFFODIL_JAVA_OPTS``

   : If you need to specify java options specific to Daffodil, you can set the ``DAFFODIL_JAVA_OPTS`` environment variable. If not specified, the ``JAVA_OPTS`` environment variable will be used. If that is not specified, reasonable defaults for Daffodil will be used.

### Global Options

``-d, --debug [FILE]``

   : Enable the interactive debugger. See the [Interactive Debugger](/debugger) documentation for more information.

     The optional ``FILE`` argument contains a list of debugger commands that are provided to the debugger as they were typed by the user.

     This option cannot be used with the ``--trace`` option.

``-t, --trace``

   : Enable a trace mode. This mode prints out helpful information during every stage of parsing.

     This option cannot be used with the ``--debug`` option.

``-v, --verbose``

   : Enable verbose mode and increment verbosity level. Each additional v provides a new level of information.

``--version``

   : Display the version of Daffodil.

``--help``

   : Display help message.

### Parse Subcommand

Parse a file, using either a DFDL schema or a saved parser.

#### Usage

    daffodil parse (-s <schema> [-r [{<namespace>}]<root>] [-p <path>] | -P <parser>)
                   [-D[{namespace}]<variable>=<value>...] [-T<tunable>=<value>] [-o <output>]
                   [-V [mode]] [-c <file>] [-I <infoset_type>] [infile]

#### Options

``-c, --config FILE``

   : XML file containing configuration items, such as external variables or Daffodil tunables. See [Configuration](/configuration) for details on the file format.

``-D [{NAMESPACE}]VARIABLE=VALUE``

   : Variables to be used when parsing. ``VARIABLE`` can be prefixed with ``{NAMESPACE}`` to define which namespace the variable belongs in, for example:

     ```-D{http://example.com}var1=var```

``-I, --infoset-type TYPE``

   : Infoset type to output. ``TYPE`` must be one of ``xml``, ``scala-xml``, ``json``, ``jdom``, or ``null``. Defaults to ``xml`` if not provided.

``-o, --output FILE``

   : Write output to a given ``FILE``. If the option is not given or ``FILE`` is -, output is written to standard out.

``-P, --parser FILE``

   : Use a previously saved parser, created using the save-parser subcommand. This option cannot be used with the ``--schema`` option or with the ``--validate`` option set to ``on``.

``-p, --path PATH``

   : The path to the node from the root element to create the parser from.

``-r, --root [{NAMESPACE}]ROOT``

   : The root element of the DFDL schema to use. This must be one of the top-level elements of the schema defined with ``--schema``. This requires the ``--schema`` option to be defined. If not supplied, the first element of the schema defined with ``--schema`` is used. A namespace may be specified by prefixing ``ROOT`` with ``{NAMESPACE}``.

``-s, --schema FILE``

   : The annotated DFDL schema to use to create the parser. This option cannot be used with the ``--parser`` option.

``--stream``

   : Rather than throwing an error when left over data exists after a parse, repeat the parse with the remaining data. Parsing repeats until end of data is reached, an error occurs, or no data is consumed. Output infosets are separated by a NUL character.

``-T TUNABLE=VALUE``

   : Modify Daffodil configuration options to change parsing behavior. See [Configuration](/configuration) for the list of tunable parameters.

``-V, --validate [MODE]``

   : The validation mode. ``MODE`` must be one of ``on``, ``limited`` or ``off``. If ``MODE`` is not provided, defaults to ``on``. If ``--validate`` is not provided, defaults to ``off``. ``MODE`` cannot be ``on`` when used with the ``--parser`` option.

``[INFILE]``

   : Input file to parse. If not specified, or is a value of -, reads from standard in. If supplied, this must be the last option on the command line.

``--help``

   : Display help message.

#### Example

    $ daffodil parse -s csv.dfdl.xsd test_file.csv

### Unparse Subcommand

Unparse an infoset file, using either a DFDL schema or a saved parser.

#### Usage

    daffodil unparse (-s <schema> [-r [{<namespace>}]<root>] [-p <path>] | -P <parser>)
                     [-D[{<namespace>}]<variable>=<value>...] [-T<tunable>=<value>] [-o <output>]
                     [-V [mode]] [-c <file>] [-I <infoset_type>] [infile]

#### Options

``-c, --config FILE``

   : XML file containing configuration items, such as external variables or Daffodil tunables. See [Configuration](/configuration) for details on the file format.

``-D [{NAMESPACE}]VARIABLE=VALUE``

   : Variables to be used when unparsing. ``VARIABLE`` can be prefixed with ``{NAMESPACE}`` to define which namespace the variable belongs in, for example:

     ```-D{http://example.com}var1=var```

``-I, --infoset-type TYPE``

   : Infoset type to unparse. ``TYPE`` must be one of ``xml``, ``scala-xml``, ``json``, or ``jdom``. Defaults to ``xml`` if not provided.

``-o, --output FILE``

   : Write output to a give ``FILE``. If the option is not given or ``FILE`` is -, output is written to standard out.

``-P, --parser FILE``

   : Use a previously saved parser, created using the save-parser subcommand. This option cannot be used with the ``--schema`` option or with the ``--validate`` option set to ``on``.

``-p, --path PATH``

   : The path to the node from the root element to create the parser from.

``-r, --root [{NAMESPACE}]ROOT``

   : The root element of the DFDL schema to use. This must be one of the top-level elements of the schema defined with ``--schema``. This requires the ``--schema`` option to be defined. If not supplied, the first element of the schema defined with ``--schema`` is used. A namespace may be specified by prefixing the ``ROOT`` with {NAMEAPSCE}.

``-s, --schema FILE``

   : The annotated DFDL schema to use to create the parser. This option cannot be used with the ``--parser`` option.

``--stream``

   : Split the input data at NUL characters and unparse each chunk separately to the same output file.

``-T TUNABLE=VALUE``

   : Modify Daffodil configuration options to change parsing behavior. See [Configuration](/configuration) for the list of tunable parameters.

``-V, --validate [MODE]``

  : The validation mode. ``MODE`` must be one of ``on``, ``limited`` or ``off``. If ``MODE`` is not provided, defaults to ``on``. If ``--validate`` is not provided, defaults to ``off``. ``MODE`` cannot be ``on`` when used with the ``--parser`` option.

``[INFILE]``

   : Input file to unparse. If not specified, or is a value of -, reads from standard in. If supplied, this must be the last option on the command line.

``--help``
   : Display help message.

#### Example

    $ daffodil unparse -s csv.dfdl.xsd test_file.infoset

### Save Parser Subcommand

Save a parser that can be reused for parsing and unparsing.

#### Usage

    daffodil save-parser -s <schema> [-r [{namespace}]<root>] [-p <path>] [outfile]

#### Options

``-c, --config FILE``

   : XML file containing configuration items, such as external variables or Daffodil tunables. See [Configuration](/configuration) for details on the file format.

``-D [{NAMESPACE}]VARIABLE=VALUE``

   : Variables to be used when parsing. ``VARIABLE`` can be prefixed with ``{NAMESPACE}`` to define which namespace the variable belongs in, for example:

     ```-D{http://example.com}var1=var```

``-p, --path PATH``

   : The path to the node from the root element to create the parser from.

``-r, --root [{NAMESPACE}]ROOT``

   : The root element of the DFDL schema to use. This must be one of the top-level elements of the schema defined with ``--schema``. This requires the ``--schema`` option to be defined. If not supplied, the first element of the schema defined with ``--schema`` is used. A namespace may be specified by prefixing ``ROOT`` with ``{NAMESPACE}``.

``-s, --schema FILE``

   : The annotated DFDL schema to use to create the parser. This option must be supplied.

``-T TUNABLE=VALUE``

   : Modify Daffodil configuration options to change parsing behavior. See [Configuration](/configuration) for the list of tunable parameters.

``-V, --validate MODE``

   : The validation mode. ``MODE`` must be either ``limited`` or ``off``. ``MODE`` is required. If ``--validate`` is not present, defaults to ``off``. ``MODE`` cannot be set to ``on`` as possible in other commands.

``[OUTFILE]``

   : Write the parser to a give file. If the option is not given or is -, output is written to standard out. If supplied, this must be the last option on the command line.

``--help``

   : Display help message.

#### Example

    $ daffodil save-parser -s csv.dfdl.xsd csv_parser.xml

### Test Subcommand

List or execute tests in a TDML file.

#### Usage

    daffodil test [-l] [-r] [-i] <tdmlfile> [testname...]

#### Options

``-i, --info``

   : Increment test result information output level, one level for each occurrence of -i.

``-l, --list``

   : Show names and descriptions in a TDML file instead of running them.

``-r, --regex``

   : Treat ``TESTNAME``s as regular expressions.

``TDMLFILE``

   : Test Data Markup Language (TDML) file.

``[TESTNAME...]``

   : Name of one or more test case in the TDML file. If not given, all tests in ``TDMLFILE`` are run.

``--help``

   : Display help message.

#### Example

    $ daffodil test csv.tdml

### Performance Subcommand

Run a performance test (parse or unparse), using either a DFDL schema or a saved parser

#### Usage

    daffodil performance (-s <schema> [-r [{namespace}]<root>] [-p <path>] |  -P <parser)
                         [-u] [-V[mode]] [-N <number>] [-t <threads>]
                         [-D[{namespace}]<variable>=<value>] [-I <infoset_type>] <infile>

#### Options

``-c, --config FILE``

   : XML file containing configuration items, such as external variables or Daffodil tunables. See [Configuration](/configuration) for details on the file format.

``-D [{NAMESPACE}]VARIABLE=VALUE``

   : Variables to be used when parsing. ``VARIABLE`` can be prefixed with ``{NAMESPACE}`` to define which namespace the variable belongs in, for example:

     ```-D{http://example.com}var1=var```

``-I, --infoset-type TYPE``

   : Infoset type to parse/unparse. ``TYPE`` must be one of ``xml``, ``scala-xml``, ``json``, ``jdom``, or ``null``. Defaults to ``xml`` if not provided. Note that ``null`` is not valid if the ``--unparse`` option is provided.

``-N, --number NUMBER``

   : Total number of files to process. Defaults to 1.

``-P, --parser FILE``

   : Use a previously saved parser, created using the save-parser subcommand. This option cannot be used with the ``--schema`` option or with the ``--validate`` option set to ``on``.

``-p, --path PATH``

   : The path to the node from the root element to create the parser from.

``-r, --root [{NAMESPACE}]ROOT``

   : The root element of the DFDL schema to use. This must be one of the top-level elements of the schema defined with ``--schema``. This requires the ``--schema`` option to be defined. If not supplied, the first element of the schema defined with ``--schema`` is used. A namespace may be specified by prefixing ``ROOT`` with ``{NAMESPACE}``.

``-s, --schema FILE``

   : The annotated DFDL schema to use to create the parser. This option cannot be used with the ``--parser`` option.

``-t, --threads THREADS``

   : The number of threads to use. Defaults to 1.

``-T TUNABLE=VALUE``

   : Modify Daffodil configuration options to change processing behavior. See [Configuration](/configuration) for the list of tunable parameters.

``-u, --unparse``

   : Perform unparse instead of parse for performance.

``-V, --validate [MODE]``

   : The validation mode. ``on``, ``limited`` or ``off``. If ``MODE`` is not provided, defaults to ``on``. If ``--validate`` is not provided, defaults to ``off``. ``MODE`` cannot be ``on`` when used with the ``--parser`` option.

``[INFILE]``

   : Input file or directory containing files to process

``--help``

   : Display help message.

#### Example

    $ daffodil performance -s csv.dfdl.xsd -N 1000 -t 5 test_file.csv
