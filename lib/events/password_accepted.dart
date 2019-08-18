class PasswordAcceptedEvent {
  String _password;

  String get password => _password;

  PasswordAcceptedEvent(String password) {
    _password = password;
  }
}
