import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:svan_play/util/combine_latest_eager.dart';

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

  static Observable<T> combineLatestEager3<A, B, C, T>(Stream<A> streamOne,
      Stream<B> streamTwo,
      Stream<C> streamThree,
      T combiner(A a, B b, C c)) =>
      new Observable<T>(new CombineLatestEagerStream<T,
          A,
          B,
          C,
          Null,
          Null,
          Null,
          Null,
          Null,
          Null>(
          <Stream<dynamic>>[streamOne, streamTwo, streamThree],
              (A a, B b, [C c, Null d, Null e, Null f, Null g, Null h, Null i]) =>
              combiner(a, b, c)));

}