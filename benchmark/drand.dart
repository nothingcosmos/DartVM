#library('drand');
class DRandom {

  factory DRandom([int seed]) {
    if (seed == null) {
      seed = _DRandom._nextSeed();
    }
    do {
      seed = (seed + 0x5A17) & _DRandom._MASK_64;
    } while (seed == 0);
    return new _DRandom._internal(seed);
  }
}

class _DRandom implements DRandom {
  // Internal state of the random number generator.
  var _state_high;
  var _state_low;

  _DRandom._internal(var init_state) {
    _state_low = init_state & _MASK_32;
    _state_high = init_state >> 32;
  }

  // The algorithm used here is Multiply with Carry (MWC) with a Base b = 2^32.
  // http://en.wikipedia.org/wiki/Multiply-with-carry
  // The constant A is selected from "Numerical Recipes 3rd Edition" p.348 B1.
  int _nextInt32() {
    //_state = ((_A * (_state & _MASK_32)) + (_state >> 32)) & _MASK_64;
    var mulstate = (_A * _state_low);
    var _state = (mulstate + _state_high) & _MASK_64;
    _state_low  = _state & _M32;
    _state_high = _state >> 32;
    return _state_low;
  }

  int _nextIntDP2(int max) {
    //_state = ((_A * (_state & _MASK_32)) + (_state >> 32)) & _MASK_64;
    var mulstate = (_D * _state_low) & _M54;
    var _state = _state_high + mulstate;
    _state_low  = _state & _M27;
    _state_high = _state >> 27;
    return _state_low & max;
  }

  static const _M26 = (1<<26)-1;
  static const _M27 = (1<<27)-1;
  static const _M30 = (1<<30)-1;
  static const _M31 = (1<<31)-1;
  static const _M32 = (1<<32)-1;
  static const _M54 = (1<<54)-1;

  double nextDouble() {
    return ((_nextIntDP2(_M26) << 27) + _nextIntDP2(_M27)) / _POW2_53_D.toDouble();
  }

  // Constants used by the algorithm or masking.
  static const _MASK_32 = (1 << 32) - 1;
  static const _MASK_64 = (1 << 64) - 1;
  static const _POW2_32 = 1 << 32;
  static const _POW2_53_D = 1.0 * (1 << 53);

  static const _A = 0xffffda61;
  static const _B = 0x7fffda61;
  static const _C = 0x3fffda61;
  static const _D = 0x0fffda61;

  // Use a singleton DRandom object to get a new seed if no seed was passed.
  static var _prng = null;

  static int _nextSeed() {
    if (_prng == null) {
      // TODO(iposva): Use system to get a random seed.
      _prng = new DRandom(new Date.now().millisecondsSinceEpoch);
    }
    // Trigger the PRNG once to change the internal state.
    _prng._nextInt32();
    return (_prng._state_high << 32) + _prng._state_low;
  }
}
