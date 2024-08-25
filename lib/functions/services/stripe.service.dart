// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:pix2life/config/app/app.config.dart';
// import 'package:pix2life/config/logger/logger.dart';
// import 'package:pix2life/functions/errors/errors.dart';
// import 'package:pix2life/functions/services/api.services.dart';

// class StripeService {
//   final ApiService apiService = ApiService();
//   final log = logger(StripeService);
//   StripeService._();

//   static final StripeService instance = StripeService._();

//   Future<void> makePayment(int amount, String currency) async {
//     try {
//       String? _paymentIntentClientSecret =
//           await createPaymentIntent(amount, currency);
//       if (_paymentIntentClientSecret == null) return;
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: _paymentIntentClientSecret,
//             merchantDisplayName: "test"),
//       );
//       await processPayment();
//     } catch (e, stackTrace) {
//       log.e('Error making payment: ${e}');
//       log.e(stackTrace.toString());
//     }
//   }

//   Future<String?> createPaymentIntent(int amount, String currency) async {
//     try {
//       final url = '${AppConfig.baseUrl}/payment/stripe/create-payment-intent';
//       Map<String, dynamic> paymentData = {
//         "amount": _calculateAmountInUSD(amount),
//         "currency": currency
//       };
//       final responseData = await apiService.sendData(paymentData, url);
//       final clientSecret = responseData['clientSecret'];

//       if (clientSecret == null) {
//         throw new NotFoundError(
//             message: 'Unable to Initiate payment, client key missing');
//       }
//       log.w(clientSecret);
//       return clientSecret;
//     } catch (e) {
//       log.e('Error creating payment Intent: ${e}');
//       return null;
//     }
//   }

//   int _calculateAmountInUSD(int amount) {
//     final total = amount * 100;
//     return total;
//   }

//   Future<void> processPayment() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       await Stripe.instance.confirmPaymentSheetPayment();
//     } catch (e, stackTrace) {
//       log.e('Error processing payment: ${e}');
//       log.e(stackTrace.toString());
//     }
//   }
// }
