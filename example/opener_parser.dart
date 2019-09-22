import 'dart:io';

import 'package:quiver/iterables.dart';
import 'package:toribash_bot/opener_parser.dart';

void main() async {
  var file = File("data/match.txt");
  var matchData = file.readAsStringSync();

  var opener =
      matchData.split("\n").where((line) => line.contains("OPENER")).toList();

  var openerMoves = partition(opener, 2).toList();

  openerMoves.forEach((openers) {
    var opener1 = openers[0].split(";").last.split(" ").first;
    var opener2 = openers[1].split(";").last.split(" ").first;
    print(OpenerParser.parse(opener1));
    print(OpenerParser.parse(opener2));
  });
}
