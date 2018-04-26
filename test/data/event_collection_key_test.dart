import 'package:startup_namer/data/event_collection_key.dart';
import 'package:test/test.dart';


main() {
  test("Keys should be equal", () {
    EventCollectionKey key1 = new EventCollectionKey(
        type: EventCollectionType.ListView, selector: ["football", "sweden", "allsevenskan"]);
    EventCollectionKey key2 = new EventCollectionKey(
        type: EventCollectionType.ListView, selector: ["football", "sweden", "allsevenskan"]);

    expect(key1 == key2, true);
  });

  test("Keys should be not equal", () {
    EventCollectionKey key1 = new EventCollectionKey(
        type: EventCollectionType.ListView, selector: ["football", "sweden", "allsevenskan"]);
    EventCollectionKey key2 = new EventCollectionKey(
        type: EventCollectionType.ListView, selector: ["football", "england", "allsevenskan"]);

    expect(key1 == key2, false);
  });

  test("Hashcode should match", () {
    EventCollectionKey key1 = new EventCollectionKey(
        type: EventCollectionType.ListView, selector: ["football", "sweden", "allsevenskan"]);
    EventCollectionKey key2 = new EventCollectionKey(
        type: EventCollectionType.ListView, selector: ["football", "sweden", "allsevenskan"]);

    expect(key1.hashCode, key2.hashCode);
  });

  test("Hashcode should not match", () {
    EventCollectionKey key1 = new EventCollectionKey(
        type: EventCollectionType.ListView, selector: ["football", "sweden", "allsevenskan"]);
    EventCollectionKey key2 = new EventCollectionKey(
        type: EventCollectionType.ListView, selector: ["football", "england", "allsevenskan"]);

    expect(key1.hashCode == key2.hashCode, false);
  });
}