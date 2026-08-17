import "dart:convert";
import "package:firebase_remote_config/firebase_remote_config.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/core/services/auth_service.dart";
import "package:miutem/core/services/firebase/keys.dart";
import "package:miutem/core/services/firebase/remote_config_service.dart";
import "package:miutem/core/utils/utils.dart";

/// A widget that conditionally renders its child based on feature flag values from Firebase Remote Config.
///
/// Usage with a single flag:
/// ```dart
/// FeatureFlag('bottom_navigation.novedades', child: const Text('This text will be shown if the feature flag is true'))
/// ```
///
/// Usage with multiple flags (shows if at least one is enabled):
/// ```dart
/// FeatureFlag.multiple(['feature1', 'feature2'], child: const Text('Shown if feature1 OR feature2 is true'))
/// ```
class FeatureFlag extends StatelessWidget {
  /// The feature flag key to evaluate (supports dot notation for nested flags)
  final String? flagKey;

  /// Multiple feature flag keys (at least one must be true to show the child)
  final List<String>? flagKeys;

  /// Profiles allowed to see this feature. If the current user's profile is not
  /// in this list, a "Característica disponible solo para perfiles: ..." message
  /// is shown instead of the child.
  final List<Perfil>? allowedProfiles;

  /// The child widget to render if the feature flag(s) is/are enabled
  final Widget child;

  /// The fallback widget to render if the feature flag(s) is/are disabled (optional)
  final Widget? fallback;

  /// Whether to show the default profile restriction message when the user's
  /// profile is not in [allowedProfiles]. When false, renders nothing instead.
  final bool showProfileRestrictionMessage;

  /// Whether to show debug information in development mode
  final bool showDebugInfo;

  const FeatureFlag(this.flagKey, {
    super.key,
    required this.child,
    this.fallback,
    this.allowedProfiles,
    this.showProfileRestrictionMessage = true,
    this.showDebugInfo = false,
  }) : flagKeys = null;

  /// Constructor for multiple feature flags (shows if at least one is enabled)
  const FeatureFlag.multiple(this.flagKeys, {
    super.key,
    required this.child,
    this.fallback,
    this.allowedProfiles,
    this.showProfileRestrictionMessage = true,
    this.showDebugInfo = false,
  }) : flagKey = null;

  /// Constructor for profile-only restriction (no Firebase Remote Config flag needed)
  const FeatureFlag.profiles(
    List<Perfil> profiles, {
    super.key,
    required this.child,
    this.fallback,
    this.showProfileRestrictionMessage = false,
    this.showDebugInfo = false,
  }) : flagKey = null, flagKeys = null, allowedProfiles = profiles;

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
      if (!Get.isRegistered<RemoteConfigService>()) {
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
    // En modo capturas se muestran todas las características, incluidas las que estén
    // apagadas en Remote Config: las capturas de las tiendas tienen que mostrarlas.
    if (modoCapturas) return true;

    try {
      // Get the feature_flags JSON from Remote Config
      final featureFlagsJson = remoteConfig.getString(RemoteConfigServiceKeys.featureFlags);

      if (featureFlagsJson.isNotEmpty) {
        final result = _findNestedFlag(jsonDecode(featureFlagsJson), flagKey);
        if (result != null) return result;
      }

      // Fallback: try to find the flag in local defaults
      final defaultJson = remoteConfigDefaults[RemoteConfigServiceKeys.featureFlags];
      if (defaultJson is String && defaultJson.isNotEmpty) {
        final result = _findNestedFlag(jsonDecode(defaultJson), flagKey);
        if (result != null) {
          logger.d('FeatureFlag: Flag "$flagKey" not found in remote, using local default: $result');
          return result;
        }
      }

      logger.w('FeatureFlag: Feature flag "$flagKey" not found in remote config or local defaults, defaulting to false');
      return false;
    } catch (e) {
      logger.e('FeatureFlag: Error parsing feature flags JSON for "$flagKey": $e, defaulting to false');
      return false;
    }
  }

  /// Navigates a nested map using dot notation and returns the boolean value, or null if not found.
  static bool? _findNestedFlag(dynamic json, String flagKey) {
    if (json is! Map<String, dynamic>) return null;

    final keyParts = flagKey.split(".");
    dynamic currentLevel = json;

    for (final part in keyParts) {
      if (currentLevel is Map<String, dynamic> && currentLevel.containsKey(part)) {
        currentLevel = currentLevel[part];
      } else {
        return null;
      }
    }

    if (currentLevel is bool) {
      return currentLevel;
    }
    return null;
  }

  /// Gets the string value of a nested feature flag
  static String getString(String flagKey, {String defaultValue = ""}) {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final featureFlagsJson = remoteConfig.getString(RemoteConfigServiceKeys.featureFlags);

      if (featureFlagsJson.isEmpty) {
        return defaultValue;
      }

      final Map<String, dynamic> featureFlags = jsonDecode(featureFlagsJson);
      final keyParts = flagKey.split(".");
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
      final featureFlagsJson = remoteConfig.getString(RemoteConfigServiceKeys.featureFlags);

      if (featureFlagsJson.isEmpty) {
        return defaultValue;
      }

      final Map<String, dynamic> featureFlags = jsonDecode(featureFlagsJson);
      final keyParts = flagKey.split(".");
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
      final featureFlagsJson = remoteConfig.getString(RemoteConfigServiceKeys.featureFlags);

      if (featureFlagsJson.isEmpty) {
        return defaultValue;
      }

      final Map<String, dynamic> featureFlags = jsonDecode(featureFlagsJson);
      final keyParts = flagKey.split(".");
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
      final featureFlagsJson = remoteConfig.getString(RemoteConfigServiceKeys.featureFlags);

      if (featureFlagsJson.isEmpty) {
        return defaultValue;
      }

      final Map<String, dynamic> featureFlags = jsonDecode(featureFlagsJson);
      final keyParts = flagKey.split(".");
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

  /// Evaluates whether the current user's profile is in the allowed profiles list.
  ///
  /// - [allowedProfiles] must be a non-empty list of profiles that are allowed to see
  ///   the gated content.
  /// - Returns `true` if the current user has at least one of the allowed profiles.
  /// - Returns `false` if the user cannot be determined, has no profiles, or an
  ///   error occurs (fail-closed during loading/errors).
  static bool evaluateProfileSync(List<Perfil> allowedProfiles) {
    try {
      final authService = Get.find<AuthService>();
      final currentProfiles = authService.cachedEstudiante?.perfiles ?? [];
      if (currentProfiles.isEmpty) return false;
      return currentProfiles.any((p) => allowedProfiles.contains(p));
    } catch (e) {
      debugPrint("FeatureFlag: Error evaluating profile restriction: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check feature flag first (existing behavior)
    if (flagKey != null || flagKeys != null) {
      final isEnabled = _isAnyFlagEnabled();

      if (showDebugInfo && kDebugMode) {
        final debugInfo = _getDebugInfo();

        // Apply the same profile restriction logic used in the non-debug path
        Widget gatedChild;
        if (!isEnabled) {
          // Feature flag disabled: use the same fallback logic as below
          gatedChild = fallback ?? const SizedBox.shrink();
        } else {
          // Feature flag enabled: enforce profile restrictions if configured
          if (allowedProfiles != null && allowedProfiles!.isNotEmpty && !evaluateProfileSync(allowedProfiles!)) {
            if (fallback != null) {
              gatedChild = fallback!;
            } else if (showProfileRestrictionMessage) {
              gatedChild = _buildProfileRestrictedFallback(context);
            } else {
              gatedChild = const SizedBox.shrink();
            }
          } else {
            gatedChild = child;
          }
        }

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
                debugInfo,
                style: TextStyle(
                  fontSize: 10,
                  color: isEnabled ? Colors.green[800] : Colors.red[800],
                  fontFamily: "monospace",
                ),
              ),
            ),
            const SizedBox(height: 4),
            gatedChild,
          ],
        );
      }

      if (!isEnabled) return fallback ?? const SizedBox.shrink();
    }

    // Check profile restriction
    if (allowedProfiles != null && allowedProfiles!.isNotEmpty) {
      if (!evaluateProfileSync(allowedProfiles!)) {
        if (fallback != null) return fallback!;
        if (showProfileRestrictionMessage) return _buildProfileRestrictedFallback(context);
        return const SizedBox.shrink();
      }
    }

    return child;
  }

  Widget _buildProfileRestrictedFallback(BuildContext context) {
    final profileNames = allowedProfiles!.map((p) => p.displayName).join(", ");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Característica disponible solo para perfiles: $profileNames",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Checks if at least one flag is enabled (for multiple flags) or the flag is enabled (for single flag)
  bool _isAnyFlagEnabled() {
    if (flagKeys != null && flagKeys!.isNotEmpty) {
      // For multiple flags, return true if at least one is enabled (OR logic)
      return flagKeys!.any((flag) => evaluateSync(flag));
    } else if (flagKey != null) {
      // For single flag, evaluate normally
      return evaluateSync(flagKey!);
    }
    return false;
  }

  /// Gets debug information string
  String _getDebugInfo() {
    if (flagKeys != null && flagKeys!.isNotEmpty) {
      final flags = flagKeys!.map((f) => "$f = ${evaluateSync(f)}").join(", ");
      return "FeatureFlags (OR): [$flags]";
    } else if (flagKey != null) {
      return "FeatureFlag: $flagKey = ${evaluateSync(flagKey!)}";
    }
    return "FeatureFlag: No flags configured";
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
