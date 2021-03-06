import 'package:collection/collection.dart';
import 'package:meta/meta.dart';


enum EventCollectionType {
  liveRightNow,
  landingPopular,
  landingHighlights,
  landingStartingSoon,
  landingNextOff,
  landingLiveRightNow,
  landingShocker,
  favorite,
  listView,
  eventView,
  unknown
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
  int get hashCode {
    int hash = type.hashCode;

    for (var s in selector) {
      hash = hash ^ s.hashCode;
    }

    return hash;
  }

  @override
  String toString() {
    return 'EventCollectionKey{type: $type, selector: $selector}';
  }
}