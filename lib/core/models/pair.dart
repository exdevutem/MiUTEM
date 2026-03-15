import "dart:convert";

class Pair<A, B> {
  final A a;
  final B b;

  Pair(this.a, this.b);

  Map<String, Object?> toJson() => {
    "a": a,
    "b": b,
  };

  @override
  String toString() => jsonEncode(toJson());
}