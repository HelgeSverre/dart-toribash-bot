import 'dart:async';

import 'package:toribash_bot/events/banned.dart';
import 'package:toribash_bot/events/disconnected.dart';
import 'package:toribash_bot/events/kicked.dart';
import 'package:toribash_bot/events/lobby_forward.dart';
import 'package:toribash_bot/events/password_declined.dart';

import 'events/password_accepted.dart';
import 'events/ping.dart';
import 'events/player_disconnected.dart';
import 'events/player_joined_spectators.dart';
import 'events/player_say.dart';
import 'events/raw_message.dart';
import 'events/room_connected.dart';
import 'events/room_password_cleared.dart';
import 'events/room_password_set.dart';
import 'events/server_say.dart';
import 'events/whisper.dart';

class Events {

  //@formatter:off

  // Event Controllers
  final _whisperController = StreamController<WhisperEvent>.broadcast();
  final _playerSayController = StreamController<PlayerSayEvent>.broadcast();
  final _serverSayController = StreamController<ServerSayEvent>.broadcast();
  final _playerDisconnectedController = StreamController<PlayerDisconnectedEvent>.broadcast();
  final _disconnectedController = StreamController<DisconnectedEvent>.broadcast();
  final _pingController = StreamController<PingEvent>.broadcast();
  final _lobbyForwardController = StreamController<LobbyForwardEvent>.broadcast();
  final _roomConnectedController = StreamController<RoomConnectedEvent>.broadcast();
  final _passwordAcceptedController = StreamController<PasswordAcceptedEvent>.broadcast();
  final _passwordDeclinedController = StreamController<PasswordDeclinedEvent>.broadcast();
  final _playerJoinedSpecsController = StreamController<PlayerJoinedSpectatorsEvent>.broadcast();
  final _roomPasswordSetController = StreamController<RoomPasswordSetEvent>.broadcast();
  final _roomPasswordClearedController = StreamController<RoomPasswordClearedEvent>.broadcast();
  final _kickedController = StreamController<KickedEvent>.broadcast();
  final _bannedController = StreamController<BannedEvent>.broadcast();
  final _rawMessageController = StreamController<RawMessageEvent>.broadcast();

  // Event Streams
  Stream<WhisperEvent> get whisper => _whisperController.stream;
  Stream<PlayerSayEvent> get playerSay => _playerSayController.stream;
  Stream<ServerSayEvent> get serverSay => _serverSayController.stream;
  Stream<PlayerDisconnectedEvent> get playerDisconnected => _playerDisconnectedController.stream;
  Stream<PingEvent> get ping => _pingController.stream;
  Stream<LobbyForwardEvent> get lobbyForward => _lobbyForwardController.stream;
  Stream<RoomConnectedEvent> get roomConnected => _roomConnectedController.stream;
  Stream<PasswordAcceptedEvent> get passwordAccepted => _passwordAcceptedController.stream;
  Stream<PasswordDeclinedEvent> get passwordDeclined => _passwordDeclinedController.stream;
  Stream<PlayerJoinedSpectatorsEvent> get playerJoinedSpectators => _playerJoinedSpecsController.stream;
  Stream<RoomPasswordSetEvent> get roomPasswordSet => _roomPasswordSetController.stream;
  Stream<RoomPasswordClearedEvent> get roomPasswordCleared => _roomPasswordClearedController.stream;
  Stream<BannedEvent> get banned => _bannedController.stream;
  Stream<KickedEvent> get kicked => _kickedController.stream;
  Stream<DisconnectedEvent> get disconnected => _disconnectedController.stream;
  Stream<RawMessageEvent> get rawMessage => _rawMessageController.stream;

  //@formatter:on

  void dispatchEvent<T>(T event) {
    switch (T) {
      case ServerSayEvent:
        _serverSayController.add(event as ServerSayEvent);
        break;

      case WhisperEvent:
        _whisperController.add(event as WhisperEvent);
        break;

      case PlayerSayEvent:
        _playerSayController.add(event as PlayerSayEvent);
        break;

      case PlayerDisconnectedEvent:
        _playerDisconnectedController.add(event as PlayerDisconnectedEvent);
        break;

      case PingEvent:
        _pingController.add(event as PingEvent);
        break;

      case LobbyForwardEvent:
        _lobbyForwardController.add(event as LobbyForwardEvent);
        break;

      case RoomConnectedEvent:
        _roomConnectedController.add(event as RoomConnectedEvent);
        break;

      case PasswordAcceptedEvent:
        _passwordAcceptedController.add(event as PasswordAcceptedEvent);
        break;

      case PasswordDeclinedEvent:
        _passwordDeclinedController.add(event as PasswordDeclinedEvent);
        break;

      case PlayerJoinedSpectatorsEvent:
        _playerJoinedSpecsController.add(event as PlayerJoinedSpectatorsEvent);
        break;

      case RoomPasswordSetEvent:
        _roomPasswordSetController.add(event as RoomPasswordSetEvent);
        break;

      case RoomPasswordClearedEvent:
        _roomPasswordClearedController.add(event as RoomPasswordClearedEvent);
        break;

      case BannedEvent:
        _bannedController.add(event as BannedEvent);
        break;

      case KickedEvent:
        _kickedController.add(event as KickedEvent);
        break;

      case DisconnectedEvent:
        _disconnectedController.add(event as DisconnectedEvent);
        break;

      case RawMessageEvent:
        _rawMessageController.add(event as RawMessageEvent);
        break;

      default:
        throw("Event '$T' not supported");
    }
  }


}