import 'package:toribash_bot/joint_data.dart';

class OpenerParser {
  static List<String> parse(String moves) {
    if (moves.length != 22) {
      throw "Invalid move list length";
    }

    var index = 0;

    return moves.split("").map((char) {
      var joint = JointData.getJoint(index) ?? "UNKNOWN_PART";
      index++;
      switch (char) {
        case "r":
          return "RELAX $joint";
        case "h":
          return "HOLD $joint";
        case "b": // Back?
          return "CONTRACT $joint";
        case "f": // Forward?
          return "EXTEND $joint";
        case "+":
          return "GRAB $joint";
        case "-":
          return "NOGRAB $joint";
        default: // Should not occur
          return "UNKNOWN_STATE $joint";
      }
    }).toList();
  }
}
