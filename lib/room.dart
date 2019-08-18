import 'dart:io';

import 'game_rules.dart';

class Room {
  InternetAddress ipAddress;
  int port;

  String name;
  String description = "";
  GameRules gameRules;
  List<String> players = [];

  Room.fromString(String roomText) {
    var lines = roomText.split("\n").where((line) => line.isNotEmpty).toList();

    try {
      var server = RegExp(r"SERVER 0; (.+):(\d+) (\w+)")
          .firstMatch(lines.firstWhere((l) => l.startsWith("SERVER")));
      var clients = RegExp(r"CLIENTS 2;(.+)")
          .firstMatch(lines.firstWhere((l) => l.startsWith("CLIENTS")));

      var descLine =
          lines.firstWhere((l) => l.startsWith("DESC"), orElse: () => null);
      if (descLine != null) {
        this.description = RegExp(r"DESC 0;(.+)").firstMatch(descLine).group(1);
      }

      this.ipAddress = InternetAddress(server.group(1));
      this.port = int.parse(server.group(2));
      this.name = server.group(3);
      this.players = clients
              ?.group(1)
              ?.split("\t")
              ?.where((p) => p.isNotEmpty)
              ?.toList() ??
          [];

      this.gameRules = GameRules.fromString(
        lines.firstWhere((l) => l.startsWith("NEWGAME")),
      );
    } catch (e) {
      print(e);
    }
  }
}
