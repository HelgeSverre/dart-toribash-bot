class RoomPasswordSetEvent {
  String _player;

  String get player => _player;

  RoomPasswordSetEvent(String player) {
    _player = player;
  }
}
