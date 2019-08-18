class PlayerSayEvent {
  String _player;

  String get player => _player;

  String _message;

  String get message => _message;

  PlayerSayEvent(String player, String message) {
    _player = player;
    _message = message;
  }
}
