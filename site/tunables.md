---
layout: page
title: Tunables
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
<!--
{% comment %}
This file is generated using ``sbt genTunablesDoc``. Update that task in Daffodil to update this file.
{% endcomment %}
-->

Daffodil provides tunables as a way to change its behavior.
Tunables are set by way of the ``tunables`` element in [config files](/configuration)
or from the [cli](/cli) via the ``-T`` option.

#### Config Example
 ``` xml
 <daf:dfdlConfig
	xmlns:daf="urn:ogf:dfdl:2013:imp:daffodil.apache.org:2018:ext">
    <daf:tunables>
      <daf:suppressSchemaDefinitionWarnings>
        encodingErrorPolicyError
      </daf:suppressSchemaDefinitionWarnings>
    </daf:tunables>
</daf:dfdlConfig>
 ```

The config file can then be passed into daffodil subcommands via the ``-c|--config`` options.

#### CLI Example
 ``` bash
 daffodil parse -s schema.xsd -TsuppressSchemaDefinitionWarnings="encodingErrorPolicyError" data.bin
 ```


### Definitions

#### allowBigIntegerBits
Previous Daffodil releases let schemas define every type's length using "bits" as the length unit
even though the specification allows bit length units only for a specific set of types' binary
representations and does not allow bit length units for any other type's binary representation
or any type's text representation.  When this tunable is true, a deprecation warning is issued
when bit length units are incorrectly used.  When this tunable is false, a schema definition
error will be issued instead.

default: true


#### allowExpressionResultCoercion
Defines how Daffodil coerces expressions where the result type differs
from the expected type. As an example, assume the expected type of an
expression is an xs:string, but the expression is { 3 }. In this case, the
expression result is an xs:int, which should not be automatically coerced
to an xs:string. Instead, the expression should be { xs:string(3) } or { "3" }
If the value of this tunable is false, these types of expressions will
result in a schema definition error. If the value is true, Daffodil will
provide a warning and attempt to coerce the result type to the expected
type.

default: true


#### allowExternalPathExpressions
By default, path expressions in Daffodil will only work correctly if path
steps are used in an expression defined in the schema when compiled. To
enable the use of other expressions (e.g. during debugging, where not all
expressions are known at schema compile time), set this tunable to true.
This may cause a degredation of performance in path expression evaluation,
so this should be avoided when in production. This flag is automatically
enabled when debugging is enabled.

default: false


#### blobChunkSizeInBytes
When reading/writing blob data, the maximum number of bytes to read/write
at a time. This is also used when parsing xs:hexBinary data.

default: 4096


#### defaultEmptyElementParsePolicy
Defines the default empty element parse policy to use if it is not defined
in a schema. This is only used if requireEmptyElementParsePolicyProperty is
false.

default: treatAsEmpty


#### escalateWarningsToErrors
This tunable allows the escalation of Schema Definition Warnings to Errors.

default: false


#### generatedNamespacePrefixStem
Stem to use when generating a namespace prefix when one is not defined for
the target naespace.

default: tns


#### initialElementOccurrencesHint
Initial array buffer size allocated for recurring elements/arrays.

default: 10


#### initialRegexMatchLimitInCharacters
Initial number of characters to match when performing regular expression
matches on input data. When a regex fails to match, more data may be
consumed up to the maximumRegexMatchLengthInCharacters tunable.

default: 64


#### infosetWalkerSkipMin
Daffodil periodically walks the internal infoset to send events to the configured
InfosetOutputter, skipping at least this number of walk attempts. Larger values
mean delayed InfosetOutputter events and more memory usage; Smaller values mean
more CPU usage. Set this value to zero to never skip any walk attempts. This is
specifically for advanced testing behavior and should not need to be changed by users.

default: 32


#### infosetWalkerSkipMax
Daffodil periodically walks the internal infoset to send events to the configured
InfosetOutputter. On walks where no progress is made, the number of walks to skip
is increased with the assumption that something is blocking it (like an
unresolved point of uncertainty), up to this maximum value. Higher values mean
less attempts are made when blocked for a long time, but with potentially more
delays and memory usage before InfosetOutputter events are created. This is
specifically for advanced testing behavior and should not need to be changed by users.

default: 2048


#### invalidRestrictionPolicy
DFDL only allows a subset of restrictions that XML Schema defines. For example, DFDL
disallows the use of the xs:pattern restriction on simple types other than xs:string.
This tunable configures this behavior to allow use of some of these restrictions. The
allowed values are:
- error: disallow the restriction, create a schema definition error
- ignore: allow the restriction but do not use it during validation
- validate: allow the resriction and use it to validate the canonicalized infoset

default: error


#### maxBinaryDecimalVirtualPoint
The largest allowed value of the dfdl:binaryDecimalVirtualPoint property.

default: 200


#### maxByteArrayOutputStreamBufferSizeInBytes
When unparsing, this is the maximum size of the buffer that the
ByteArrayOutputStream can grow to before switching to a file based
output stream.

default: 2097152000


#### maxDataDumpSizeInBytes
The maximum size of data to retrive when when getting data to display
for debugging.

default: 256


#### maxHexBinaryLengthInBytes
The maximum size allowed for an xs:hexBinary element.

default: 1073741823


#### maxLengthForVariableLengthDelimiterDisplay
When unexpected text is found where a delimiter is expected, this is the maximum
number of bytes (characters) to display when the expected delimiter is a variable
length delimiter.

default: 10


#### maxLookaheadFunctionBits
Max distance that the DPath lookahead function is permitted to look.
Distance is defined by the distance to the last bit accessed, and
so it is offset+bitsize.

default: 512


#### maxOccursBounds
Maximum number of occurances of an array element.

default: 2147483647


#### maxSkipLengthInBytes
Maximum number of bytes allowed to skip in a skip region.

default: 1024


#### maxValidYear
Due to differences in the DFDL spec and ICU4J SimpleDateFormat, we must
have SimpleDateFormat parse in lenient mode, which allows the year value
to overflow with very large years into possibly negative years. This
tunable tunable sets an upper limit for values to prevent overflow.

default: 9999


#### maximumRegexMatchLengthInCharacters
Maximum number of characters to match when performing regular expression
matches on input data.

default: 1048576


#### maximumSimpleElementSizeInCharacters
Maximum number of characters to parse when parsing string data.

default: 1048576


#### minBinaryDecimalVirtualPoint
The smallest allowed value of the dfdl:binaryDecimalVirtualPoint property.

default: -200


#### minValidYear
Due to differences in the DFDL spec and ICU4J SimpleDateFormat, we must
have SimpleDateFormat parse in lenient mode, which allows the year value
to overflow with very large years into possibly negative years. This
tunable tunable sets an upper limit for values to prevent underflow.

default: 0


#### outputStreamChunkSizeInBytes
When writing file data to the output stream during unparse, this
is the maximum number of bytes to write at a time.

default: 65536


#### parseUnparsePolicy
Whether to compile a schema to support only parsing, only unparsing, both, or to
use the daf:parseUnparsePolicy from the root node. All child elements of the root
must have a compatable daf:parseUnaprsePolicy property.

default: fromRoot


#### releaseUnneededInfoset
Daffodil will periodically release internal infoset elements that it determines
are no longer needed, thus freeing memory. Setting this value to false will
prevent this from taking place. This should usually only be used while debugging
or with very specific tests.

default: true


#### requireBitOrderProperty
If true, require that the dfdl:bitOrder property is specified. If false, use a
default value if the property is not defined in the schema.

default: false


#### requireEmptyElementParsePolicyProperty
If true, require that the dfdl:emptyElementParsePolicy property is specified in
the schema. If false, and not defined in the schema, uses the
defaultEmptyElementParsePolicy as the value of emptyElementParsePolicy.

default: false


#### requireEncodingErrorPolicyProperty
If true, require that the dfdl:encodingErrorPolicy property is specified. If
false, use a default value if the property is not defined in the schema.

default: false


#### requireFloatingProperty
If true, require that the dfdl:floating property is specified. If
false, use a default value if the property is not defined in the schema.

default: false


#### requireTextBidiProperty
If true, require that the dfdl:testBidi property is specified. If
false, use a default value if the property is not defined in the schema.

default: false


#### requireTextStandardBaseProperty
If true, require that the dfdl:textStandardBase property is specified. If false
and the property is missing, behave as if the property is set to 10.

default: false


#### saxUnparseEventBatchSize
Daffodil's SAX Unparse API allows events to be batched in memory to minimize the
frequency of context switching between the SAXInfosetInputter thread that processes
the events, and the DaffodilUnparseContentHandler thread that generates the events.
Setting this value to a low number will increase the frequency of context switching,
but will reduce the memory footprint. Swtting it to a high number will decrease the
frequency of context switching, but increase the memory footprint.

default: 100


#### suppressSchemaDefinitionWarnings
Space-separated list of schema definition warnings that should be ignored,
or "all" to ignore all warnings.

default: emptyElementParsePolicyError


#### tempFilePath
When unparsing, use this path to store temporary files that may be genrated.
The default value (empty string) will result in the use of the java.io.tmpdir
property being used as the path.

default: This string is ignored. Default value is taken from java.io.tmpdir property


#### unqualifiedPathStepPolicy
Defines how to lookup DFDL expression path steps that to not include a
namespace prefix. Values are:
- noNamespace: only match elements that do not have a namespace
- defaultNamespace: only match elements defined in the default namespace
- preferDefaultNamespace: match elements defined in the default namespace;
  if non are found, match elemnts that do not have a namespace

default: noNamespace


#### unparseSuspensionWaitOld
While unparsing, some unparse actions require "suspending" which
requires buffering unparse output until the suspension can be
evaluated. Daffodil periodically attempts to reevaluate these
suspensions so that these buffers can be released. We attempt to
evaluate young suspensions shortly after creation with the hope
that it will succeed and we can release associated buffers. But if
a young suspension fails it is moved to the old suspension list.
Old suspensions are evaluated less frequently since they are less
likely to succeeded. This minimizes the overhead related to
evaluating suspensions that are likely to fail. The
unparseSuspensionWaitYoung and unparseSuspensionWaitOld
values determine how many elements are unparsed before evaluating
young and old suspensions, respectively.

default: 100


#### unparseSuspensionWaitYoung
See unparseSuspensionWaitOld

default: 5


### Deprecated
- defaultInitialRegexMatchLimitInChars
- errorOnUnsupportedJavaVersion
- inputFileMemoryMapLowThreshold
- maxFieldContentLengthInBytes
- readerByteBufferSize
