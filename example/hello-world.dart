import 'package:toribash_bot/credentials.dart';
import 'package:toribash_bot/events/room_connected.dart';
import 'package:toribash_bot/toribash_bot.dart';

main(List<String> args) async {
  String roomName = "testroom";

  ToribashBot bot = ToribashBot(
    Credentials("USERNAME", "PASSWORD"),

  );

  bot.events.roomConnected.listen((RoomConnectedEvent event) {
    Future.delayed(Duration(seconds: 5), () {
      bot.say("Hello world!");
    });

    Future.delayed(Duration(seconds: 10), () {
      bot.disconnect();
    });
  });

  bot.join(roomName);
}
