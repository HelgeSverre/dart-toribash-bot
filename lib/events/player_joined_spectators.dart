class PlayerJoinedSpectatorsEvent {
  String _player;

  String get player => _player;

  PlayerJoinedSpectatorsEvent(String player) {
    _player = player;
  }
}
