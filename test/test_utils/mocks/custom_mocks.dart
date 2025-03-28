// ignore_for_file: prefer-match-file-name

import 'package:banpay/common/route/router.dart';
import 'package:mockito/mockito.dart';

class MockRouter extends Mock implements Router {
  @override
  Future<T?> pushTo<T extends ActionResult?>(
    PathRoute<T>? route, {
    bool shouldShowAsDialog = false,
  }) async {
    final result = await super.noSuchMethod(Invocation.method(
      #pushTo,
      [route, shouldShowAsDialog],
    ));

    // Force the cast to T? to avoid returning an ActionResult
    // instead of the expected T
    return result as T?;
  }

  @override
  Future<T?> replaceTo<T extends ActionResult?>(
    PathRoute<T>? route, {
    bool shouldShowAsDialog = false,
  }) async {
    final result = await super.noSuchMethod(Invocation.method(
      #replaceTo,
      [route, shouldShowAsDialog],
    ));

    // Force the cast to T? to avoid returning an ActionResult
    // instead of the expected T
    return result as T?;
  }
}

mixin _CallbackAction {
  void call();
}

class CallbackActionMock extends Mock implements _CallbackAction {}
