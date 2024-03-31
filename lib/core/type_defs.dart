import 'package:flutter_twitter_clone/core/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitheVoid = FutureEither<void>;
