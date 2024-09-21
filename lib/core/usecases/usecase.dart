import 'package:pix2life/core/utils/typeDef.dart';

abstract interface class UseCase<SuccessType, Params> {
  ResultFuture<SuccessType> call(Params params);
}

abstract interface class UseCaseWithoutParams<SuccessType> {
  ResultFuture<SuccessType> call();
}
