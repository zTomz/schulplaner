sealed class Either<L, R> {
  const Either();
  factory Either.left(L l) => Left(l);
  factory Either.right(R r) => Right(r);

  T fold<T>(T Function(L) left, T Function(R) right) => switch (this) {
        Left(:final value) => left(value),
        Right(:final value) => right(value),
      };
  bool isLeft() => switch (this) {
        Left() => true,
        Right() => false,
      };
  bool isRight() => !isLeft();

  L? get left => switch (this) {
        Left(:final value) => value,
        Right() => null,
      };
  R? get right => switch (this) {
        Left() => null,
        Right(:final value) => value,
      };
}

class Left<L, R> extends Either<L, R> {
  final L _l;
  const Left(this._l);
  L get value => _l;
}

class Right<L, R> extends Either<L, R> {
  final R _r;
  const Right(this._r);
  R get value => _r;
}