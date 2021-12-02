import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef GetXWidgetBuilder<T> = Widget Function(T data);

class GetXStreamView<I extends DisposableInterface, T> extends GetView<I> {
  final GetXWidgetBuilder<T> builder;
  final AsyncWidgetBuilder<T>? errorBuilder;
  final AsyncWidgetBuilder<T>? loadingBuilder;
  final Rx<Stream<T>> rxStream;

  const GetXStreamView(
      {required this.rxStream,
      required this.builder,
      this.errorBuilder,
      this.loadingBuilder
      // this.streamController
      });

  @override
  Widget build(BuildContext context) => GetX<I>(
        builder: (controller) => StreamBuilder<T>(
            stream: rxStream.value,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingBuilder?.call(context, snapshot) ??
                    Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return errorBuilder?.call(context, snapshot) ??
                    Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
              }
              return builder(snapshot.requireData);
            }),
      );
}

class GetXFutureView<I extends DisposableInterface, T> extends GetView<I> {
  final GetXWidgetBuilder<T> builder;
  final AsyncWidgetBuilder<T>? errorBuilder;
  final AsyncWidgetBuilder<T>? loadingBuilder;
  final Rx<Future<T>> rxFuture;

  const GetXFutureView({
    required this.rxFuture,
    required this.builder,
    this.errorBuilder,
    this.loadingBuilder,
    // this.streamController
  });

  @override
  Widget build(BuildContext context) => GetX<I>(
        builder: (controller) => FutureBuilder<T>(
            future: rxFuture.value,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return builder(snapshot.requireData);
              } else if (snapshot.hasError) {
                print(snapshot.error);
                print(snapshot.stackTrace);
                return errorBuilder?.call(context, snapshot) ??
                    Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
              }

              // By default, show a loading spinner.
              return loadingBuilder?.call(context, snapshot) ??
                  Container(
                      margin: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()));
            }),
      );
}

class GetXStream<P, T> {
  final data = Stream.value(<T>[]).obs;
  final P provider;
  final Response<T> Function(P api) perform;

  GetXStream(this.provider, this.perform);

/*void getData(Query<T> Function(FirebaseFirestore) makeQuery) {
    data.value = (makeQuery(Get.find<FirebaseFirestore>())
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList()));
  }*/
}

/*
class GetXFuture<P, T> {
  bool isFetched = false;
  late T value;
  final data = Future.value(<T>[]).obs;
  final P provider;
  final Future<Response<T>> Function(P api) perform;

  GetXFuture(this.provider, this.perform);

  Future<void> _perform() async {
    final result = await perform(provider);
    this.isFetched = true;
  }
}
*/
