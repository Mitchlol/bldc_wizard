import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';

class CallStreamBuilder<T> extends StatefulWidget {
  static const Duration DEFAULT_DURATION = Duration(seconds: 4);

  final Widget Function(BuildContext, Function, bool, T) builder;
  final Function call;
  final Stream<T> stream;
  final Duration timeout;
  final bool autoLoad;

  CallStreamBuilder({this.builder, this.call, this.stream, this.timeout = DEFAULT_DURATION, this.autoLoad = false});

  @override
  _CallStreamBuilder createState() => _CallStreamBuilder(builder, call, stream, timeout, autoLoad);
}

class _CallStreamBuilder<T> extends State<CallStreamBuilder<T>> {
  final Widget Function(BuildContext, Function, bool, T) buildFunction;
  final Function callFunction;
  final Stream<T> responseStream;
  final Duration timeout;
  T responseValue;
  bool isLoading;
  CancelableOperation cancelableOperation;
  StreamSubscription subscription;
  bool autoLoad;

  _CallStreamBuilder(this.buildFunction, this.callFunction, this.responseStream, this.timeout, this.autoLoad) {
    this.isLoading = false;
    subscription = responseStream.listen((event) {
      setState(() {
        responseValue = event;
        isLoading = false;
        if (cancelableOperation != null && !cancelableOperation.isCanceled && !cancelableOperation.isCompleted) {
          cancelableOperation.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(autoLoad){
      autoLoad = false;
      callWrapper();
    }
    return buildFunction(context, callWrapper, isLoading, responseValue);
  }


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void callWrapper() {
    setState(() {
      isLoading = true;
      responseValue = null;
      cancelableOperation = CancelableOperation.fromFuture(Future.delayed(timeout).then((value) {
        setState(() {
          isLoading = false;
        });
      }));
    });
    callFunction();
  }
}
