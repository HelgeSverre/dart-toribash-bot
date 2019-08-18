import '../room.dart';

class RoomConnectedEvent {
  Room _room;

  Room get room => _room;

  RoomConnectedEvent(Room room) {
    _room = room;
  }
}
