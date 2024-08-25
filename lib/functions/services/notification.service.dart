import 'package:pix2life/models/entities/notification_data.model.dart';
import 'package:pix2life/models/entities/transaction.model.dart';

class NotificationService {
  static Future<NotificationData> fetchNotificationData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return NotificationData(
      lastLogin: '2024-07-20 14:30',
      subscriptionPlan: 'Premium',
      transactions: [
        Transaction(
            date: '2024-07-18',
            description: 'Monthly Subscription',
            amount: 9.99),
        Transaction(
            date: '2024-06-18',
            description: 'Monthly Subscription',
            amount: 9.99),
        Transaction(
            date: '2024-05-18',
            description: 'Monthly Subscription',
            amount: 9.99),
      ],
    );
  }
}
