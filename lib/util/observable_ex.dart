import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/util/combine_latest_eager.dart';

class ObservableEx {
  static Observable<T> combineLatestEager2<A, B, T>(Stream<A> streamOne, Stream<B> streamTwo, T combiner(A a, B b)) =>
      new Observable<T>(new CombineLatestEagerStream<T,
          A,
          B,
          Null,
          Null,
          Null,
          Null,
          Null,
          Null,
          Null>(
          <Stream<dynamic>>[streamOne, streamTwo],
              (A a, B b,
              [Null c, Null d, Null e, Null f, Null g, Null h, Null i]) =>
              combiner(a, b)));

}