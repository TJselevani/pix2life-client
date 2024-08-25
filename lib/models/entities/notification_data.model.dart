import 'package:pix2life/models/entities/transaction.model.dart';

class NotificationData {
  final String lastLogin;
  final String subscriptionPlan;
  final List<Transaction> transactions;

  NotificationData({
    required this.lastLogin,
    required this.subscriptionPlan,
    required this.transactions,
  });
}