import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/landlord_provider.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final isEn = provider.language == 'en';
    final notifications = provider.filteredNotifications;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEn ? 'Alerts' : 'تنبيهات', 
                style: Theme.of(context).textTheme.headlineSmall
              ),
              // Filter Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.notificationFilter,
                    dropdownColor: const Color(0xFF1F2937),
                    icon: const Icon(Icons.filter_list, color: Colors.cyan),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.setNotificationFilter(newValue);
                      }
                    },
                    items: [
                      DropdownMenuItem(value: 'all', child: Text(isEn ? 'All' : 'الكل')),
                      DropdownMenuItem(value: 'unread', child: Text(isEn ? 'Unread' : 'غير مقروء')),
                      DropdownMenuItem(value: 'read', child: Text(isEn ? 'Read' : 'مقروء')),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Notifications List
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[600]),
                        const SizedBox(height: 16),
                        Text(
                          isEn ? 'No notifications found' : 'لا توجد إشعارات',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      final bool isRead = notif['read'] ?? false;

                      return Dismissible(
                        key: Key(notif['id'].toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          provider.deleteNotification(notif['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isEn ? 'Notification deleted' : 'تم حذف الإشعار')),
                          );
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isRead 
                                ? const Color(0xFF1F2937) // Dimmed for read
                                : const Color(0xFF111827), // Darker/Prominent for unread
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isRead ? Colors.grey.shade800 : Colors.cyan.withOpacity(0.5)
                            ),
                            boxShadow: isRead ? [] : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: isRead ? Colors.grey[800] : Colors.cyan.withOpacity(0.2),
                                  child: Icon(
                                    Icons.notifications, 
                                    color: isRead ? Colors.grey : Colors.cyan
                                  ),
                                ),
                                if (!isRead)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(
                              notif['title'] ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  notif['message'] ?? '',
                                  style: TextStyle(
                                    color: isRead ? Colors.grey[500] : Colors.grey[300]
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notif['time'] ?? '',
                                  style: TextStyle(
                                    fontSize: 11, 
                                    color: Colors.grey[600]
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Mark Read/Unread Button
                                IconButton(
                                  tooltip: isRead ? (isEn ? 'Mark as Unread' : 'تحديد كغير مقروء') : (isEn ? 'Mark as Read' : 'تحديد كمقروء'),
                                  icon: Icon(
                                    isRead ? Icons.mark_email_unread_outlined : Icons.mark_email_read,
                                    color: isRead ? Colors.grey : Colors.cyan,
                                    size: 20,
                                  ),
                                  onPressed: () => provider.toggleNotificationRead(notif['id']),
                                ),
                                // Delete Button
                                IconButton(
                                  tooltip: isEn ? 'Delete' : 'حذف',
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () => provider.deleteNotification(notif['id']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}