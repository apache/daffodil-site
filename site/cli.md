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

The binary Daffodil [releases](/releases) contain a `/bin` directory with two scripts: `daffodil.bat` for Windows and `daffodil` for Linux.
These files must be executed on the command line. The general usage is:

```
daffodil [GLOBAL_OPTIONS] <subcommand> [SUBCOMMAND_OPTIONS]
```

The available subcommands are:

- [parse](#parse-subcommand) - parse a file, using either a DFDL schema or a saved parser
- [unparse](#unparse-subcommand) - unparse an infoset file, using either a DFDL schema or a saved parser
- [save-parser](#save-parser-subcommand) - save a parser that can be reused for parsing and unparsing
- [test](#test-subcommand) - list or execute tests in a TDML file
- [performance](#performance-subcommand) - run a performance test (parse or unparse), using either a DFDL schema or a saved parser
- [generate](#generate-subcommand) - generate C code from a DFDL schema to parse or unparse data
- [exi](#exi) - encode or decode an XML file with Efficient XML Interchange (EXI)

# Environment Variables

Setting environment variables may be necessary to allow imports, includes, and running TDML files to work.

`DAFFODIL_CLASSPATH`

: Daffodil will search its classpath for includes and imports, and jars containing schemas and Daffodil plugins.
  To tell Daffodil to look for files in additional directories, set the `DAFFODIL_CLASSPATH` environment variable, for example:
  ```
  export DAFFODIL_CLASSPATH="/path/to/imports/:/path/to/plugins/"
  ```
  In addition to defining directories to search for imports and includes, you can add a CatalogManager.properties file to `DAFFODIL_CLASSPATH` to direct Daffodil to a relative path location of a user XML Catalog.

`DAFFODIL_JAVA_OPTS`

: Specified additionalify java options to provide to Daffodil.
  If not specified, the `JAVA_OPTS` environment variable will be used.
  If that is not specified, reasonable defaults for Daffodil will be used.

`DAFFODIL_TDML_API_INFOSETS`

: Controls which Daffodil APIs and infoset types are used when running TDML tests with the [test](#test-subcommand) subcommand.

  If not set or has a value of `scala`, the standard Daffodil API and Scala infoset type is used.

  If set to `all`, both the standard Daffodil API and SAX APIs are used, an all available infoset inputters/outputters are used, including Scala, JDOM, W3CDOM, JSON, and XML text.
  The results of the different infosets are compared to ensure equality.
  This can have a negative impact on TDML performance, but can be useful for regression testing.

`CC`

: Specifies which C compiler should be called when running TDML files with the [test](#test-subcommand) subcommand using Daffodil's codegen-c backend.
  If that environment variable is not specified, then Daffodil will call the first C compiler driver command it finds within the `PATH` environment variable from the following list: "zig cc", "cc", "clang", "gcc" (in that order).
  The reason for "zig cc" coming first is because [zig cc](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html) uses a sophisticated caching system to avoid recompiling the same C source files, which can speed up TDML tests.

# Global Options

`-v, --verbose`

: Enable verbose mode and increment verbosity level. Each additional `-v` provides a new level of information.

`--version`

: Display Daffodil's version.

`-h, --help`

: Display a help message.

# Parse Subcommand

Parse a file, using either a DFDL schema or a saved parser.

`--` can be used to separate command-line options from trailing arguments.

## Usage

```
daffodil parse (-s <schema> | -P <parser>) [PARSE_OPTS] [infile]
```

## Options

`-c, --config <file>`

: XML file containing configuration items, such as external variables or Daffodil tunables.
  See [Configuration](/configuration) for details on the file format.

`-Dvariable=value [variable=value]...`

: Variables to be used when parsing.
  A namespace may be specified by prefixing `variable` with `{namespace}`, for example:
  ```
  -D{http://example.com}var1=var
  ```

`-d, --debug [file]`

: Enable the interactive debugger. See the [Interactive Debugger](/debugger) documentation for more information.
  The optional `[file]` argument contains a list of debugger commands that are provided to the debugger as if they were typed by the user.
  This option cannot be used with the `--trace` option.

`-I, --infoset-type <type>`

: Infoset type to output.
  `<type>` must be one of `xml`, `scala-xml`, `json`, `jdom`, `sax`, `exi`, `exisa`, `w3cdom`, or `null`.
  Defaults to `xml` if not provided.

`-o, --output <file>`

: Output file to write the infoset to.
  If the option is not given or `<file>` is `-`, the infoset is written to standard output.

`-P, --parser <file>`

: Use a previously saved parser inside `<file>`, created using the [save-parser](#save-parser-subcommand) subcommand.
 This option cannot be used with the `--schema`.

`-r, --root <root>`

: The root element to use. This must be one of the top-level elements of the DFDL schema defined with `--schema`.
  This requires the `--schema` option to be defined.
  Defaults to the schemas first top-level element if not provided.
  A namespace may be specified by prefixing `<root>` with `{namespace}`.

`-s, --schema <file>`

: The annotated DFDL schema to use to create the parser.
  This option cannot be used with the `--parser` option.

`--stream`

: Rather than throwing an error when left over data exists after a parse, repeat the parse with the remaining data.
  Parsing repeats until end of data is reached, an error occurs, or no data is consumed.
  Output infosets are separated by a NUL character.

`--nostream`

: Stop after the first parse, throwing an error if left over data exists.
  This is the default behavior.

`-Ttunable=value [tunable=value]...`

: Tunable configuration options to change Daffodil's behavior.
  See [Configuration](/configuration) for the list of tunable parameters.

`-t, --trace`

: Enable trace mode. This mode prints out helpful information during every stage of parsing.
  This option cannot be used with the `--debug` option.

`-V, --validate <validator_name>`

: Specify a validator to use. `<validator_name>` can be one of `off`, `daffodil`, `xerces[=value]`, `schematron[=value]`, or a `custom validator_name[=value]`.
  The optional value parameter provides a file to the validator (e.g. .xsd, .sch, .conf, .properties) used for validator configuration.
  If using --parser, some validators may require that a config file be specified.

`-h, --help`

: Display a help message.

`[infile]`

: Input file to parse.
  If not specified, or is a value of `-`, reads from standard input.
  If supplied, the input file must be the last option on the command line.

## Example

```
daffodil parse -s csv.dfdl.xsd test_file.csv
```

# Unparse Subcommand

Unparse an infoset file, using either a DFDL schema or a saved parser

`--` can be used to separate command-line options from trailing arguments

## Usage

```
daffodil unparse (-s <schema> | -P <parser>) [UNPARSE_OPTS] [infile]
```

## Options

`-c, --config <file>`

: XML file containing configuration items, such as external variables or Daffodil tunables.
  See [Configuration](/configuration) for details on the file format.

`-Dvariable=value [variable=value]...`

: Variables to be used when parsing.
  A namespace may be specified by prefixing `variable` with `{namespace}`, for example:

```
-D{http://example.com}var1=var
```

`-d, --debug [file]`

: Enable the interactive debugger. See the [Interactive Debugger](/debugger) documentation for more information.
  The optional `[file]` argument contains a list of debugger commands that are provided to the debugger as if they were typed by the user.
  This option cannot be used with the `--trace` option.

`-I, --infoset-type <type>`

: Infoset type to unparse.
  `<type>` must be one of `xml`, `scala-xml`, `json`, `jdom`, `sax`, `exi`, `exisa`, `w3cdom`, or `null`.
  Defaults to `xml` if not provided.

`-o, --output <file>`

: Output file to write the data to.
  If the option is not given or `<file>` is `-`, the infoset is written to standard output.

`-P, --parser <file>`

: Use a previously saved parser inside `<file>`, created using the [save-parser](#save-parser-subcommand) subcommand.
  This option cannot be used with the `--schema`.

`-r, --root <root>`

: The root element to use. This must be one of the top-level elements of the DFDL schema defined with `--schema`.
  This requires the `--schema` option to be defined.
  Defaults to the schemas first top-level element if not provided.
  A namespace may be specified by prefixing `<root>` with `{namespace}`.

`-s, --schema <file>`

: The annotated DFDL schema to use to create the parser.
  This option cannot be used with the `--parser` option.

`--stream`

: Split the input data on the NUL character, and unparse each chunk separatly.

`--nostream`

: Treat the entire input data as on infoset.
  This is the default behavior.

`-Ttunable=value [tunable=value]...`

: Tunable configuration options to change Daffodil's behavior.
  See [Configuration](/configuration) for the list of tunable parameters.

`-t, --trace`

: Enable trace mode. This mode prints out helpful information during every stage of unparsing.
  This option cannot be used with the `--debug` option.

`-V, --validate <validator_name>`

: Specify a validator to use. `<validator_name>` can be one of `off`, `daffodil`, `xerces[=value]`, `schematron[=value]`, or a `custom validator_name[=value]`.
  The optional value parameter provides a file to the validator (e.g. .xsd, .sch, .conf, .properties) used for validator configuration.
  If using --parser, some validators may require that a config file be specified.
  Note that using this flag doesn't use the created validator as unpase validation is currently unsupported.

`-h, --help`

: Display a help message.

`[infile]`

: Input file to unparse.
  If not specified, or is a value of `-`, reads from standard input.
  If supplied, the input file must be the last option on the command line.

## Example

```
daffodil unparse -s csv.dfdl.xsd test_file.infoset
```

# Save Parser Subcommand

Save a parser that can be reused for parsing and unparsing.

`--` can be used to separate command-line options from trailing arguments

## Usage

```
daffodil save-parser -s <schema> [SAVE_PARSER_OPTS] [outfile]
```

## Options

`-c, --config <file>`

: XML file containing configuration items, such as external variables or Daffodil tunables.
  Note variable values defined in the configuration file will not be included in the saved parser--the saved parser only embeds variable values defined in the schema.
  See [Configuration](/configuration) for details on the file format.

`-r, --root <root>`

: The root element to use. This must be one of the top-level elements of the DFDL schema defined with `--schema`.
  This requires the `--schema` option to be defined.
  Defaults to the schemas first top-level element if not provided.
  A namespace may be specified by prefixing `<root>` with `{namespace}`.

`-s, --schema <file>`

: The annotated DFDL schema to use to create the parser.
  This option must be supplied.

`-Ttunable=value [tunable=value]...`

: Tunable configuration options to change Daffodil's behavior.
  See [Configuration](/configuration) for the list of tunable parameters.

`-h, --help`

: Display a help message.

`[outfile]`

: Output file to write the saved parser to.
  If the option is not given or is `-`, the parser is written to standard output.
  If supplied, the output file must be the last option on the command line.

## Example

```
daffodil save-parser -s csv.dfdl.xsd csv_parser.bin
```

# Test Subcommand

List or execute tests in a TDML file.

`--` can be used to separate command-line options from trailing arguments

## Usage

```
daffodil test [TEST_OPTS] <tdmlfile> [testnames...]
```

## Options

`-d, --debug [file]`

: Enable the interactive debugger. See the [Interactive Debugger](/debugger) documentation for more information.
  The optional `[file]` argument contains a list of debugger commands that are provided to the debugger as if they were typed by the user.
  This option cannot be used with the `--trace` option.
   
`-I, --implementation <implementation>`

: Implementation to run TDML tests.
  Choose `daffodil` or `daffodilC`.
  Defaults to daffodil.

`-i, --info`

: Increment test result information output level, one level for each `-i`.

`-l, --list`

: Show names and descriptions of test cases in a TDML file instead of running them.

`-r, --regex`

: Treat `[testnames...]` as regular expressions.

`-t, --trace`

: Enable a trace mode.
  This mode prints out helpful information during every stage of parsing.
  This option cannot be used with the `--debug` option.

`-h, --help`

: Display a help message.

`<tdmlfile>`

: Test Data Markup Language (TDML) file.

`[testnames...]`

: Name(s) of test cases in the TDML file.
  If not given, all tests in `<tdmlfile>` are run.

## Example

```
daffodil test csv.tdml
```

# Performance Subcommand

Run a performance test (parse or unparse), using either a DFDL schema or a saved parser.

`--`  can be used to separate command-line options from trailing arguments

## Usage

```
daffodil performance (-s <schema> | -P <parser>) [PERFORMANCE_OPTS] <infile>
```

## Options

### `-c, --config <file>`

XML file containing configuration items, such as external variables or Daffodil tunables.
See [Configuration](/configuration) for details on the file format.

`-Dvariable=value [variable=value]...`

: Variables to be used when parsing.
  A namespace may be specified by prefixing `variable` with `{namespace}`, for example:
  ```
  -D{http://example.com}var1=var
  ```

`-I, --infoset-type <type>`

: Infoset type to output.
  `<type>` must be one of `xml`, `scala-xml`, `json`, `jdom`, `sax`, `exi`, `exisa`, `w3cdom`, or `null`.
  Defaults to `xml` if not provided.

`-N, --number <number>`

: The total number of files to process. Defaults to 1.

`-P, --parser <file>`

: Use a previously saved parser inside `<file>`, created using the [save-parser](#save-parser-subcommand) subcommand.
  This option cannot be used with the `--schema`.

`-r, --root <root>`

: The root element to use. This must be one of the top-level elements of the DFDL schema defined with `--schema`.
  This requires the `--schema` option to be defined.
  Defaults to the schemas first top-level element if not provided.
  A namespace may be specified by prefixing `<root>` with `{namespace}`.

`-s, --schema <file>`

: The annotated DFDL schema to use to create the parser.
  This option cannot be used with the `--parser` option.

`-t, --threads <threads>`

: The number of threads to use. Defaults to 1.

`-Ttunable=value [tunable=value]...`

: Tunable configuration options to change Daffodil's behavior.
  See [Configuration](/configuration) for the list of tunable parameters.

`-u, --unparse`

: Perform unparse instead of parse for performance test.

`-V, --validate <validator_name>`

: Specify a validator to use. `<validator_name>` can be one of `off`, `daffodil`, `xerces[=value]`, `schematron[=value]`, or a `custom validator_name[=value]`.
  The optional value parameter provides a file to the validator (e.g. .xsd, .sch, .conf, .properties) used for validator configuration.
  If using --parser, some validators may require that a config file be specified.

`-h, --help`

: Display a help message.

`<infile>`

: Input file or directory containing input files to parse or unparse. Required argument.

## Example

```
daffodil performance -s csv.dfdl.xsd -N 1000 -t 5 test_file.csv
```

# Generate Subcommand

Generate C code from a DFDL schema to parse or unparse data.

`--` can be used to separate command-line options from trailing arguments

## Usage

```
daffodil generate <language> -s <schema> [GENERATE_OPTIONS] [outdir]
```

There is only one choice for `<language>` at this time: `c`


## Options

`-c, --config <file>`

: XML file containing configuration items, such as external variables or Daffodil tunables.
  See [Configuration](/configuration) for details on the file format.

`-r, --root <root>`

: The root element to use. This must be one of the top-level elements of the DFDL schema defined with `--schema`.
  This requires the `--schema` option to be defined.
  Defaults to the schemas first top-level element if not provided.
  A namespace may be specified by prefixing `<root>` with `{namespace}`.

`-s, --schema <file>`

: The annotated DFDL schema to use to create the parser.
  This option must be supplied.

`-Ttunable=value [tunable=value]...`

: Tunable configuration options to change Daffodil's behavior.
  See [Configuration](/configuration) for the list of tunable parameters.

`-h, --help`

: Display a help message.

`[outdir]`

: The output directory in which to create or replace a `c` subdirectory containing the generated C code.
  If the option is not given, a `c` subdirectory within the current directory will be created/replaced.
  If supplied, the output directory must be the last option on the command line.

## Example

```
daffodil generate c -s csv.dfdl.xsd
```

# EXI Subcommand

Encode/decode an XML file with Efficient XML Interchange (EXI). If a schema is specified, it will use schema aware encoding/decoding.

`--` can be used to separate command-line options from trailing arguments

## Usage

```
daffodil exi [EXI_OPTIONS] [infile]
```

## Options

`-d, --decode`

: Decode `[infile]` from EXI to XML.

`-o, --output <file>`

: Output file to write the encoded/decoded data to.
  If the option is not given or `<file>` is `-`, the infoset is written to standard output.

`-s, --schema <file>`

: The annotated DFDL schema to use for schema aware encoding/decoding.

`-h, --help`

: Display a help message.

`[infile]`

: Input file to encode/decode.
  If not specified, or is a value of `-`, reads from standard input.
  If supplied, the input file must be the last option on the command line.

## Example

```
daffodil exi -s csv.dfdl.xsd --decode file.exi
```
