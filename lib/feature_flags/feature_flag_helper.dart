import 'package:moneygram/feature_flags/feature.dart';
import 'package:moneygram/feature_flags/feature_flag_keys.dart';
import 'package:moneygram/feature_flags/fire_flag.dart';
import 'package:moneygram/utils/broadcast/broadcast_channels.dart';
import 'package:moneygram/utils/broadcast/broadcast_receiver.dart';

class FeatureFlagHelper {
  static FeatureFlagHelper? _instance;

  static var features = Features(features: [
    Feature(
      name: FeatureFlagKeys.LATEST_APP_VERSION,
    ),
    Feature(
      name: FeatureFlagKeys.MIN_APP_VERSION,
    ),
  ]);

  final fireFlag = FireFlag(
    features: features,
    fetchExpirationDuration: const Duration(seconds: 0),
  );

  static FeatureFlagHelper get instance {
    if (_instance == null) {
      _instance = FeatureFlagHelper._internal();
    }

    return _instance!;
  }

  FeatureFlagHelper._internal();

  init() {
    setupFeatureFlags();
  }

  void setupFeatureFlags() {
    retrieveFeatureFlag();
  }

  void retrieveFeatureFlag() {
    fireFlag.featureFlagSubscription().listen((features) {
      features = features;
      BroadcastReceiver.broadcastController
          .add(BroadcastChannels.refreshAppUpdateChecker);
    });
  }

  String? getMinAppVersion() {
    return features.getValue(FeatureFlagKeys.MIN_APP_VERSION);
  }

  String? getLatestAppVersion() {
    return features.getValue(FeatureFlagKeys.LATEST_APP_VERSION);
  }

  bool isEnabled(String featureName) {
    return features.featureIsEnabled(featureName);
  }
}
