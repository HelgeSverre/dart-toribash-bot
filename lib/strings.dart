class MessageStrings {
  static final String passwordRequired = "SAY 0; Use /pass password to authenticate";
  static final String passwordDeclined = "SAY 0; ^02*^08 Incorrect password";
  static final String passwordAccepted = "SAY 0; ^02*^08 Password accepted";
  static final String banned = "SAY 0; ^02*^08 Kicked: (banned)";
  static final String kicked = "DISCONNECTED 0; You have been kicked. Please join another room";
}

class MessageMatchers {
  static final RegExp joinedSpectators = RegExp(
    r"SAY 0; \^10\*\^08 (?<player>.+) joined the spectators",
  );

  static final RegExp playerSay = RegExp(
    r"<\^\d\d(?<player>.+)\^\d\d> (?<message>.+)",
  );

  static final RegExp serverSay = RegExp(
    r"SAY 0; (?<message>.+)",
  );

  static final RegExp whisper = RegExp(
    r"WHISPER \d+;\d+ \*(?<player>\w+): (?<message>.+)",
  );

  // Catches both proper disconnect and "no response" events.
  static final RegExp disconnect = RegExp(
    r"DISCONNECT \d+;(?<player>.+) disconnected\.",
  );

  static final RegExp passwordSet = RegExp(
    r"\^10\*\^08 (?<player>.+) added password, server is private",
  );

  static final RegExp passwordCleared = RegExp(
    r"\^10\*\^08 (?<player>.+) cleared the server password, server is public",
  );
}
