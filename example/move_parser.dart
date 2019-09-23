import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:quiver/iterables.dart';
import 'package:toribash_bot/game_rules.dart';
import 'package:toribash_bot/joint_data.dart';

void main() async {
  var dir = new Directory('data/replays');

  dir.listSync().forEach((replayFile) {
    var filename = basenameWithoutExtension(replayFile.path);
    try {
      Replay replay = Replay(replayFile.path);
      String txt = replay.moves.map((list) => list.join(", ")).join("\n");
      var file = File("data/moves/$filename.txt");
      file.writeAsStringSync(txt, mode: FileMode.write);
    } catch (e) {
      // Ignore
    }
  });

//  print("Replay name: ${replay.name}");
//  print("Replay Creator: ${replay.author}");
//  print("Player 1: ${replay.playerOne}");
//  print("Player 2: ${replay.playerTwo}");
//  print("Mod: ${replay.rules.mod}");
//  print("".padLeft(80, "="));
//  replay.moves.forEach((move) => print(move));
//  print("".padLeft(80, "="));
}

class Replay {
  String name;
  int version;
  File file;
  String replayData;
  List<List<String>> moves = List();
  GameRules rules;
  String author;
  String playerOne;
  String playerTwo;

  Replay(String filePath) {
    file = File(filePath);
    replayData = file.readAsStringSync();

    _parseVersion();

    if (version == null || version < 10) {
      throw "Replay versions under 10 is not supported atm.";
    }

    _parseReplayInfo();
    _parseGameRules();
    _parseMoves();
  }

  _parseVersion() {
    var lines = replayData.split("\n");
    version = int.tryParse(lines
        .firstWhere((line) => line.startsWith("VERSION"))
        .split(" ")
        .last
        .trim());
  }

  _parseReplayInfo() {
    var lines = replayData.split("\n");

    name = lines
        .firstWhere(
          (line) => line.startsWith("FIGHTNAME") || line.startsWith("FIGHT 0"),
        )
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
    List<String> moveList = List();

    replayData
        .split("\n")
        .map((line) => line.trim())
        .where((line) => line.startsWith("FRAME") || line.startsWith("JOINT 0"))
        .forEach((l) {
      if (moveList.isNotEmpty &&
          moveList.last.contains("FRAME") &&
          l.startsWith("FRAME")) {
        // Replace the last frame line, since it is invalid, no moves inbetween
        moveList.removeLast();
        moveList.add(l);
      } else {
        moveList.add(l);
      }
    });

    List<List<String>> temp = moveList
        .map((line) => line.startsWith("JOINT 0")
            ? _parseMoveLine(line)
            : _parseFrameLine(line))
        .toList();

    temp.removeAt(0);
    moves = temp;
  }

  List<String> _parseMoveLine(String line) {
    return partition(line.split("; ").last.split(" "), 2).toList().map((move) {
      return JointData.friendlyName(
        JointData.getJoint(int.parse(move[0])),
        JointData.getState(int.parse(move[1])),
      );
    }).toList();
  }

  List<String> _parseFrameLine(String line) {
    return ["Wait until turnframe " + line.split(";").first.split(" ").last];
  }
}
