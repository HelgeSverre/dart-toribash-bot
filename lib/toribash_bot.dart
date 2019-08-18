import 'dart:async';
import 'dart:io';

import 'package:toribash_bot/events.dart';
import 'package:toribash_bot/events/lobby_forward.dart';
import 'package:toribash_bot/events/player_disconnected.dart';
import 'package:toribash_bot/events/raw_message.dart';
import 'package:toribash_bot/events/room_password_cleared.dart';
import 'package:toribash_bot/events/server_say.dart';
import 'package:toribash_bot/strings.dart';

import 'credentials.dart';
import 'events/banned.dart';
import 'events/disconnected.dart';
import 'events/kicked.dart';
import 'events/password_accepted.dart';
import 'events/password_declined.dart';
import 'events/ping.dart';
import 'events/player_joined_spectators.dart';
import 'events/player_say.dart';
import 'events/room_connected.dart';
import 'events/room_password_set.dart';
import 'events/whisper.dart';
import 'exceptions/room_is_password_protected.dart';
import 'room.dart';

class ToribashBot {
  Socket _lobbySocket;
  Socket _roomSocket;

  Credentials _credentials;

  Room _currentRoom;
  Events _eventDispatcher;

  List<String> _spectators = [];
  List<String> _players = [];

  Room get currentRoom => _currentRoom;

  List<String> get spectators => _spectators;

  List<String> get players => _players;

  Events get events => _eventDispatcher;

  Timer _pinger;

  bool _spectateOnJoin;

  String _roomPassword;

  ToribashBot(
    Credentials credentials, {
    bool spectateOnJoin = true,
    String roomPassword = null,
  }) {
    _eventDispatcher = Events();
    _credentials = credentials;
    _spectateOnJoin = spectateOnJoin;
    _roomPassword = roomPassword;
  }

  // Asks the lobby server for the IP and Port of the room
  void join(String room) async {
    _lobbySocket = await Socket.connect("144.76.163.135", 22001);
    _lobbySocket
        .map((data) => String.fromCharCodes(data))
        .listen((msg) => _handleLobbyMessages(msg));
    _lobbySocket.writeln("join $room\n");
    _lobbySocket.writeln("PING");
  }

  /// Establishes a connection to a room.
  connect(InternetAddress ip, int port) async {
    _roomSocket = await Socket.connect(ip, port);
    _roomSocket
        .map((data) => String.fromCharCodes(data))
        .listen(_handleRoomMessages, onDone: () => _onDisconnected());

    command(
      "mlogin ${_credentials.username} ${_credentials.md5password} 0 ${_credentials.hardwareId}\n"
      "TUTORIAL 0;${_credentials.username} 0\n"
      "VERSION 0;2 5.22\n",
    );

    _onRoomConnect();
  }

  /// Send a raw command to the room
  void command(String command) {
    _roomSocket.writeln(command);
  }

  /// Enter the spectator queue
  void spectate() {
    command("SPEC");
  }

  /// Send a public message in the chat
  void say(String value) {
    command("SAY $value");
  }

  /// Send a private message to another player in the same room.
  void whisper(String player, String message) {
    command("whisper $player $message");
  }

  /// Give a player operator privileges
  void op(String player) {
    command("op $player");
  }

  /// Remove operator privileges from a player
  void deop(String player) {
    command("deop $player");
  }

  void ban(String player) {
    command("ban add $player");
  }

  void unban(String player) {
    command("ban del $player");
  }

  void clearBanList() {
    command("ban clear");
  }

  /// Mutes a player in the room
  void mute(String player) {
    command("mute $player");
  }

  /// Unmutes a player in the room
  void unmute(String player) {
    command("unmute $player");
  }

  /// Mutes all players in the room
  void muteAll() {
    command("muteall");
  }

  /// Unmutes all players in the room
  void unmuteAll() {
    command("unmuteall");
  }

  /// Change the Message of the day for the room
  void motd(String message) {
    command("motd $message");
  }

  /// Sets a password for the room
  void setPassword(String password) {
    command("passwd $password");
  }

  /// Sets a password for the room
  void clearPassword() {
    command("passwd clear");
  }

  void sendPassword(String password) {
    command("pass $password");
  }

  /// Disconnects from the room and closes the socket connection
  void disconnect() {
    command("QUIT");
    _roomSocket.close();
  }

  /// Triggered when the room socket connection is established.
  _onRoomConnect() {
    _pinger = Timer.periodic(Duration(seconds: 10), (timer) {
      _eventDispatcher.dispatchEvent(PingEvent(timer));
      command("PING");
    });
    command("PING");

    if (_spectateOnJoin) {
      // This has no effect if the room is password protected, at this point
      // in time we don't know if this is the case, we just fire off this
      // command anyways, and add a listener of the password accepted event
      // and spectate there as well, that way we will enter the spectator
      // queue no matter what state the room is in.
      spectate();

      _eventDispatcher.passwordAccepted.listen((e) {
        spectate();
      });
    }
  }

  /// Triggered when the room socket connection is closed.
  _onDisconnected() {
    _pinger.cancel();
    _eventDispatcher.dispatchEvent(DisconnectedEvent());
  }

  void _handleRoomMessages(String message) {
    var lines = message.split("\n");

    // Initial message from server upon connecting.
    if (lines.first == "TORIBASH 30") {
      _currentRoom = Room.fromString(message);
      _eventDispatcher.dispatchEvent(RoomConnectedEvent(_currentRoom));
    } else {
      // Populate the fight queue and spectator list
      _updatePlayerList(lines);

      // Handle other messages
      lines.where((l) => l.isNotEmpty).forEach(_handleRoomMessageLine);
    }
  }

  _handleRoomMessageLine(String line) {
    _eventDispatcher.dispatchEvent(RawMessageEvent(line));

    if (line == MessageStrings.passwordRequired) {
      _handlePasswordProtectedRoom();
    }

    if (line == MessageStrings.banned) {
      _eventDispatcher.dispatchEvent(BannedEvent());
    }

    if (line == MessageStrings.kicked) {
      _eventDispatcher.dispatchEvent(KickedEvent());
    }

    if (line == MessageStrings.passwordAccepted) {
      _eventDispatcher.dispatchEvent(PasswordAcceptedEvent(_roomPassword));
    }

    if (line == MessageStrings.passwordDeclined) {
      _eventDispatcher.dispatchEvent(PasswordDeclinedEvent(_roomPassword));
    }

    if (MessageMatchers.joinedSpectators.hasMatch(line)) {
      _eventDispatcher.dispatchEvent(
        PlayerJoinedSpectatorsEvent(
          MessageMatchers.joinedSpectators
              .firstMatch(line)
              .namedGroup("player"),
        ),
      );
    }

    if (MessageMatchers.playerSay.hasMatch(line)) {
      var playerSayMatch = MessageMatchers.playerSay.firstMatch(line);
      _eventDispatcher.dispatchEvent(PlayerSayEvent(
        playerSayMatch.namedGroup("player"),
        playerSayMatch.namedGroup("message"),
      ));
    }

    if (MessageMatchers.serverSay.hasMatch(line)) {
      var serverSayMatch = MessageMatchers.serverSay.firstMatch(line);
      _eventDispatcher.dispatchEvent(
        ServerSayEvent(
          serverSayMatch.namedGroup("message"),
        ),
      );
    }

    if (MessageMatchers.whisper.hasMatch(line)) {
      var whisperMatch = MessageMatchers.whisper.firstMatch(line);
      _eventDispatcher.dispatchEvent(
        WhisperEvent(
          whisperMatch.namedGroup("player"),
          whisperMatch.namedGroup("message"),
        ),
      );
    }

    if (MessageMatchers.disconnect.hasMatch(line)) {
      var disconnectMatch = MessageMatchers.disconnect.firstMatch(line);
      _eventDispatcher.dispatchEvent(
        PlayerDisconnectedEvent(
          disconnectMatch.namedGroup("player"),
        ),
      );
    }

    if (MessageMatchers.passwordSet.hasMatch(line)) {
      var disconnectMatch = MessageMatchers.passwordSet.firstMatch(line);
      _eventDispatcher.dispatchEvent(
        RoomPasswordSetEvent(
          disconnectMatch.namedGroup("player"),
        ),
      );
    }

    if (MessageMatchers.passwordCleared.hasMatch(line)) {
      var disconnectMatch = MessageMatchers.passwordCleared.firstMatch(line);
      _eventDispatcher.dispatchEvent(
        RoomPasswordClearedEvent(
          disconnectMatch.namedGroup("player"),
        ),
      );
    }
  }

  void _handleLobbyMessages(String message) {
    if (message.contains("FORWARD")) {
      var roomForward = message.trim().split(";").last.split(":");

      InternetAddress forwardIp = InternetAddress(roomForward.first);
      int forwardPort = int.parse(roomForward.last);

      _eventDispatcher.dispatchEvent(LobbyForwardEvent(forwardIp, forwardPort));

      connect(forwardIp, forwardPort);

      _lobbySocket.writeln("QUIT");
      _lobbySocket.close();
    }
  }

  void _updatePlayerList(List<String> lines) {
    // Only update the player list if we get sent the complete player list
    if (lines.where((l) => l.startsWith("BOUT 0")).isNotEmpty) {
      _players = lines
          .where((l) => l.startsWith("BOUT"))
          .where((l) => !l.endsWith("END 0"))
          .toList()
          .map((l) => l.split("; ").last.split(" ")[6])
          .toList();
    }

    // Only update spectator list if we get a SPECSTATE line
    var specs = lines.where((l) => l.startsWith("SPECSTATE"));
    if (specs.isNotEmpty) {
      _spectators = specs.first
          .split(";")
          .last
          .trim()
          .split("\t")
          .map((s) => s.split(" ").first)
          .toList();
    }
  }

  void _handlePasswordProtectedRoom() {
    if (_roomPassword != null) {
      sendPassword(_roomPassword);
    } else {
      throw RoomIsPasswordProtected(
        "The room is password protected, please provide a room password in the Bot() constructor",
      );
    }
  }
}
