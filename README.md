# Toribash Bot Library in Dart 

[![pub package](https://img.shields.io/pub/v/toribash_bot.svg)](https://pub.dev/packages/toribash_bot)

A Dart library for creating bots in Toribash, helps you establish a 
socket connection to a game room and triggers events that you can 
hook into to provide functionality, see the usage section for a simple example.

## Installing

Add the package to your dependencies in the ```pubspec.yaml``` file:

```yaml
dependencies:
  toribash_bot: ^1.0.0
```


## Usage 

Using the library is fairly straight forward if you are familiar with the [Dart language](https://dart.dev/guides/language/language-tour)

The class you interact with is the ```ToribashBot()``` class, which takes a ```Credentials()``` object and some optional parameters.

```dart
import 'package:toribash_bot/credentials.dart';
import 'package:toribash_bot/events/room_connected.dart';
import 'package:toribash_bot/toribash_bot.dart';

ToribashBot bot = ToribashBot(
  Credentials("USERNAME", "PASSWORD"),
  spectateOnJoin: true, // Optional: Should the bot spectate on join? defaults to true, don't change this unless you have a very good reason to.
  roomPassword: "examplepassword", // If the room you are connecting to is password protected, provide the password here.
);
```

Now we have our bot instance, we can now hook into the events, this is implemented with [Dart Streams](https://dart.dev/tutorials/language/streams#listen-method).

```dart
bot.events.roomConnected.listen((RoomConnectedEvent event) {
  print("Bot has connected to the room");
});
```

Lastly we need to connect to the room, by calling the ```join(roomName)``` method on the bot 
instance, this will establish a socket connection to the lobby server, asking for the IP and 
Port of the room, (creating it if it does not exist), then the lobby server will forward the 
bot to the right room, the bot client will establish another socket connection to the room 
and start listening for data, and transform that data into events. 

```dart
bot.join("exampleroom");
```

## Examples

### Hello World
Here is a simple bot that will connect to the room ```testroom```, 
say "Hello world" in the chat after 5 seconds, then disconnect after 5 more seconds.

```dart
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
```

### Respond to a player 

Now, we want to add some interactivity to our bot, so we will add a listener 
for the playerSay event, and if anyone in the room says "bot::hello", 
we will respond with "Hello there PLAYERNAME".

We can send chat messagges to the room by using the ```say("message")``` method on the bot instance. 

```dart
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
```


## Commands

Commands are methods on the instance of a ```ToribashBot()``` class.


| Method                                       | Description                                                                                            |
|----------------------------------------------|--------------------------------------------------------------------------------------------------------|
| ```join(String room)```                      | Makes the player join a room                                                                           |
| ```command(String command)```                | Sends a raw command to the server, only use this if the command you need is not implemented in the bot |
| ```spectate()```                             | Makes the bot enter the spectate queue. You should always make your bot spectate                       |
| ```say(String value)```                      | Send a message to the room                                                                             |
| ```whisper(String player, String message)``` | Send a whisper to another player                                                                       |
| ```op(String player)```                      | Make another player an OP of the room (Bot must to be OPed)                                            |
| ```deop(String player)```                    | De-op a player of the room (requires the bot to be OPed or a admin of sort)                            |
| ```ban(String player)```                     | Adds a player to the ban list, this will also kick them off the server                                 |
| ```unban(String player)```                   | Removes a player from the ban list                                                                     |
| ```clearBanList()```                         | Remove all players from the ban list                                                                   |
| ```mute(String player)```                    | Mutes the player in the room                                                                           |
| ```unmute(String player)```                  | Unmutes the player in the room                                                                         |
| ```muteAll()```                              | Mutes everyone in the room                                                                             |
| ```unmuteAll()```                            | Unmutes everyone in the room                                                                           |
| ```motd(String message)```                   | Sets the 'Message Of The Day' of the room                                                              |
| ```setPassword(String password)```           | Password protect the room (Bot has to be OPed)                                                         |
| ```clearPassword()```                        | Remove the password from a room (Bot must to be OPed)                                                  |
| ```sendPassword(String password)```          | Used internally, sends a "/pass password" command to the server, if the room is password protected     |
| ```disconnect()```                           | Disconnects the bot, same as closing the game client (sends a "QUIT" command)                          |


## Events

Events are triggered when certain messages or events happen on the server, the Toribash Bot client connects to 
the server and dispatches events based on the messages it receives.

To listen for a particular event, access the event from the ```event``` property on the ToribashBot instance

**Example:**
 
```dart
ToribashBot bot = ToribashBot(
  Credentials("USERNAME", "PASSWORD"),
);

// You can listen for any event by calling .listen() on the appropriate event:
// bot.events.{EVENTNAME}.listen((e) { /* handle event here */ })

// Examples:
bot.events.roomConnected.listen((event) => print("Example"));
bot.events.playerSay.listen((event) => print("Example"));
```

Here is a list of events that you can listen to:

| Event name             | Event                                                 | Description                                                                             |
|------------------------|-------------------------------------------------------|-----------------------------------------------------------------------------------------|
| whisper                | ```WhisperEvent(String player, String message)```     | Triggered when the bot receives a whisper message from another user                     |
| playerSay              | ```PlayerSayEvent(String player, String message)```   | Triggered whenever a player says something in a room                                    |
| serverSay              | ```ServerSayEvent(String message)```                  | Triggered whenever the server sends a message                                           |
| playerDisconnected     | ```PlayerDisconnectedEvent(String player)```          | Triggered when a player disconnects by either quiting or "not responding"               |
| ping                   | ```PingEvent(Timer timer)```                          | Triggered every time the bot sends a "PING" to the server, by default every 10 seconds. |
| lobbyForward           | ```LobbyForwardEvent(InternetAddress ip, int port)``` | Whenever the bot recieves a forward request from the lobby server.                      |
| roomConnected          | ```RoomConnectedEvent(Room room)```                   | Whenever the bot has connected to the room.                                             |
| passwordAccepted       | ```PasswordAcceptedEvent(String password)```          | Triggered if the room is password protected and a valid password was provided           |
| passwordDeclined       | ```PasswordDeclinedEvent(String password)```          | Triggered if the room is password protected and an invalid password was provided        |
| playerJoinedSpectators | ```PlayerJoinedSpectatorsEvent(String player)```      | Triggered whenever a player joins the spectators                                        |
| roomPasswordSet        | ```RoomPasswordSetEvent(String player)```             | Triggered whenever a room admin sets a password in the room                             |
| roomPasswordCleared    | ```RoomPasswordClearedEvent(String player)```         | Triggered whenever a room admin clears the password in the room                         |
| banned                 | ```BannedEvent()```                                   | Triggered if you're banned from the room                                                |
| kicked                 | ```KickedEvent()```                                   | Triggered if you're kicked from the room                                                |
| disconnected           | ```DisconnectedEvent```                               | Triggered when the connection is closed, use it to stop stream subscribers and cleanup. |
| rawMessage             | ```RawMessageEvent(String message)```                 | If you want to hook into the raw messages sent from the server.                         |
 
 
## Properties

There are currently 3 properties that you can access on the bot instance to get information about the current room.

**Example:**

```dart
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
```


| Property          | Type               | Description                                                                 |
|-------------------|--------------------|-----------------------------------------------------------------------------|
| ```currentRoom``` | ```Room```         | The current room, contains gamerules, ip and port, the mod being played etc |
| ```spectators```  | ```List<String>``` | List of spectators at this point in time                                    |
| ```players```     | ```List<String>``` | List of players in the fight queue at this point in time                    |