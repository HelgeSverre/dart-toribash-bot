import 'package:toribash_bot/toribash_bot.dart';
import 'package:toribash_bot/credentials.dart';

main(List<String> args) async {
  ToribashBot bot = ToribashBot(
    Credentials("USERNAME", "PASSWORD"),
  );

  bot.events.roomConnected.listen((event) {
    print(
      "[BOT] connected to ${event.room.name}, ${event.room.players.length} players in room",
    );
  });

  bot.events.passwordAccepted.listen((e) {
    print("[BOT] Password '${e.password}' accepted");
  });

  bot.events.serverSay.listen((e) {
    print("[BOT] SERVER: '${e.message}'");
  });

  bot.events.passwordDeclined.listen((e) {
    print("[BOT] Password '${e.password}' declined");
  });

  bot.events.playerJoinedSpectators.listen((e) {
    print("[BOT] Player '${e.player}' joined spectators");
  });

  bot.events.playerDisconnected.listen((e) {
    print("[BOT] Player '${e.player}' disconnected");
  });

  bot.events.playerSay.listen((e) {
    print("[BOT] Player '${e.player}' said:  ${e.message}");
  });

  bot.events.whisper.listen((e) {
    print("[BOT] Player '${e.player}' whispered:  ${e.message}");
  });

  bot.events.roomPasswordSet.listen((e) {
    print("[BOT] Player '${e.player}' set a password on the room");
  });

  bot.events.roomPasswordCleared.listen((e) {
    print("[BOT] Player '${e.player}' cleared the password for the room");
  });

  bot.events.disconnected.listen((e) {
    print("[BOT] Disconnect, bot stopping");
  });

  bot.join("bottesting");

  Future.delayed(Duration(seconds: 10), () {
    bot.disconnect();
  });
}
