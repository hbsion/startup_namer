import 'dart:async';

class CombineLatestEagerStream<T, A, B, C, D, E, F, G, H, I> extends Stream<T> {
  final StreamController<T> controller;

  CombineLatestEagerStream(Iterable<Stream<dynamic>> streams,
      T combiner(A a, B b, [C c, D d, E e, F f, G g, H h, I i]))
      : controller = _buildController(streams, combiner);

  @override
  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    return controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamController<T> _buildController<T, A, B, C, D, E, F, G, H, I>(Iterable<Stream<dynamic>> streams,
      T combiner(A a, B b, [C c, D d, E e, F f, G g, H h, I i])) {
    if (streams == null) {
      throw new ArgumentError('streams cannot be null');
    } else if (streams.isEmpty) {
      throw new ArgumentError('provide at least 1 stream');
    } else if (combiner == null) {
      throw new ArgumentError('combiner cannot be null');
    }

    final List<StreamSubscription<dynamic>> subscriptions =
    new List<StreamSubscription<dynamic>>(streams.length);
    StreamController<T> controller;

    controller = new StreamController<T>(
        sync: true,
        onListen: () {
          final List<dynamic> values = new List<dynamic>(streams.length);
//          final List<bool> triggered =
//              new List<bool>.generate(streams.length, (_) => false);
          final List<bool> completedStatus =
          new List<bool>.generate(streams.length, (_) => false);
//          bool allStreamsHaveEvents = false;

          for (int i = 0, len = streams.length; i < len; i++) {
            Stream<dynamic> stream = streams.elementAt(i);

            subscriptions[i] = stream.listen(
                    (dynamic value) {
                  values[i] = value;
//                  triggered[i] = true;

//                  if (!allStreamsHaveEvents)
//                    allStreamsHaveEvents =
//                        triggered.reduce((bool a, bool b) => a && b);
//
//                  if (allStreamsHaveEvents)
                  updateWithValues(combiner, values, controller);
                },
                onError: controller.addError,
                onDone: () {
                  completedStatus[i] = true;

                  if (completedStatus.reduce((bool a, bool b) => a && b))
                    controller.close();
                });
          }
        },
        onCancel: () =>
            Future.wait<dynamic>(subscriptions
                .map((StreamSubscription<dynamic> subscription) =>
                subscription.cancel())
                .where((Future<dynamic> cancelFuture) => cancelFuture != null)));

    return controller;
  }

  static void updateWithValues<T, A, B, C, D, E, F, G, H, I>(T combiner(A a, B b, [C c, D d, E e, F f, G g, H h, I i]),
      Iterable<dynamic> values,
      StreamController<T> controller) {
    try {
      final int len = values.length;
      final A a = values.elementAt(0);
      final B b = values.elementAt(1);
      T result;

      switch (len) {
        case 2:
          result = combiner(a, b);
          break;
        case 3:
          final C c = values.elementAt(2);

          result = combiner(a, b, c);
          break;
        case 4:
          final C c = values.elementAt(2);
          final D d = values.elementAt(3);

          result = combiner(a, b, c, d);
          break;
        case 5:
          final C c = values.elementAt(2);
          final D d = values.elementAt(3);
          final E e = values.elementAt(4);

          result = combiner(a, b, c, d, e);
          break;
        case 6:
          final C c = values.elementAt(2);
          final D d = values.elementAt(3);
          final E e = values.elementAt(4);
          final F f = values.elementAt(5);

          result = combiner(a, b, c, d, e, f);
          break;
        case 7:
          final C c = values.elementAt(2);
          final D d = values.elementAt(3);
          final E e = values.elementAt(4);
          final F f = values.elementAt(5);
          final G g = values.elementAt(6);

          result = combiner(a, b, c, d, e, f, g);
          break;
        case 8:
          final C c = values.elementAt(2);
          final D d = values.elementAt(3);
          final E e = values.elementAt(4);
          final F f = values.elementAt(5);
          final G g = values.elementAt(6);
          final H h = values.elementAt(7);

          result = combiner(a, b, c, d, e, f, g, h);
          break;
        case 9:
          final C c = values.elementAt(2);
          final D d = values.elementAt(3);
          final E e = values.elementAt(4);
          final F f = values.elementAt(5);
          final G g = values.elementAt(6);
          final H h = values.elementAt(7);
          final I i = values.elementAt(8);

          result = combiner(a, b, c, d, e, f, g, h, i);
          break;
      }

      controller.add(result);
    } catch (e, s) {
      controller.addError(e, s);
    }
  }
}
