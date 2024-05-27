import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:moneygram/feature_flags/feature.dart';

/// App wide feature flag manager. Manages the availability status of each
/// features on the app.
class FireFlag {
  /// Constructs an instance of [FireFlag].
  ///
  /// Make sure you have set the required Firebase Remote Config setup on your
  /// app.
  ///
  /// Set the default values of feature flags to [features].
  ///
  /// Set the [fetchExpirationDuration] to specify the custom expiration
  /// duration time for any fetch from the Firebase Remote Config server.
  /// Server fetch will only be done when the previous fetch is already
  /// expired. Default expiration duration is 5 minutes.
  FireFlag({
    required Features features,
    Duration? fetchExpirationDuration,
  }) {
    _features = features;
    // _fetchExpirationDuration = fetchExpirationDuration ?? const Duration(seconds: 2);
  }

  /// The status flag of available features.
  ///
  /// Consider that default values set to this variable will be used as feature
  /// flag default values.
  /// Default values will be used when the app launches for the first time so
  /// that there is no feature flag data yet on Firebase Remote Config's local
  /// cache.
  late Features _features;

  FirebaseRemoteConfig? _remoteConfig;
  // late Duration _fetchExpirationDuration;

  /// Initialize feature flag stream.
  ///
  /// The stream will be initialized with value from local stored feature
  /// status (or default feature status if there's no local cache yet).
  /// Then it will fetch the feature status configuration from Firebase
  /// Remote Config server and store the latest config to the local cache and
  /// to the stream.
  Stream<Features> featureFlagSubscription() async* {
    _remoteConfig = await FirebaseRemoteConfig.instance;

    ///Fetch latest feature flag data from Firebase Remote Config and apply
    ///them.
    yield await featureFlagFromFirebaseRemoteConfigServer();
  }

  Features _featureFlagFromLocalStoredFirebaseRemoteConfig() {
    _features.features?.forEach((feature) {
      var featureFlagValue = _remoteConfig?.getValue(feature.name);

      /// Check whether Firebase Remote Config has the feature flag data for the
      /// feature first before setting the value. Otherwise preserve the default
      /// value.
      if (featureFlagValue != null) {
        /// Will be set to false when the value is not equal to 'true'.
        /// Case insensitive. 'True' will be still considered as true.
        feature.isEnabled = featureFlagValue.asBool();
        feature.value = featureFlagValue.asString();
      }
    });

    return _features;
  }

  Future<Features> featureFlagFromFirebaseRemoteConfigServer() async {
    try {
      // Using zero duration to force fetching from remote server.
      await _remoteConfig?.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await _remoteConfig?.fetchAndActivate();
    } catch (exception) {
      // print('Unable to fetch remote config. Cached or default values will be '
      //     'used');
      // print(exception);
    }
    return _featureFlagFromLocalStoredFirebaseRemoteConfig();
  }
}
