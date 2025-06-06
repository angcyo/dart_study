A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

# `dart`

```shell
dart --help
A command-line utility for Dart development.

Usage: dart <command|dart-file> [arguments]

Global options:
-v, --verbose               Show additional command output.
    --version               Print the Dart SDK version.
    --enable-analytics      Enable analytics.
    --disable-analytics     Disable analytics.
    --suppress-analytics    Disallow analytics for this `dart *` run without changing the analytics configuration.
-h, --help                  Print this usage information.

Available commands:
  analyze    Analyze Dart code in a directory.
  compile    Compile Dart to various formats.
  create     Create a new Dart project.
  devtools   Open DevTools (optionally connecting to an existing application).
  doc        Generate API documentation for Dart projects.
  fix        Apply automated fixes to Dart source code.
  format     Idiomatically format Dart source code.
  info       Show diagnostic information about the installed tooling.
  pub        Work with packages.
  run        Run a Dart program.
  test       Run tests for a project.

Run "dart help <command>" for more information about a command.
See https://dart.dev/tools/dart-tool for detailed documentation.
```

## `dart create`

```shell
dart create --help
Create a new Dart project.

Usage: dart create [arguments] <directory>
-h, --help                       Print this usage information.
-t, --template                   The project template to use.

          [cli]                  A command-line application with basic argument parsing.
          [console] (default)    A command-line application.
          [package]              A package containing shared Dart libraries.
          [server-shelf]         A server app using package:shelf.
          [web]                  A web app that uses only core Dart libraries.

    --[no-]pub                   Whether to run 'pub get' after the project has been created.
                                 (defaults to on)
    --force                      Force project generation, even if the target directory already exists.

Run "dart help" to see global options.
```

## `dart compile`

```shell
dart compile --help
Compile Dart to various formats.

Usage: dart compile <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  aot-snapshot   Compile Dart to an AOT snapshot.
  exe            Compile Dart to a self-contained executable.
  jit-snapshot   Compile Dart to a JIT snapshot.
  js             Compile Dart to JavaScript.
  kernel         Compile Dart to a kernel snapshot.
  wasm           Compile Dart to a WebAssembly/WasmGC module.

Run "dart help" to see global options.
```