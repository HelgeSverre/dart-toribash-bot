class PasswordDeclinedEvent {
  String _password;

  String get password => _password;

  PasswordDeclinedEvent(String password) {
    _password = password;
  }
}
