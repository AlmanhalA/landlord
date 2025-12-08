import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/landlord_provider.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.notifications.length,
      itemBuilder: (ctx, idx) {
        final notif = provider.notifications[idx];
        return Card(
          color: notif.read ? null : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF374151) : Colors.white),
          child: ListTile(
            leading: const Icon(Icons.notifications, color: Colors.cyan),
            title: Text(notif.title, style: TextStyle(fontWeight: notif.read ? FontWeight.normal : FontWeight.bold)),
            subtitle: Text(notif.message),
            trailing: IconButton(
              icon: Icon(notif.read ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: () => provider.toggleNotificationRead(notif.id),
            ),
          ),
        );
      },
    );
  }
}