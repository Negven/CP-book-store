

enum SizeVariant {

  none, // Making separate value to be able set not null values and support

  xxs,
  xs,

  sm,
  md,
  lg,

  xl,
  xxl;

  T from<T>(SizedValue<T> v) {
    return v.get(this);
  }

  SizeVariant get smaller {
    return index > 0 ? SizeVariant.values[index - 1] : none;
  }

  SizeVariant get bigger {
    if (this == none) return none;
    return index + 1 < SizeVariant.values.length ? SizeVariant.values[index + 1] : none;
  }

  bool get isNone => this == none;

  static SizeVariant nvl(SizeVariant? size, SizeVariant? templateSize, [SizeVariant defaultValue =  SizeVariant.none])
    => size ?? templateSize ?? defaultValue;
  // Aliases
  static const base = sm;

  static const smTOmd = [sm, md];
  static const xsTOmd = [xs, sm, md];
  static const xsTOxl = [xs, sm, md, lg, xl];
  static const xsTOxxl = [xs, sm, md, lg, xl, xxl];

}

class SizedValue<T> {

  final T? _xxs;
  final T? _xs;
  final T? _sm;
  final T? _md;

  final T? _lg;
  final T? _xl;
  final T? _xxl;

  const SizedValue({T? xxs, T? xs, T? sm, T? md, T? lg, T? xl, T? xxl}) :
        _xxs = xxs, _xxl = xxl, _xl = xl, _lg = lg, _md = md, _sm = sm, _xs = xs;

  T get xxs => _xxs!;
  T get xs => _xs!;
  T get sm => _sm!;
  T get md => _md!;

  T get lg => _lg!;
  T get xl => _xl!;
  T get xxl => _xxl!;

  T get base => get(SizeVariant.base);

  T get(SizeVariant size) => _get(size)!;
  T tryGet(SizeVariant? size, T fallback) => size == null || size.isNone ? fallback : _get(size) ?? fallback;

  T? _get(SizeVariant size) {

    switch(size) {
      case SizeVariant.xxs:
        return _xxs;
      case SizeVariant.xs:
        return _xs;
      case SizeVariant.sm:
        return _sm;
      case SizeVariant.md:
        return _md;
      case SizeVariant.lg:
        return _lg;
      case SizeVariant.xl:
        return _xl;
      case SizeVariant.xxl:
        return _xxl;
      case SizeVariant.none:
        throw "Can't return none value";
    }

    // ignore: dead_code
    throw "Unknown size $size";
  }

  T smaller(SizeVariant size, T fallback) => tryGet(size.smaller, fallback);
  T bigger(SizeVariant size, T fallback) => tryGet(size.bigger, fallback);

  SizedValue<N> map<N>(N Function(T) mapper) {
    return SizedValue<N>(
      xxs: _xxs != null ? mapper(_xxs as T) : null,
      xs: _xs != null ? mapper(_xs as T) : null,
      sm: _sm != null ? mapper(_sm as T) : null,
      md: _md != null ? mapper(_md as T) : null,
      lg: _lg != null ? mapper(_lg as T) : null,
      xl: _xl != null ? mapper(_xl as T) : null,
      xxl: _xxl != null ? mapper(_xxl as T) : null,
    );
  }

  static SizedValue<C> mapDuo<A,B,C>(SizedValue<A> a, SizedValue<B> b, C Function(A,B) mapper) {
    return SizedValue<C>(
        xxs: mapper(a.xxs, b.xxs),
        xs: mapper(a.xs, b.xs),
        sm: mapper(a.sm, b.sm),
        md: mapper(a.md, b.md),
        lg: mapper(a.lg, b.lg),
        xl: mapper(a.xl, b.xl),
        xxl: mapper(a.xxl, b.xxl)
    );
  }
}