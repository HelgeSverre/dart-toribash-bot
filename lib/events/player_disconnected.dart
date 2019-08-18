class PlayerDisconnectedEvent {
  String _player;

  String get player => _player;

  PlayerDisconnectedEvent(String player) {
    _player = player;
  }
}
