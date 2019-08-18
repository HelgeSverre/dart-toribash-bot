class WhisperEvent {
  String _player;

  String get player => _player;

  String _message;

  String get message => _message;

  WhisperEvent(String player, String message) {
    _player = player;
    _message = message;
  }
}
