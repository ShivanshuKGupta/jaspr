import 'package:yaml/yaml.dart';

import 'logging.dart';

class JasprConfig {
  const JasprConfig({
    this.usesSsr = false,
    this.usesFlutter = false,
    this.devCommand,
  });

  final bool usesSsr;
  final bool usesFlutter;
  final String? devCommand;

  factory JasprConfig.fromYaml(YamlMap? pubspecYaml, Logger logger) {
    var configYaml = pubspecYaml?['jaspr'];
    if (configYaml == null) {
      return JasprConfig();
    }

    try {
      if (configYaml is! YamlMap) {
        throw "'jaspr' must be a map.";
      }

      bool? usesSsr;
      var ssrYaml = configYaml['uses-ssr'];
      if (ssrYaml != null) {
        if (ssrYaml is! bool) throw "'jaspr.uses-ssr' must be a boolean.";

        usesSsr = ssrYaml;
      } else {
        usesSsr = true;
      }

      bool? usesFlutter;
      var flutterYaml = configYaml['uses-flutter'];
      if (flutterYaml != null) {
        if (flutterYaml is! bool) throw "'jaspr.uses-flutter' must be a boolean.";

        usesFlutter = flutterYaml;
      } else {
        usesFlutter = false;
      }

      String? devCommand;
      var devCommandYaml = configYaml['dev-command'];
      if (devCommandYaml != null) {
        if (devCommandYaml is! String) throw "'jaspr.dev-command' must be a string.";

        devCommand = devCommandYaml;
      }

      return JasprConfig(usesSsr: usesSsr, usesFlutter: usesFlutter, devCommand: devCommand);
    } catch (e) {
      logger.write('Invalid jaspr configuration in pubspec.yaml: $e', level: Level.critical);
    }

    return JasprConfig();
  }
}
