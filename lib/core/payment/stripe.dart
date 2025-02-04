import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pix2life/core/error/http_errors.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/logger/logger.dart';

class StripeService {
  final log = createLogger(StripeService);
  StripeService._();

  static final StripeService instance = StripeService._();
  final Dio _dio = Dio(); // Initialize Dio instance
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> makePayment(int amount, String currency) async {
    try {
      String? paymentIntentClientSecret =
          await createPaymentIntent(amount, currency);
      if (paymentIntentClientSecret == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "test",
        ),
      );
      await processPayment();
    } catch (e, stackTrace) {
      log.e('Error making payment: $e');
      log.e(stackTrace.toString());
    }
  }

  Future<String?> createPaymentIntent(int amount, String currency) async {
    try {
      final url = '${AppSecrets.baseUrl}/payment/stripe/create-payment-intent';
      Map<String, dynamic> paymentData = {
        "amount": _calculateAmountInUSD(amount),
        "currency": currency,
      };

      // Make POST request with Dio
      final String? token = await _storage.read(key: 'auth_token');
      final response = await _dio.post(
        url,
        data: paymentData,
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Check response status and parse client secret
      if (response.statusCode == 200 && response.data != null) {
        final clientSecret = response.data['clientSecret'];

        if (clientSecret == null) {
          throw NotFoundError(
            message: 'Unable to Initiate payment, client key missing',
          );
        }

        log.w(clientSecret);
        return clientSecret;
      } else {
        log.e('Error creating payment Intent: ${response.statusMessage}');
        return null;
      }
    } catch (e) {
      log.e('Error creating payment Intent: $e');
      return null;
    }
  }

  int _calculateAmountInUSD(int amount) {
    return amount * 100;
  }

  Future<void> processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e, stackTrace) {
      log.e('Error processing payment: $e');
      log.e(stackTrace.toString());
      rethrow;
    }
  }
}
