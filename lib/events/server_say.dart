class ServerSayEvent {
  String _message;

  String get message => _message;

  ServerSayEvent(String message) {
    _message = message;
  }
}
