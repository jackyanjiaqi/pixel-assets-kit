import 'package:flutter/widgets.dart';
/// copied from flame avoid include the whole flame files.
@immutable
class Anchor {
  static const Anchor topLeft = Anchor(0.0, 0.0);
  static const Anchor topCenter = Anchor(0.5, 0.0);
  static const Anchor topRight = Anchor(1.0, 0.0);
  static const Anchor centerLeft = Anchor(0.0, 0.5);
  static const Anchor center = Anchor(0.5, 0.5);
  static const Anchor centerRight = Anchor(1.0, 0.5);
  static const Anchor bottomLeft = Anchor(0.0, 1.0);
  static const Anchor bottomCenter = Anchor(0.5, 1.0);
  static const Anchor bottomRight = Anchor(1.0, 1.0);

  /// The relative x position with respect to the object's width;
  /// 0 means totally to the left (beginning) and 1 means totally to the
  /// right (end).
  final double x;

  /// The relative y position with respect to the object's height;
  /// 0 means totally to the top (beginning) and 1 means totally to the
  /// bottom (end).
  final double y;

  const Anchor(this.x, this.y);

  /// Returns a string representation of this Anchor.
  ///
  /// This should only be used for serialization purposes.
  String get name {
    return _valueNames[this] ?? 'Anchor($x, $y)';
  }

  /// Returns a string representation of this Anchor.
  ///
  /// This is the same as `name` and should be used only for debugging or
  /// serialization.
  @override
  String toString() => name;

  static final Map<Anchor, String> _valueNames = {
    topLeft: 'topLeft',
    topCenter: 'topCenter',
    topRight: 'topRight',
    centerLeft: 'centerLeft',
    center: 'center',
    centerRight: 'centerRight',
    bottomLeft: 'bottomLeft',
    bottomCenter: 'bottomCenter',
    bottomRight: 'bottomRight',
  };

  /// List of all predefined anchor values.
  static final List<Anchor> values = _valueNames.keys.toList();

  /// This should only be used for de-serialization purposes.
  ///
  /// If you need to convert anchors to serializable data (like JSON),
  /// use the `toString()` and `valueOf` methods.
  factory Anchor.valueOf(String name) {
    if (_valueNames.containsValue(name)) {
      return _valueNames.entries.singleWhere((e) => e.value == name).key;
    } else {
      final regexp = RegExp(r'^\Anchor\(([^,]+), ([^\)]+)\)');
      final matches = regexp.firstMatch(name)?.groups([1, 2]);
      assert(
        matches != null && matches.length == 2,
        'Bad anchor format: $name',
      );
      return Anchor(double.parse(matches![0]!), double.parse(matches[1]!));
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Anchor && x == other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode * 31 + y.hashCode;
}
