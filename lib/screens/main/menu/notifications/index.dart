import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/functions/services/notification.service.dart';
import 'package:pix2life/models/entities/notification_data.model.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<NotificationData> _notificationData;

  @override
  void initState() {
    super.initState();
    _notificationData = NotificationService.fetchNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: AppPalette.whiteColor,
      ),
      body: FutureBuilder<NotificationData>(
        future: _notificationData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Card(
                  child: ListTile(
                    title: Text('Last Login'),
                    subtitle: Text(data.lastLogin),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  child: ListTile(
                    title: Text('Subscription Plan'),
                    subtitle: Text(data.subscriptionPlan),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Transaction History'),
                      ),
                      ...data.transactions.map((transaction) {
                        return ListTile(
                          title: Text(transaction.description),
                          subtitle: Text(transaction.date),
                          trailing: Text(
                              '\$${transaction.amount.toStringAsFixed(2)}'),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
