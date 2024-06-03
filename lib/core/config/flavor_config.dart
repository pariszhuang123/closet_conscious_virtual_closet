import 'package:flutter/material.dart';

class FlavorConfig {
  final String name;
  final Color primaryColor;

  static FlavorConfig? _instance;

  FlavorConfig._internal(this.name, this.primaryColor);

  factory FlavorConfig({required String name, required Color primaryColor}) {
    _instance ??= FlavorConfig._internal(name, primaryColor);
    return _instance!;
  }

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isProduction() => _instance!.name == 'prod';
  static bool isDevelopment() => _instance!.name == 'dev';

  static void initialize(String environment) {
    switch (environment) {
      case 'dev':
        FlavorConfig(name: 'dev', primaryColor: Colors.blue);
        break;
      case 'prod':
        FlavorConfig(name: 'prod', primaryColor: Colors.green);
        break;
      default:
        throw ArgumentError('Unknown environment: $environment');
    }
  }
}
