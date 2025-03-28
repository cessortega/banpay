import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:banpay/common/result.dart';

mixin ResultToResponse {
  Future<Result<T>> handleResult<T>(
    Future<Result<T>> Function() doRequest,
  ) async {
    try {
      return await doRequest();
    } on DioException catch (e, stack) {
      return Result.failure(
        'Network error: ${e.message}',
        Cause(e, stack),
      );
    } on DeserializationError catch (e, stack) {
      final message = _deserializationMessage(e);
      return Result.failure(message, Cause(e, stack));
    } on FormatException catch (e, stack) {
      return Result.failure('Parsing error', Cause(e, stack));
    }
  }

  String _deserializationMessage(DeserializationError error) {
    final classes = <String>[];
    DeserializationError? childError = error;
    while (childError != null) {
      classes.add(childError.type.toString());
      final innerError = childError.error;
      if (innerError is DeserializationError) {
        childError = innerError;
      } else {
        break;
      }
    }
    final classesText = classes.join('.');
    final serializationError = childError?.error;
    return 'Error deserializing $classesText: ${serializationError.toString()}';
  }
}
