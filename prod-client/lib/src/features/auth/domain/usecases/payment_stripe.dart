import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';

class StripePaymentParams extends Equatable {
  final DataMap paymentData;

  const StripePaymentParams({
    required this.paymentData,
  });

  StripePaymentParams.empty() : this(paymentData: {});

  @override
  List<Object?> get props => [paymentData];
}

class StripePayment implements UseCase<String, StripePaymentParams> {
  final AuthRepository _authRepository;
  const StripePayment(this._authRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _authRepository.stripePayment(
      paymentData: params.paymentData,
    );
  }
}
