import 'dart:io';

import 'package:quiver/iterables.dart';
import 'package:toribash_bot/game_rules.dart';
import 'package:toribash_bot/joint_data.dart';

void main() async {
  Replay replay = Replay("data/easy-moves.rpl");

  print("Replay name: ${replay.name}");
  print("Replay Creator: ${replay.author}");
  print("Player 1: ${replay.playerOne}");
  print("Player 2: ${replay.playerTwo}");
  print("Mod: ${replay.rules.mod}");
  print("".padLeft(80, "="));
  replay.moves.forEach((move) => print(move));
  print("".padLeft(80, "="));
}

class Replay {
  String name;
  File file;
  String replayData;
  List moves = List();
  GameRules rules;
  String author;
  String playerOne;
  String playerTwo;

  Replay(String filePath) {
    file = File(filePath);
    replayData = file.readAsStringSync();
    _parseReplayInfo();
    _parseGameRules();
    _parseMoves();
  }

  _parseReplayInfo() {
    var lines = replayData.split("\n");

    name = lines
        .firstWhere((line) => line.startsWith("FIGHTNAME"))
        .split(";")
        .last
        .trim();

    author = lines
        .firstWhere((line) => line.startsWith("AUTHOR"))
        .split(";")
        .last
        .trim();

    playerOne = lines
        .firstWhere((line) => line.startsWith("BOUT 0"))
        .split(";")
        .last
        .trim();

    playerTwo = lines
        .firstWhere((line) => line.startsWith("BOUT 1"))
        .split(";")
        .last
        .trim();
  }

  _parseGameRules() {
    var ruleString = replayData
        .split("\n")
        .firstWhere((line) => line.startsWith("NEWGAME"))
        .replaceFirst("NEWGAME 0", "NEWGAME 1")
        .trim();

    rules = GameRules.fromString(ruleString);
  }

  _parseMoves() {
    var joinLines = replayData
        .split("\n")
        .where((line) => line.startsWith("JOINT 0"))
        .map((line) => line.trim())
        .toList();

    List<List<String>> moveList = joinLines.map((line) {
      return partition(line.split("; ").last.split(" "), 2)
          .toList()
          .map((move) {
        return JointData.friendlyName(
          JointData.getJoint(int.parse(move[0])),
          JointData.getState(int.parse(move[1])),
        );
      }).toList();
    }).toList();

    moves = moveList;
  }
}
