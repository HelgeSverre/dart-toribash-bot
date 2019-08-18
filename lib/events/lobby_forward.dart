import 'dart:io';

class LobbyForwardEvent {
  InternetAddress _ip;
  int _port;

  InternetAddress get ip => _ip;

  int get port => _port;

  LobbyForwardEvent(InternetAddress ip, int port) {
    _ip = ip;
    _port = port;
  }
}
