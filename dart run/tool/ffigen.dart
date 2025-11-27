import 'dart:io';

import 'package:ffigen/ffigen.dart';
   
void main() {
  final packageRoot = Platform.script.resolve('../');
  FfiGenerator(
    // Required. Output path for the generated bindings.
    output: Output(dartFile: packageRoot.resolve('lib/add.g.dart')),
    // Optional. Where to look for header files.
    headers: Headers(entryPoints: [packageRoot.resolve('src/add.h')]),
    // Optional. What functions to generate bindings for.
    functions: Functions.includeSet({'add'}),
  ).generate();
}
import 'add.g.dart';

// ...
   
void answerToLife() {
  print('The answer to the Ultimate Question is ${add(40, 2)}!');
}

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';
   
void main(List<String> args) async {
  await build(args, (input, output) async {
    if (input.config.buildCodeAssets) {
      final builder = CBuilder.library(
        name: 'add',
        assetName: 'add.g.dart',
        sources: ['src/add.c'],
      );
      await builder.run(input: input, output: output);
    }
  });
}
