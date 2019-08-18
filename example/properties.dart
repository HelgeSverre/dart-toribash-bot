import 'dart:async';

import 'package:toribash_bot/events/room_connected.dart';
import 'package:toribash_bot/toribash_bot.dart';
import 'package:toribash_bot/credentials.dart';

main(List<String> args) async {
  ToribashBot bot = ToribashBot(
    Credentials("USERNAME", "PASSWORD"),
  );

  bot.events.roomConnected.listen((RoomConnectedEvent event) {
    // After we've connected, run this code every 10 seconds
    Timer.periodic(Duration(seconds: 10), (timer) {
      print("This room is playing the mod: " + bot.currentRoom.gameRules.mod);
      print("Players in fight queue: " + bot.players.join(", "));
      print("Players specatating: " + bot.spectators.join(", "));
    });
  });

  bot.join("bottesting");
}
