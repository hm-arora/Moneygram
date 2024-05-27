import 'dart:async';

class BroadcastReceiver {
  static StreamController<String> broadcastController =
      StreamController<String>.broadcast();
}