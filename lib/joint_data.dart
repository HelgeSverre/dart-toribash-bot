enum JointState {
  extend,
  contract,
  hold,
  relax,
}

enum Joint {
  neck,
  chest,
  lumbar,
  abs,
  rightPec,
  rightShoulder,
  rightElbow,
  leftPec,
  leftShoulder,
  leftElbow,
  rightWrist,
  leftWrist,
  rightGlute,
  leftGlute,
  rightHip,
  leftHip,
  rightKnee,
  leftKnee,
  rightAnkle,
  leftAnkle,
  leftHand,
  rightHand,
}

class JointData {
  static Map<int, JointState> states = {
    1: JointState.extend,
    2: JointState.contract,
    3: JointState.hold,
    4: JointState.relax,
  };

  static Map<JointState, String> friendlyState = {
    JointState.contract: "Contract",
    JointState.extend: "Extend",
    JointState.relax: "Relax",
    JointState.hold: "Hold",
  };

  static Map<int, Joint> joints = {
    0: Joint.neck,
    1: Joint.chest,
    2: Joint.lumbar,
    3: Joint.abs,
    4: Joint.rightPec,
    5: Joint.rightShoulder,
    6: Joint.rightElbow,
    7: Joint.leftPec,
    8: Joint.leftShoulder,
    9: Joint.leftElbow,
    10: Joint.rightWrist,
    11: Joint.leftWrist,
    12: Joint.rightGlute,
    13: Joint.leftGlute,
    14: Joint.rightHip,
    15: Joint.leftHip,
    16: Joint.rightKnee,
    17: Joint.leftKnee,
    18: Joint.rightAnkle,
    19: Joint.leftAnkle,
    20: Joint.leftHand,
    21: Joint.rightHand,
  };

  static Map<Joint, String> friendlyJoints = {
    Joint.neck: "Neck",
    Joint.chest: "Chest",
    Joint.lumbar: "Lumbar",
    Joint.abs: "Abs",
    Joint.rightPec: "Right Pec",
    Joint.rightShoulder: "Right Shoulder",
    Joint.rightElbow: "Right Elbow",
    Joint.leftPec: "Left Pec",
    Joint.leftShoulder: "Left Shoulder",
    Joint.leftElbow: "Left Elbow",
    Joint.rightWrist: "Right Wrist",
    Joint.leftWrist: "Left Wrist",
    Joint.rightGlute: "Right Glute",
    Joint.leftGlute: "Left Glute",
    Joint.rightHip: "Right Hip",
    Joint.leftHip: "Left Hip",
    Joint.rightKnee: "Right Knee",
    Joint.leftKnee: "Left Knee",
    Joint.rightAnkle: "Right Ankle",
    Joint.leftAnkle: "Left Ankle",
    Joint.leftHand: "Left Hand",
    Joint.rightHand: "Right Hand",
  };

  static Joint getJoint(int jointId) {
    return joints[jointId];
  }

  static JointState getState(int stateId) {
    return states[stateId];
  }

  static String friendlyName(Joint joint, JointState state) {
    var stateName = friendlyState[state];

    if (joint == Joint.chest) {
      if (state == JointState.contract) {
        stateName = "Left Rotate";
      }

      if (state == JointState.extend) {
        stateName = "Left Rotate";
      }
    }

    if (joint == Joint.lumbar) {
      if (state == JointState.contract) {
        stateName = "Left Bend";
      }

      if (state == JointState.extend) {
        stateName = "Right Bend";
      }
    }

    if (joint == Joint.leftShoulder || joint == Joint.rightShoulder) {
      if (state == JointState.contract) {
        stateName = "Raise";
      }

      if (state == JointState.extend) {
        stateName = "Lower";
      }
    }

    return [
      stateName,
      friendlyJoints[joint],
    ].join(" ");
  }
}
