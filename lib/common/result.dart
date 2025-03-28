import 'dart:async';

typedef EmptyResult = Result<EmptyContent>;
typedef EmptyFailure = Failure<EmptyContent>;

typedef FutureResult<T> = Future<Result<T>>;

typedef ConcatResult<F, S> = ({F first, S second});

const _errorOnSuccess = 'Error processing success data';

abstract class Result<T> {
  const Result();

  const factory Result.success(T data) = Success;

  const factory Result.successFromCache(T data) = SuccessFromCache;

  const factory Result.failure(String message, [Cause? cause]) = Failure;

  static EmptyResult emptySuccess() => const Success(EmptyContent());

  bool get isSuccess => this is Success<T>;

  bool get isSuccessFromCache => this is SuccessFromCache<T>;

  bool get isFailure => this is Failure;

  Success<T>? asSuccessOrNull() {
    if (!isSuccess) return null;

    return this as Success<T>;
  }

  Failure<T>? asFailureOrNull() {
    if (!isFailure) return null;

    final failure = this as Failure<T>;

    return failure;
  }

  void thenDo(
    void Function(Success<T> success) onSuccess,
    void Function(Failure<T> failure)? onFailure,
  ) {
    if (isSuccess) {
      try {
        onSuccess(this as Success<T>);
      } catch (e, stackTrace) {
        final failure = Failure<T>(_errorOnSuccess, Cause(e, stackTrace));

        onFailure?.call(failure);
      }
    } else if (onFailure != null) {
      onFailure(this as Failure<T>);
    }
  }

  void onFailureThenDo(
    void Function(Failure<T> failure)? onFailure,
  ) {
    final failure = asFailureOrNull();
    if (onFailure != null && failure != null) {
      onFailure(this as Failure<T>);
    }
  }

  Result<R> map<R>({
    required R Function(T data) onSuccess,
    Result<R> Function(Failure<T> failure)? onFailure,
  }) {
    if (isSuccess) {
      try {
        final value = onSuccess((this as Success<T>).data);

        return Result.success(value);
      } catch (e, stackTrace) {
        final cause = Cause(e, stackTrace);
        final failure = Failure<T>(_errorOnSuccess, cause);

        if (onFailure != null) {
          return onFailure(failure);
        } else {
          return failure as Result<R>;
        }
      }
    } else if (onFailure == null) {
      return Result.failure(
        (this as Failure).message,
        (this as Failure).cause,
      );
    } else {
      return onFailure(this as Failure<T>);
    }
  }

  FutureResult<R> mapAsync<R>({
    required FutureResult<R> Function(T data) onSuccess,
    FutureResult<R> Function(Failure<T> failure)? onFailure,
  }) async {
    if (isSuccess) {
      try {
        return await onSuccess((this as Success<T>).data);
      } catch (e, stackTrace) {
        final cause = Cause(e, stackTrace);

        if (onFailure != null) {
          return onFailure(Failure<T>(_errorOnSuccess, cause));
        } else {
          return Result.failure(e.toString(), cause);
        }
      }
    } else if (onFailure == null) {
      return Result.failure(
        (this as Failure).message,
        (this as Failure).cause,
      );
    } else {
      return onFailure(this as Failure<T>);
    }
  }

  FutureResult<ConcatResult<T, R>> mapAsyncConcat<R>(
    FutureResult<R> Function(T data) onSuccess, [
    FutureResult<T> Function(Failure<T> failure)? onFailure,
  ]) async {
    final success = asSuccessOrNull();

    if (success != null) {
      try {
        final value = await onSuccess((this as Success<T>).data);

        return value.map(onSuccess: (newData) {
          return (first: success.data, second: newData);
        });
      } catch (e, stackTrace) {
        final cause = Cause(e, stackTrace);

        if (onFailure != null) {
          final failureResponse =
              await onFailure(Failure<T>(_errorOnSuccess, cause));

          return Result.failure(
            (failureResponse as Failure).message,
            (failureResponse as Failure).cause,
          );
        } else {
          return Result.failure(e.toString(), cause);
        }
      }
    } else if (onFailure == null) {
      return Result.failure(
        (this as Failure).message,
        (this as Failure).cause,
      );
    } else {
      final failure = await onFailure(this as Failure<T>);

      return Result.failure(
        (failure as Failure).message,
        (failure as Failure).cause,
      );
    }
  }

  Map<String, dynamic> get publicProperties {
    return {'is_offline': asSuccessOrNull()?.isSuccessFromCache ?? false};
  }
}

class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

class SuccessFromCache<T> extends Success<T> {
  const SuccessFromCache(super.data);
}

class Failure<T> extends Result<T> {
  const Failure(this.message, [this.cause]);

  final String message;
  final Cause? cause;

  @override
  String toString() {
    return 'Failure{message: $message, cause: $cause}';
  }
}

class Cause {
  const Cause(this.error, [this.stackTrace, this.extras = const {}]);

  final dynamic error;
  final StackTrace? stackTrace;
  final Map<String, dynamic> extras;

  @override
  String toString() {
    return 'Cause{error: $error, stackTrace: $stackTrace, extras: $extras}';
  }
}

class EmptyContent {
  const EmptyContent();
}

extension FutureResultExtension<T> on FutureResult<T> {
  FutureResult<R> mapAsync<R>(
    FutureResult<R> Function(T data) onSuccess, [
    FutureResult<R> Function(Failure<T> failure)? onFailure,
  ]) async {
    return (await this).mapAsync(onSuccess: onSuccess, onFailure: onFailure);
  }

  FutureResult<ConcatResult<T, R>> mapAsyncConcat<R>(
    FutureResult<R> Function(T data) onSuccess, [
    FutureResult<T> Function(Failure<T> failure)? onFailure,
  ]) async {
    return (await this).mapAsyncConcat(onSuccess, onFailure);
  }

  Future<void> thenDoAsync(
    void Function(Success<T> success) onSuccess,
    void Function(Failure<T> failure)? onFailure,
  ) async {
    (await this).thenDo(onSuccess, onFailure);
  }

  Future<void> onFailureThenDoAsync(
    void Function(Failure<T> failure)? onFailure,
  ) async {
    (await this).onFailureThenDo(onFailure);
  }
}

extension ResultListExtension<T> on Iterable<Result<T>> {
  Result<List<R>> flatMap<R>(Result<R> Function(T value) mapper) {
    final results = <R>[];

    for (final result in this) {
      if (result.isFailure) {
        return Result.failure((result as Failure<T>).message, result.cause);
      } else if (result.isSuccess) {
        final mappedResult = mapper((result as Success<T>).data);

        if (mappedResult.isFailure) {
          return Result.failure(
            (mappedResult as Failure<R>).message,
            mappedResult.cause,
          );
        } else if (mappedResult.isSuccess) {
          results.add((mappedResult as Success<R>).data);
        }
      }
    }

    return Result.success(results);
  }
}

extension FlatMapAsyncExtension<T> on Iterable<FutureResult<T>> {
  Future<Result<List<R>>> flatMapAsync<R>(
      Future<Result<R>> Function(T value) mapper) async {
    final results = <R>[];

    for (final resultFuture in this) {
      final result = await resultFuture;

      if (result.isFailure) {
        return Result.failure((result as Failure<T>).message, result.cause);
      } else if (result.isSuccess) {
        final mappedResult = await mapper((result as Success<T>).data);

        if (mappedResult.isFailure) {
          return Result.failure(
            (mappedResult as Failure<R>).message,
            mappedResult.cause,
          );
        } else if (mappedResult.isSuccess) {
          results.add((mappedResult as Success<R>).data);
        }
      }
    }

    return Result.success(results);
  }
}
