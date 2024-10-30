import 'package:pix2life/core/utils/type_def.dart';

class PaymentStripeResponse {
  final String clientSecret;

  PaymentStripeResponse({required this.clientSecret});

  factory PaymentStripeResponse.fromJson(DataMap json) {
    return PaymentStripeResponse(
      clientSecret: json['clientSecret'],
    );
  }
}
