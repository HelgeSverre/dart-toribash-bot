import 'dart:async';

class PingEvent {
  Timer _timer;

  Timer get timer => _timer;

  PingEvent(Timer timer) {
    _timer = timer;
  }
}
