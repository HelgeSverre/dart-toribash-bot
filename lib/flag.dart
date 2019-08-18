class Flag {
  // Disqualification enabled or not
  bool _dq;

  bool get dq => _dq;

  // Dismemberment enabled or not
  bool _dm;

  bool get dm => _dm;

  // Fracture enabled or not
  bool _frac;

  bool get frac => _frac;

  // Grip enabled or not
  bool _grip;

  bool get grip => _grip;

  // The raw flag number
  int _flag;

  int get flag => _flag;

  Flag(int flag) {
    this._flag = flag;
    //@formatter:off
    switch (flag) {
      // zero-case is inferred from the game settings, this value is most likely invalid.
      case 0: _dq = false; _dm = false; _frac = false; _grip = false; break;
      case 1: _dq = true; _dm = false; _frac = false; _grip = true; break;
      case 2: _dq = false; _dm = true; _frac = false; _grip = true; break;
      case 3: _dq = true; _dm = true; _frac = false; _grip = true; break;
      case 4: _dq = false; _dm = false; _frac = false; _grip = false; break;
      case 5: _dq = true; _dm = false; _frac = false; _grip = false; break;
      case 6: _dq = false; _dm = true; _frac = false; _grip = false; break;
      case 7: _dq = true; _dm = true; _frac = false; _grip = false; break;
      case 8: _dq = false; _dm = false; _frac = true; _grip = true; break;
      case 9: _dq = true; _dm = false; _frac = true; _grip = true; break;
      case 10: _dq = false; _dm = true; _frac = true; _grip = true; break;
      case 11: _dq = true; _dm = true; _frac = true; _grip = true; break;
      case 12: _dq = false; _dm = false; _frac = true; _grip = false; break;
      case 13: _dq = true; _dm = false; _frac = true; _grip = false; break;
      case 14: _dq = false; _dm = true; _frac = true; _grip = false; break;
      case 15: _dq = true; _dm = true; _frac = true; _grip = false; break;
      case 16: _dq = false; _dm = false; _frac = false; _grip = true; break;
      default: throw "Invalid flag";
    }
    //@formatter:on
  }

}
