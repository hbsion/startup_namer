import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/data/event_collection_key.dart';


class EventCollection {
  final EventCollectionKey key;
  final List<int> eventIds;

  EventCollection({@required this.key,
    this.eventIds = const []})
      : assert (key != null),
        assert(eventIds != null);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EventCollection &&
            runtimeType == other.runtimeType &&
            key == other.key &&
            const ListEquality().equals(eventIds, other.eventIds);
  }

  @override
  int get hashCode =>
      key.hashCode ^
      eventIds.hashCode;

}