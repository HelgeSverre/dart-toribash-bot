import 'dart:core';

import 'flag.dart';

class GameRules {
  int matchFrames;
  List<int> turnFrames;
  int reactionTime;
  Flag flags;
  int engageDistance;

  //  0 - You can damage your opponent but not yourself.
  //  1 - You can damage your opponent and yourself.
  //  2 - You can't damage your opponent but you can damage yourself.
  int damage;

  // If enabled, wrists and ankles don't trigger a DQ
  bool sumo;
  String mod;
  int dismemberThreshold;
  int fractureThreshold;
  int engageHeight;
  int engageRotation;
  int engageSpace;
  int DQTimeOut;
  int dojoSize;

  // 0 = Square, 1 = Circle
  int dojoType;
  num gravityX;
  num gravityZ;
  num gravityY;
  int DQFlag;
  int drawWinner;
  int pointThreshold;
  int maxContacts;

  GameRules.fromString(String rule) {
    var ruleVars = rule.replaceFirst("NEWGAME 1;", "").split(" ");

    if (ruleVars.length == 10) {
      return;
    }

    this.matchFrames = int.parse(ruleVars[0]);
    this.turnFrames = ruleVars[1].split(",").map((f) => int.parse(f)).toList();
    this.reactionTime = int.parse(ruleVars[2]);
    this.mod = ruleVars[9];
    this.engageDistance = int.parse(ruleVars[6]);
    this.damage = int.parse(ruleVars[7]);
    this.gravityX = num.parse(ruleVars[25]);
    this.gravityZ = num.parse(ruleVars[26]);
    this.gravityY = num.parse(ruleVars[27]);
    this.dojoSize = int.parse(ruleVars[11]);
    this.dojoType = int.parse(ruleVars[24]);
    this.dismemberThreshold = int.parse(ruleVars[12]);
    this.fractureThreshold = int.parse(ruleVars[13]);
    this.engageHeight = int.parse(ruleVars[14]);
    this.engageRotation = int.parse(ruleVars[19]);
    this.engageSpace = int.parse(ruleVars[21]);
    this.DQTimeOut = int.parse(ruleVars[22]);
    this.DQFlag = int.parse(ruleVars[28]);
    this.sumo = int.parse(ruleVars[8]) == 1 ? true : false;
    this.flags = Flag(int.parse(ruleVars[5]));
    this.drawWinner = int.parse(ruleVars[33]);
    this.maxContacts = int.parse(ruleVars[32]);
    this.pointThreshold = int.parse(ruleVars[31]);
  }
}
