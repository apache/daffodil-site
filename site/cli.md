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
<!-- markdownlint-disable line-length -->
<!-- markdownlint-disable no-duplicate-heading -->

The binary Daffodil [releases](/releases) contain a ``/bin`` directory with two scripts: ``daffodil.bat`` for Windows and ``daffodil`` for Linux. These files must be executed on the command line. The general usage is:

    daffodil [GLOBAL_OPTIONS] <subcommand> [SUBCOMMAND_OPTIONS]

The available subcommands are:

- [parse](#parse-subcommand)
- [unparse](#unparse-subcommand)
- [save-parser](#save-parser-subcommand)
- [test](#test-subcommand)
- [performance](#performance-subcommand)
- [generate](#generate-subcommand)

### Environment Variables

Setting environment variables may be necessary to allow imports, includes, and running TDML files to work.

``DAFFODIL_CLASSPATH``

   : Daffodil will search its classpath for includes and imports, jars containing schemas, and some TDML files. To tell Daffodil to look for files in additional directories, set the ``DAFFODIL_CLASSPATH`` environment variable, for example:

         export DAFFODIL_CLASSPATH="/path/to/imports/:/path/to/includes/"

     In addition to defining directories to search for imports and includes, you can add a CatalogManager.properties file to ``DAFFODIL_CLASSPATH`` to direct Daffodil to a relative path location of a user XML Catalog.

``DAFFODIL_JAVA_OPTS``

   : If you need to specify java options specific to Daffodil, you can set the ``DAFFODIL_JAVA_OPTS`` environment variable. If not specified, the ``JAVA_OPTS`` environment variable will be used. If that is not specified, reasonable defaults for Daffodil will be used.

``CC``

   : If you need to specify which C compiler should be called when running TDML files with the ``test`` subcommand using Daffodil's codegen-c backend, you can set the ``CC`` environment variable. If that environment variable is not specified, then Daffodil will call the first C compiler driver command it finds within the ``PATH`` environment variable from the following list: "zig cc", "cc", "clang", "gcc" (in that order). The reason for "zig cc" coming first is because [zig cc](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html) uses a sophisticated caching system to avoid recompiling the same C source files, which can speed up TDML tests.

### Global Options

``-d, --debug [FILE]``

   : Enable the interactive debugger. See the [Interactive Debugger](/debugger) documentation for more information.

     The optional ``FILE`` argument contains a list of debugger commands that are provided to the debugger as if they were typed by the user.

     This option cannot be used with the ``--trace`` option.

``-t, --trace``

   : Enable a trace mode. This mode prints out helpful information during every stage of parsing.

     This option cannot be used with the ``--debug`` option.

``-v, --verbose``

   : Enable verbose mode and increment verbosity level. Each additional ``-v`` provides a new level of information.

``--version``

   : Display Daffodil's version.

``-h, --help``

   : Display a help message.

### Parse Subcommand

Parse a file, using either a DFDL schema or a saved parser.

#### Usage

    daffodil parse (-s <schema> [-r <root>] | -P <parser>)
                   [-c <file>] [-D<variable>=<value>...] [-I <infoset_type>]
                   [-o <output>] [--stream] [-T<tunable>=<value>...] [-V <mode>]
                   [infile]

#### Options

``-c, --config FILE``

   : XML file containing configuration items, such as external variables or Daffodil tunables. See [Configuration](/configuration) for details on the file format.

``-D VARIABLE=VALUE``

   : Variables to be used when parsing. A namespace may be specified by prefixing ``VARIABLE`` with ``{NAMESPACE}``, for example:

     ```-D{http://example.com}var1=var```

``-I, --infoset-type TYPE``

   : Infoset type to output. ``TYPE`` must be one of ``xml``, ``scala-xml``, ``json``, ``jdom``, ``sax``, or ``null``. Defaults to ``xml`` if not provided.

``-o, --output FILE``

   : Output file to write the infoset to. If the option is not given or ``FILE`` is -, the infoset is written to standard output.

``-P, --parser FILE``

   : Use a previously saved parser inside ``FILE``, created using the ``save-parser`` subcommand. This option cannot be used with the ``--schema`` option or with the ``--validate`` option set to ``on``.

``-r, --root ROOT``

   : The root element to use. This must be one of the top-level elements of the DFDL schema defined with ``--schema``. This requires the ``--schema`` option to be defined. Defaults to the schema's first top-level element if not provided. A namespace may be specified by prefixing ``ROOT`` with ``{NAMESPACE}``.

``-s, --schema FILE``

   : The annotated DFDL schema to use to create the parser. This option cannot be used with the ``--parser`` option.

``--stream``

   : Rather than throwing an error when left over data exists after a parse, repeat the parse with the remaining data. Parsing repeats until end of data is reached, an error occurs, or no data is consumed. Output infosets are separated by a NUL character.

``--nostream``

   : Stop after the first parse, throwing an error if left over data exists. This is the default behavior.

``-T TUNABLE=VALUE``

   : Tunable configuration options to change Daffodil's behavior. See [Configuration](/configuration) for the list of tunable parameters.

``-V, --validate MODE``

   : The validation mode. ``MODE`` must be one of ``on``, ``limited``, ``off``, or a validator plugin name. Defaults to ``off`` if not provided. Validator plugins are provided by SPI and are referenced here using the ``name`` defined by the plugin. ``MODE`` cannot be ``on`` when used with the ``--parser`` option.

``[INFILE]``

   : Input file to parse. If not specified, or is a value of -, reads from standard input. If supplied, the input file must be the last option on the command line.

``-h, --help``

   : Display a help message.

#### Example

    daffodil parse -s csv.dfdl.xsd test_file.csv

### Unparse Subcommand

Unparse an infoset file, using either a DFDL schema or a saved parser.

#### Usage

    daffodil unparse (-s <schema> [-r <root>] | -P <parser>)
                     [-c <file>] [-D<variable>=<value>...] [-I <infoset_type>]
                     [-o <output>] [--stream] [-T<tunable>=<value>...] [-V <mode>]
                     [infile]

#### Options

``-c, --config FILE``

   : XML file containing configuration items, such as external variables or Daffodil tunables. See [Configuration](/configuration) for details on the file format.

``-D VARIABLE=VALUE``

   : Variables to be used when unparsing. A namespace may be specified by prefixing ``VARIABLE`` with ``{NAMESPACE}``, for example:

     ```-D{http://example.com}var1=var```

``-I, --infoset-type TYPE``

   : Infoset type to unparse. ``TYPE`` must be one of ``xml``, ``scala-xml``, ``json``, ``jdom``, or ``sax``. Defaults to ``xml`` if not provided.

``-o, --output FILE``

   : Output file to write the data to. If the option is not given or ``FILE`` is -, the data is written to standard output.

``-P, --parser FILE``

   : Use a previously saved parser inside ``FILE``, created using the ``save-parser`` subcommand. This option cannot be used with the ``--schema`` option or with the ``--validate`` option set to ``on``.

``-r, --root ROOT``

   : The root element to use. This must be one of the top-level elements of the DFDL schema defined with ``--schema``. This requires the ``--schema`` option to be defined. Defaults to the schema's first top-level element if not provided. A namespace may be specified by prefixing ``ROOT`` with ``{NAMESPACE}``.

``-s, --schema FILE``

   : The annotated DFDL schema to use to create the parser. This option cannot be used with the ``--parser`` option.

``--stream``

   : Split the input data at NUL characters and unparse each chunk separately to the same output file.

``--nostream``

   : Treat the entire input data as one infoset. This is the default behavior.

``-T TUNABLE=VALUE``

   : Tunable configuration options to change Daffodil's behavior. See [Configuration](/configuration) for the list of tunable parameters.

``-V, --validate MODE``

   : The validation mode. ``MODE`` must be one of ``on``, ``limited``, ``off``, or a validator plugin name. Defaults to ``off`` if not provided. Validator plugins are provided by SPI and are referenced here using the ``name`` defined by the plugin. ``MODE`` cannot be ``on`` when used with the ``--parser`` option.

``[INFILE]``

   : Input file to unparse. If not specified, or is a value of -, reads from standard input. If supplied, the input file must be the last option on the command line.

``-h, --help``

   : Display a help message.

#### Example

    daffodil unparse -s csv.dfdl.xsd test_file.infoset

### Save Parser Subcommand

Save a parser that can be reused for parsing and unparsing.

#### Usage

    daffodil save-parser -s <schema> [-r <root>]
                        [-c <file>] [-D<variable>=<value>...] [-T<tunable>=<value>...]
                        [outfile]

#### Options

``-c, --config FILE``

   : XML file containing configuration items, such as external variables or Daffodil tunables. See [Configuration](/configuration) for details on the file format.

``-D VARIABLE=VALUE``

   : Variables to be used when parsing or unparsing. A namespace may be specified by prefixing ``VARIABLE`` with ``{NAMESPACE}``, for example:

     ```-D{http://example.com}var1=var```

``-r, --root ROOT``

   : The root element to use. This must be one of the top-level elements of the DFDL schema defined with ``--schema``. This requires the ``--schema`` option to be defined. Defaults to the schema's first top-level element if not provided. A namespace may be specified by prefixing ``ROOT`` with ``{NAMESPACE}``.

``-s, --schema FILE``

   : The annotated DFDL schema to use to create the parser. This option must be supplied.

``-T TUNABLE=VALUE``

   : Tunable configuration options to change Daffodil's behavior. See [Configuration](/configuration) for the list of tunable parameters.

``[OUTFILE]``

   : Output file to save the parser to. If the option is not given or is -, the parser is saved to standard output. If supplied, the output file must be the last option on the command line.

``-h, --help``

   : Display a help message.

#### Example

    daffodil save-parser -s csv.dfdl.xsd csv_parser.xml

### Test Subcommand

List or execute tests in a TDML file.

#### Usage

    daffodil test [-I <implementation>] [-l] [-r] [-i] <tdmlfile> [testnames...]

#### Options

``-I, --implementation  <implementation>``

   : Implementation to run TDML tests. Choose daffodil or
     daffodilC. Defaults to daffodil.

``-i, --info``

   : Increment test result information output level, one level for each -i.

``-l, --list``

   : Show names and descriptions of test cases in a TDML file instead of running them.

``-r, --regex``

   : Treat ``TESTNAMES...`` as regular expressions.

``TDMLFILE``

   : Test Data Markup Language (TDML) file.

``[TESTNAMES...]``

   : Name(s) of test cases in the TDML file. If not given, all tests in ``TDMLFILE`` are run.

``-h, --help``

   : Display a help message.

#### Example

    daffodil test csv.tdml

### Performance Subcommand

Run a performance test (parse or unparse), using either a DFDL schema or a saved parser.

#### Usage

    daffodil performance (-s <schema> [-r <root>] | -P <parser>)
                         [-c <file>] [-D<variable>=<value>...] [-I <infoset_type>]
                         [-N <number>] [-t <threads>] [-T<tunable>=<value>...]
                         [-u] [-V <mode>]
                         <infile>

#### Options

``-c, --config FILE``

   : XML file containing configuration items, such as external variables or Daffodil tunables. See [Configuration](/configuration) for details on the file format.

``-D VARIABLE=VALUE``

   : Variables to be used when parsing or unparsing. ``VARIABLE`` can be prefixed with ``{NAMESPACE}`` to define which namespace the variable belongs in, for example:

     ```-D{http://example.com}var1=var```

``-I, --infoset-type TYPE``

   : Infoset type to output or unparse. ``TYPE`` must be one of ``xml``, ``scala-xml``, ``json``, ``jdom``, ``sax``, or ``null``. Defaults to ``xml`` if not provided. Note that ``null`` is not valid if the ``--unparse`` option is provided.

``-N, --number NUMBER``

   : The total number of files to process. Defaults to 1.

``-P, --parser FILE``

   : Use a previously saved parser inside ``FILE``, created using the ``save-parser`` subcommand. This option cannot be used with the ``--schema`` option or with the ``--validate`` option set to ``on``.

``-r, --root ROOT``

   : The root element to use. This must be one of the top-level elements of the DFDL schema defined with ``--schema``. This requires the ``--schema`` option to be defined. Defaults to the schema's first top-level element if not provided. A namespace may be specified by prefixing ``ROOT`` with ``{NAMESPACE}``.

``-s, --schema FILE``

   : The annotated DFDL schema to use to create the parser. This option cannot be used with the ``--parser`` option.

``-t, --threads THREADS``

   : The number of threads to use. Defaults to 1.

``-T TUNABLE=VALUE``

   : Tunable configuration options to change Daffodil's behavior. See [Configuration](/configuration) for the list of tunable parameters.

``-u, --unparse``

   : Perform unparse instead of parse for performance test.

``-V, --validate MODE``

   : The validation mode. ``MODE`` must be one of ``on``, ``limited``, ``off``, or a validator plugin name. Defaults to ``off`` if not provided. Validator plugins are provided by SPI and are referenced here using the ``name`` defined by the plugin. ``MODE`` cannot be ``on`` when used with the ``--parser`` option.

``INFILE``

   : Input file or directory containing input files to parse or unparse. Required argument.

``-h, --help``

   : Display a help message.

#### Example

    daffodil performance -s csv.dfdl.xsd -N 1000 -t 5 test_file.csv

### Generate Subcommand

Generate C code from a DFDL schema to parse or unparse data.

#### Usage

    daffodil generate <language> [SUBCOMMAND_OPTS]

    --- there is only one choice for <language> at this time ---

    daffodil generate c -s <schema> [-r <root>]
                        [-c <file>] [-T<tunable>=<value>...]
                        [outdir]

#### Options

``-c, --config FILE``

   : XML file containing configuration items, such as external variables or Daffodil tunables. See [Configuration](/configuration) for details on the file format.

``-r, --root ROOT``

   : The root element to use. This must be one of the top-level elements of the DFDL schema defined with ``--schema``. This requires the ``--schema`` option to be defined. Defaults to the schema's first top-level element if not provided. A namespace may be specified by prefixing ``ROOT`` with ``{NAMESPACE}``.

``-s, --schema FILE``

   : The annotated DFDL schema to use to generate C code. This option must be supplied.

``-T TUNABLE=VALUE``

   : Tunable configuration options to change Daffodil's behavior. See [Configuration](/configuration) for the list of tunable parameters.

``[OUTDIR]``

   : The output directory in which to create or replace a `c` subdirectory containing the generated C code. If the option is not given, a `c` subdirectory within the current directory will be created/replaced. If supplied, the output directory must be the last option on the command line.

``-h, --help``

   : Display a help message.

#### Example

    daffodil generate c -s csv.dfdl.xsd
