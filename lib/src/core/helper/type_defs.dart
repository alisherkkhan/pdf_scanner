import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
// typedef FutureVoid = FutureEither<void>;
typedef FutureVoid = FutureEither<Unit>;

class Failure {
  final String message;

  Failure({required this.message});

  @override
  String toString() => message;
}

FutureEither<T> handleRepoCall<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return Right(result);
  } catch (e) {
    return Left(Failure(message: e.toString()));
  }
}
