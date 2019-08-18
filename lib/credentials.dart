import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

class Credentials {
  String _username;
  String _password;

  String get username => _username;

  String get password => _password;

  String get md5password => md5.convert(utf8.encode(_password)).toString();

  /// MD5 Hash of the hardware identifier, not validated, MAC Address is
  /// used in the Toribash game client, this library replicates that behaviour
  String get hardwareId {
    return md5.convert(utf8.encode(Platform.localHostname)).toString();
  }

  Credentials(String username, String password) {
    _username = username;
    _password = password;
  }
}
