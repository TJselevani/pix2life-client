// import 'package:http/http.dart' as http;
// import 'package:pix2life/functions/tokenization.dart';

// class AuthenticatedHttpClient extends http.BaseClient {
//   final http.Client _inner = http.Client();

//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) async {
//     // Add the authorization header
//     final token = await TokenManager.getToken();
//     if (token != null) {
//       request.headers['Authorization'] = 'Bearer $token';
//     }
//     return _inner.send(request);
//   }
// }
