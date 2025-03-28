// ignore_for_file: prefer-match-file-name
import 'package:banpay/common/result.dart';
import 'package:mockito/mockito.dart';

extension ResultMock<T> on PostExpectation<Future<Result<T>>> {
  void thenSucceed(T body) {
    final result = Result.success(body);
    thenAnswer((realInvocation) => Future.value(result));
  }

  void thenFail(String s, {String message = 'error'}) {
    final result = Result<T>.failure(message);
    thenAnswer((realInvocation) => Future.value(result));
  }
}
