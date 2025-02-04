import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/logger/logger.dart';

class PayPalService {
  final logger = createLogger(PayPalService);
  PayPalService._();

  static final PayPalService instance = PayPalService._();

  void createPayment(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => UsePaypal(
        sandboxMode: true,
        clientId: AppSecrets.paypalClientID,
        secretKey: AppSecrets.paypalSecretKey,
        returnURL: "${AppSecrets.baseUrl}/payment/paypal/success",
        cancelURL: "${AppSecrets.baseUrl}/payment/paypal/cancel",
        transactions: const [
          {
            "amount": {
              "total": '70.00',
              "currency": "USD",
              "details": {
                "subtotal": '70.00',
                "shipping": '0',
                "shipping_discount": 0,
              }
            },
            "description": "The payment transaction description.",
            "item_list": {
              "items": [
                {
                  "name": "Pix2Life Monthly Package",
                  "quantity": 4,
                  "price": '5.00',
                  "currency": "USD",
                },
                {
                  "name": "Premium Membership",
                  "quantity": 5,
                  "price": '10.00',
                  "currency": "USD",
                }
              ],
            }
          }
        ],
        note: "Please contact us for any inquiries.",
        onSuccess: (Map<String, dynamic> params) async {
          logger.i("onSuccess: $params");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment Successful')),
          );
        },
        onError: (error) {
          logger.e("onError: $error");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error creating payment')),
          );
          Navigator.pop(context);
        },
        onCancel: () {
          logger.i('Payment cancelled');
          Navigator.pop(context);
        },
      ),
    ));
  }
}
