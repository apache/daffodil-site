---
layout: page
title: Interactive Debugger
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

The Daffodil [Command Line Interface](/cli) (CLI) comes with a built-in interactive debugger that pauses parsing/unparsing and allows for user inspection of some internal state. To start Daffodil in debugger mode, provide the global ``--debug`` option, for example:

    daffodil --debug parse --schema schema.dfdl.xsd input.dat

Enabling the debugger displays a ``(debug)`` prompt, at which point various commands can be entered to control parsing and inspect Daffodil state. Note that you can optionally provide a file to the ``--debug`` option. Each line in the file is provided to the debugger as if it were typed by the user. Below is the list of commands accepted by the debugger and their descriptions.

``break <element_id>``

   : Create a breakpoint, causing the debugger to stop when the element with the ``<element_id>`` name is created.

         break foo

     Abbreviation: ``b``

``clear``

   : Clear the screen.

   : Abbreviation: ``c``

``complete``

   : Continue parsing the input data until parsing is complete. All breakpoints are ignored.

   : Abbreviation: ``comp``

``condition <breakpoint_id> <dfdl_expression>``

   : Set a condition on a specified breakpoint. When a breakpoint is encountered, the debugger only pauses if the DFDL expression evaluates to ``true``. If the result of the DFDL expressions is not a boolean value, it is treated as false.

   : Abbreviation: ``cond``

         condition 1 dfdl:occursIndex() eq 3

``continue``

   : Continue parsing the input data until a breakpoint is encountered. At which point, pause parsing and display a debugger console to the user.

   : Abbreviation: ``c``

``delete <type> <id>``

   : Remove a breakpoint or display. Valid values for ``<type>`` are ``breakpoint`` and ``display``.

   : Abbreviation: ``d``

         delete breakpoint 1
         delete display 1

``disable <type> <id>``

   : Disable a breakpoint or display. Valid values for ``<type>`` are ``breakpoint`` and ``display``.

   : Abbreviation: ``dis``

         disable breakpoint 1
         disable display 1

``display <debugger_command>``

   : Execute a debugger command every time a debugger console is displayed to the user.

   : Abbreviation: ``di``

         display info infoset

``enable <type> <id>``

   : Enable a breakpoint or display. Valid values for ``<type>`` are ``breakpoint`` and ``display``.

   : Abbreviation: ``e``

         enable breakpoint 1
         enable display 1

``eval <dfdl_expression>``

   : Evaluate a DFDL expression. If the expression evaluates to a complex element, then the XML representation for the complex element is displayed. If the expression evaluates to a simple type, then the value of the simple type is display.

   : Abbreviation: ``ev``

         eval dfdl:occursIndex()
         eval /ex:file/line[1]

``help [command]``

   : Display help. If a command is given, display help information specific to that command and its subcommands.

   : Abbreviation: ``h``

``history [outfile]``

   : Display the history of commands. If an argument is given, write the history to the specified file rather then printing it to the screen.

   : Abbreviation: ``hi``

``info <item>...``

   : Print internal information to the console. ``<item>`` can be specified multiple times to display multiple pieces of information.

   : Abbreviation: ``i``

         info data infoset

     The valid items are:

     ``bitLimit``

     : Display the current bit limit. Abbreviation: ``bl``

     ``bitPosition``

     : Display the current bit position. Abbreviation: ``bp``

     ``breakpoints``

     : Display the list of breakpoints. Abbreviation: ``b``

     ``childIndex``

     : Display the child index. Abbreviation: ``ci``

     ``data``

     : Display the input data. Abbreviation: ``d``

     ``delimiterStack``

     : Display the current delimiter stack. Abbreviation: ``ds``

     ``diff``

     : Display the differences from the previous state.

     ``displays``

     : Display the current ``display`` expressions. Abbreviation: ``di``

     ``foundDelimiter``

     : Display the most recently found delimiter. Abbreviation: ``fd``

     ``foundField``

     : Display the most recently found field. Abbreviation: ``ff``

     ``groupIndex``

     : Display the current group index. Abbreviation: ``gi``

     ``hidden``

     : Display whether or not we're within the nesting context of a hidden group. Abbreviation: ``h``

     ``infoset``

     : Display the current infoset. Abbreviation: ``i``

     ``occursIndex``

     : Display the current array limit. Abbreviation: ``oi``

     ``parser``

     : Display the current parser. Abbreviation: ``p``

     ``path``

     : Display the current schema component designator/path.

     ``pointsOfUncertainty``

	 : Display the list of unresolved points of uncertainty. Abbreviation: ``pou``

     ``suspensions``

	 : Display the list of suspensions. Abbreviation: ``sus``

     ``unparser``

     : Display the current unparser. Abbreviation: ``u``

     ``variables``

     : Display in-scope state of variables. Abbreviation: ``v``

``quit``

   : Immediately abort all processing.

   : Abbreviation: ``q``

``set <setting> <value>``
   : Change a debugger setting.

         set dataLength -1
         set wrapLength 50
         set removeHidden true

     Valid settings are:

     ``breakOnFailure <boolean>``

        : Set whether or not the debugger should break on failures. If set to ``false`` the normal processing occurs. If set to ``true``, any errors cause a break. Note that due to the backtracking behavior, not all failures are fatal. Defaults to ``false``.

     ``breakOnlyOnCreation <boolean>``

        : Set whether or not breakpoints should only be evaluated on element creation. Must be either ``true``/``false`` or ``1``/``0``. If ``true``, breakpoints only stop on element creation. If ``false``, breakpoints stop anytime a parser interacts with an element. Defaults to ``true``.

     ``dataLength <integer>``

        : Set the number of bytes to display when displaying input data. If negative, display all input data. This only affects the ``info data`` command. Defaults to ``70``.

     ``diffExcludes <strings...>``

        : Set info comamnds to exclude in the 'info diff' command. Multiple arguments separated by a space excludes multiple commands. Zero arguments excludes no commands.

     ``infosetLines <integer>``

        : Set the maximum number of lines to display when displaying the infoset. This only affects the ``info infoset`` command. This shows the last number of lines of the infoset. If the number is less than or equal to zero, the entire infoset is printed. Defaults to ``-1``.

     ``infosetParents <integer>``

        : Set the number of parent elements to show when displaying the infoset. This only affects the ``info infoset`` command. A value of zero will only show the current infoset element. A value of ``-1`` will show the entire infoset. Defaults to ``-1``.

     ``removeHidden <boolean>``

        : Set whether or not hidden elements (e.g through the use of dfdl:hiddenGroupRef) should be displayed. This effects the ``eval`` and ``info infoset`` commands. Must be either ``true``/``false`` or ``1``/``0``. Defaults to ``false``.

     ``representation <string>``

        : Set the output when displaying data. Must be either ``text`` or ``binary``. Defaults to ``text``.

     ``wrapLength <integer>``

        : Set the number of characters at which point output wraps. This only affects the ``info data`` and ``info infoset`` commands. A length less than or equal to zero disables wrapping. Defaults to ``80``.


step

   : Perform a single parse action, pause parsing, and display a debugger prompt.

   : Abbreviation: ``s``

trace

   : Continue parsing the input data until a breakpoint is encountered, while running display commands after every parse step. When a breakpoint is encountered, pause parsing and display a debugger console to the user.

   : Abbreviation: ``t``
