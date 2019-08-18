class RoomIsPasswordProtected implements Exception {
  String cause;

  RoomIsPasswordProtected(this.cause);
}
