import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class AudioPlayerPage extends StatelessWidget {
  const AudioPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 20),
          _buildAgendaSection(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomDialog(context),
        backgroundColor: const Color(0xFF5965F2),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Header section with user greeting and task progress
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      decoration: const BoxDecoration(
        color: Color(0xFF5965F2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello tjselevani!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '27/45hrs This week',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Tasks progress',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.white30,
            valueColor:
                AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 170, 24, 14)),
          ),
        ],
      ),
    );
  }

  // Agenda section that displays cards for meetings and leave request
  Widget _buildAgendaSection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Agenda",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                ZoomDrawer.of(context)!.toggle();
              },
              child: _buildAgendaCard(
                title: 'Daily Standup @ 10:00 AM',
                subtitle: '3 participants',
                color: Colors.blue.shade50,
                participantsCount: 3,
              ),
            ),
            _buildAgendaCard(
              title: 'Design Review meeting',
              subtitle: '3 participants',
              color: Colors.purple.shade50,
              participantsCount: 3,
            ),
            _buildLeaveRequestCard(),
          ],
        ),
      ),
    );
  }

  // A card widget for each meeting in the agenda
  Widget _buildAgendaCard({
    required String title,
    required String subtitle,
    required Color color,
    required int participantsCount,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        tileColor: color,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: CircleAvatar(
          child: Text('+$participantsCount'),
        ),
      ),
    );
  }

  // Leave request card in the agenda
  Widget _buildLeaveRequestCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        tileColor: Colors.green.shade50,
        title: const Text(
          'Leave Request',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text('1 Oct - 10 Oct Approved'),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }

  // Bottom sheet modal dialog
  void _showBottomDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Create New',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDialogRow(),
            ],
          ),
        );
      },
    );
  }

  // Row for displaying icons and actions in the modal dialog
  Widget _buildDialogRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDialogItem(Icons.time_to_leave, 'Leave', Colors.orange.shade100),
        _buildDialogItem(
            Icons.airplanemode_active, 'Travel', Colors.blue.shade100),
        _buildDialogItem(Icons.folder, 'Documents', Colors.purple.shade100),
        _buildDialogItem(Icons.event, 'Meeting', Colors.green.shade100),
      ],
    );
  }

  // Dialog item widget
  Widget _buildDialogItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(icon, size: 30, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
