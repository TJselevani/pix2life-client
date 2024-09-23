import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/api_failure.dart';

typedef ResultFuture<T> = Future<Either<ApiFailure, T>>;

typedef ResultVoid = Future<Either<ApiFailure, void>>;

typedef DataMap = Map<String, dynamic>;
