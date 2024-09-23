import 'package:pix2life/core/utils/type_def.dart';

abstract interface class UseCase<SuccessType, Params> {
  ResultFuture<SuccessType> call(Params params);
}

abstract interface class UseCaseWithoutParams<SuccessType> {
  ResultFuture<SuccessType> call();
}
