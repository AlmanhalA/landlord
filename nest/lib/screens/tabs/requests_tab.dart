import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/landlord_provider.dart';
import '../../widgets/app_modals.dart';

class LeaseRequestsTab extends StatelessWidget {
  const LeaseRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final requests = provider.leaseRequests.where((r) => r.status == 'pending').toList();
    final isEn = provider.language == 'en';

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (ctx, idx) {
        final req = requests[idx];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(backgroundColor: Colors.cyan, child: Icon(Icons.person, color: Colors.white)),
                  title: Text(req.studentName),
                  subtitle: Text(req.property),
                ),
                Text('Message: "${req.message}"', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                        onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => LeaseAgreementModal(request: req)),
                        icon: const Icon(Icons.check, size: 16),
                        label: Text(isEn ? 'Accept' : 'قبول'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => provider.updateLeaseStatus(req.id, 'rejected'),
                        icon: const Icon(Icons.close, size: 16),
                        label: Text(isEn ? 'Reject' : 'رفض'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}