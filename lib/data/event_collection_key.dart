import 'package:collection/collection.dart';
import 'package:meta/meta.dart';


enum EventCollectionType {
  LiveRightNow,
  Popular,
  Highlights,
  Favorite,
  ListView,
}

class EventCollectionKey {
  final EventCollectionType type;
  final List<String> selector;

  EventCollectionKey({@required this.type, this.selector = const []}):assert (type != null), assert(selector != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EventCollectionKey &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              const ListEquality().equals(selector, other.selector);

  @override
  int get hashCode =>
      type.hashCode ^
      selector.hashCode;

  @override
  String toString() {
    return 'EventCollectionKey{type: $type, selector: $selector}';
  }


}