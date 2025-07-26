import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:miutem/core/services/firebase/remote_config_service.dart';

/// A widget that conditionally renders its child based on a feature flag value from Firebase Remote Config.
///
/// Usage:
/// ```dart
/// FeatureFlag('bottom_navigation.novedades', child: const Text('This text will be shown if the feature flag is true'))
/// ```
class FeatureFlag extends StatelessWidget {
  /// The feature flag key to evaluate (supports dot notation for nested flags)
  final String flagKey;

  /// The child widget to render if the feature flag is enabled
  final Widget child;

  /// The fallback widget to render if the feature flag is disabled (optional)
  final Widget? fallback;

  /// Whether to show debug information in development mode
  final bool showDebugInfo;

  const FeatureFlag(
    this.flagKey, {
    super.key,
    required this.child,
    this.fallback,
    this.showDebugInfo = false,
  });

  /// Evaluates a feature flag and returns its boolean value
  ///
  /// Usage:
  /// ```dart
  /// const featureFlagValue = await FeatureFlag.evaluate('bottom_navigation.novedades');
  /// ```
  static Future<bool> evaluate(String flagKey) async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      // Ensure remote config is initialized
      if (Get.isRegistered<RemoteConfigService>()) {
        // Remote config should already be initialized via the service
      } else {
        // Fallback initialization if service is not available
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 12),
        ));
        await remoteConfig.fetchAndActivate();
      }

      return _evaluateNestedFlag(remoteConfig, flagKey);
    } catch (e) {
      // Return false by default if there's an error
      debugPrint('FeatureFlag: Error evaluating flag "$flagKey": $e');
      return false;
    }
  }

  /// Evaluates a feature flag synchronously (uses cached values)
  ///
  /// Usage:
  /// ```dart
  /// final isEnabled = FeatureFlag.evaluateSync('bottom_navigation.novedades');
  /// ```
  static bool evaluateSync(String flagKey) {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      return _evaluateNestedFlag(remoteConfig, flagKey);
    } catch (e) {
      debugPrint('FeatureFlag: Error evaluating flag "$flagKey" synchronously: $e');
      return false;
    }
  }

  /// Internal method to evaluate nested feature flags from the JSON structure
  static bool _evaluateNestedFlag(FirebaseRemoteConfig remoteConfig, String flagKey) {
    try {
      // Get the feature_flags JSON from Remote Config
      final featureFlagsJson = remoteConfig.getString('feature_flags');

      if (featureFlagsJson.isEmpty) {
        Logger().w('FeatureFlag: No feature_flags parameter found in Remote Config');
        return false;
      }

      // Parse the JSON
      final Map<String, dynamic> featureFlags = jsonDecode(featureFlagsJson);

      // Navigate through the nested structure using dot notation
      final keyParts = flagKey.split('.');
      dynamic currentLevel = featureFlags;

      for (final part in keyParts) {
        if (currentLevel is Map<String, dynamic> && currentLevel.containsKey(part)) {
          currentLevel = currentLevel[part];
        } else {
          Logger().w('FeatureFlag: Feature flag "$flagKey" not found in remote config, defaulting to false');
          return false;
        }
      }

      // Return the boolean value, defaulting to false if it's not a boolean
      if (currentLevel is bool) {
        return currentLevel;
      } else {
        Logger().w('FeatureFlag: Value for "$flagKey" is not a boolean: $currentLevel, defaulting to false');
        return false;
      }
    } catch (e) {
      Logger().e('FeatureFlag: Error parsing feature flags JSON for "$flagKey": $e, defaulting to false');
      return false;
    }
  }

  /// Gets the string value of a nested feature flag
  static String getString(String flagKey, {String defaultValue = ''}) {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final featureFlagsJson = remoteConfig.getString('feature_flags');

      if (featureFlagsJson.isEmpty) {
        return defaultValue;
      }

      final Map<String, dynamic> featureFlags = jsonDecode(featureFlagsJson);
      final keyParts = flagKey.split('.');
      dynamic currentLevel = featureFlags;

      for (final part in keyParts) {
        if (currentLevel is Map<String, dynamic> && currentLevel.containsKey(part)) {
          currentLevel = currentLevel[part];
        } else {
          return defaultValue;
        }
      }

      return currentLevel?.toString() ?? defaultValue;
    } catch (e) {
      debugPrint('FeatureFlag: Error getting string value for flag "$flagKey": $e');
      return defaultValue;
    }
  }

  /// Gets the int value of a nested feature flag
  static int getInt(String flagKey, {int defaultValue = 0}) {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final featureFlagsJson = remoteConfig.getString('feature_flags');

      if (featureFlagsJson.isEmpty) {
        return defaultValue;
      }

      final Map<String, dynamic> featureFlags = jsonDecode(featureFlagsJson);
      final keyParts = flagKey.split('.');
      dynamic currentLevel = featureFlags;

      for (final part in keyParts) {
        if (currentLevel is Map<String, dynamic> && currentLevel.containsKey(part)) {
          currentLevel = currentLevel[part];
        } else {
          return defaultValue;
        }
      }

      if (currentLevel is int) {
        return currentLevel;
      } else if (currentLevel is num) {
        return currentLevel.toInt();
      }

      return defaultValue;
    } catch (e) {
      debugPrint('FeatureFlag: Error getting int value for flag "$flagKey": $e');
      return defaultValue;
    }
  }

  /// Gets the double value of a nested feature flag
  static double getDouble(String flagKey, {double defaultValue = 0.0}) {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final featureFlagsJson = remoteConfig.getString('feature_flags');

      if (featureFlagsJson.isEmpty) {
        return defaultValue;
      }

      final Map<String, dynamic> featureFlags = jsonDecode(featureFlagsJson);
      final keyParts = flagKey.split('.');
      dynamic currentLevel = featureFlags;

      for (final part in keyParts) {
        if (currentLevel is Map<String, dynamic> && currentLevel.containsKey(part)) {
          currentLevel = currentLevel[part];
        } else {
          return defaultValue;
        }
      }

      if (currentLevel is double) {
        return currentLevel;
      } else if (currentLevel is num) {
        return currentLevel.toDouble();
      }

      return defaultValue;
    } catch (e) {
      debugPrint('FeatureFlag: Error getting double value for flag "$flagKey": $e');
      return defaultValue;
    }
  }

  /// Gets the raw value of a nested feature flag (can be any type)
  static dynamic getValue(String flagKey, {dynamic defaultValue}) {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final featureFlagsJson = remoteConfig.getString('feature_flags');

      if (featureFlagsJson.isEmpty) {
        return defaultValue;
      }

      final Map<String, dynamic> featureFlags = jsonDecode(featureFlagsJson);
      final keyParts = flagKey.split('.');
      dynamic currentLevel = featureFlags;

      for (final part in keyParts) {
        if (currentLevel is Map<String, dynamic> && currentLevel.containsKey(part)) {
          currentLevel = currentLevel[part];
        } else {
          return defaultValue;
        }
      }

      return currentLevel ?? defaultValue;
    } catch (e) {
      debugPrint('FeatureFlag: Error getting value for flag "$flagKey": $e');
      return defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = evaluateSync(flagKey);

    if (showDebugInfo && kDebugMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'FeatureFlag: $flagKey = $isEnabled',
              style: TextStyle(
                fontSize: 10,
                color: isEnabled ? Colors.green[800] : Colors.red[800],
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 4),
          if (isEnabled) child else (fallback ?? const SizedBox.shrink()),
        ],
      );
    }

    return isEnabled ? child : (fallback ?? const SizedBox.shrink());
  }
}

/// A builder widget that provides the feature flag value to its builder function
///
/// Usage:
/// ```dart
/// FeatureFlagBuilder(
///   'MY_FEATURE_FLAG',
///   builder: (context, isEnabled) {
///     return Text(isEnabled ? 'Feature is ON' : 'Feature is OFF');
///   },
/// )
/// ```
class FeatureFlagBuilder extends StatelessWidget {
  final String flagKey;
  final Widget Function(BuildContext context, bool isEnabled) builder;

  const FeatureFlagBuilder(
    this.flagKey, {
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = FeatureFlag.evaluateSync(flagKey);
    return builder(context, isEnabled);
  }
}

/// Extension to add feature flag functionality to any widget
extension FeatureFlagExtension on Widget {
  /// Wraps this widget with a feature flag check
  ///
  /// Usage:
  /// ```dart
  /// const Text('Hello').withFeatureFlag('MY_FEATURE_FLAG')
  /// ```
  Widget withFeatureFlag(String flagKey, {Widget? fallback}) {
    return FeatureFlag(
      flagKey,
      fallback: fallback,
      child: this,
    );
  }
}
