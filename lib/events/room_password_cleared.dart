class RoomPasswordClearedEvent {
  String _player;

  String get player => _player;

  RoomPasswordClearedEvent(String player) {
    _player = player;
  }
}
