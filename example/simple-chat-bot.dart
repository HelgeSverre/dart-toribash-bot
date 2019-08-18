import 'package:toribash_bot/credentials.dart';
import 'package:toribash_bot/events/player_say.dart';
import 'package:toribash_bot/toribash_bot.dart';

main(List<String> args) async {
  String roomName = "testroom";

  ToribashBot bot = ToribashBot(
    Credentials("USERNAME", "PASSWORD"),
  );

  bot.events.playerSay.listen((PlayerSayEvent event) {
    if (event.message == "bot::hello") {
      bot.say("Hello there ${event.player}");
    }
  });

  bot.join(roomName);
}
