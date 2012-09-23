#library('drand');
double random() {
  return _DRandom.nextDouble();
}

class _DRandom {
  // Internal state of the random number generator.
  static var _state_high;
  static var _state_low;

  static _init (var init_state) {
    _state_low = init_state & _MASK_32;
    _state_high = init_state >> 32;
  }

  // The algorithm used here is Multiply with Carry (MWC) with a Base b = 2^32.
  // http://en.wikipedia.org/wiki/Multiply-with-carry
  // The constant A is selected from "Numerical Recipes 3rd Edition" p.348 B1.
  static int _nextInt32() {
    //_state = ((_A * (_state & _MASK_32)) + (_state >> 32)) & _MASK_64;
    var mulstate = (_A * _state_low);
    var _state = (mulstate + _state_high) & _MASK_64;
    _state_low  = _state & _M32;
    _state_high = _state >> 32;
    return _state_low;
  }

  static int _nextIntDoubleP2(int max) {
    //_state = ((_A * (_state & _MASK_32)) + (_state >> 32)) & _MASK_64;
    var mulstate = (_D * _state_low) & _M54;
    var _state = _state_high + mulstate;
    _state_low  = _state & _M27;
    _state_high = _state >> 27;
    return _state_low & max;
  }

  static const _MASK_32 = (1 << 32) - 1;
  static const _MASK_64 = (1 << 64) - 1;
  static const _POW2_32 = 1 << 32;
  static const _POW2_53_D = 1.0 * (1 << 53);

  static const _A = 0xffffda61;
  static const _B = 0x7fffda61;
  static const _C = 0x3fffda61;
  static const _D = 0x0fffda61;

  static const _M26 = (1<<26)-1;
  static const _M27 = (1<<27)-1;
  static const _M30 = (1<<30)-1;
  static const _M31 = (1<<31)-1;
  static const _M32 = (1<<32)-1;
  static const _M54 = (1<<54)-1;

  static int _seed = null;
  static double nextDouble() {
    if (_seed == null) {
      _seed = ((new Date.now().millisecondsSinceEpoch) + 0x5A17) & _MASK_64;
      _init(_seed);
    }
    return ((_nextIntDoubleP2(_M26) << 27) + _nextIntDoubleP2(_M27)) / _POW2_53_D.toDouble();
  }
}
