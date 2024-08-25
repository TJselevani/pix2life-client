// import 'package:flutter/material.dart';
// import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
// import 'package:pix2life/config/app/app.config.dart';

// class PayPalService {
//   PayPalService._();

//   static final PayPalService instance = PayPalService._();

//   createPayment(BuildContext context) {
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (BuildContext context) => PaypalCheckout(
//         sandboxMode: true,
//         clientId: "${AppConfig.paypalClientID}",
//         secretKey: "${AppConfig.paypalSecretKey}",
//         returnURL: "${AppConfig.baseUrl}/payment/paypal/success",
//         cancelURL: "${AppConfig.baseUrl}/payment/paypal/cancel",
//         transactions: const [
//           {
//             "amount": {
//               "total": '70',
//               "currency": "USD",
//               "details": {
//                 "subtotal": '70',
//                 "shipping": '0',
//                 "shipping_discount": 0
//               }
//             },
//             "description": "The payment transaction description.",
//             "item_list": {
//               "items": [
//                 {
//                   "name": "Pix2Life Monthly Package",
//                   "quantity": 4,
//                   "price": '5',
//                   "currency": "USD"
//                 },
//                 {
//                   "name": "Premium Membership",
//                   "quantity": 5,
//                   "price": '10',
//                   "currency": "USD"
//                 }
//               ],
//             }
//           }
//         ],
//         note: "Please contact us for any inquiries",
//         onSuccess: (Map params) async {
//           print("onSuccess: $params");
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Payment Successful')),
//           );
//         },
//         onError: (error) {
//           print("onError: $error");
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Error creating payment')),
//           );
//           Navigator.pop(context);
//         },
//         onCancel: () {
//           print('cancelled:');
//         },
//       ),
//     ));
//   }
// }
