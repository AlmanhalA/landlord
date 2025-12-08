import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/landlord_provider.dart';
import '../models/app_models.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    return AlertDialog(
      title: const Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: provider.language,
            decoration: const InputDecoration(labelText: 'Language'),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ar', child: Text('العربية')),
            ],
            onChanged: (v) => provider.setLanguage(v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: provider.themeMode == ThemeMode.dark ? 'dark' : 'light',
            decoration: const InputDecoration(labelText: 'Theme'),
            items: const [
              DropdownMenuItem(value: 'dark', child: Text('Dark Mode')),
              DropdownMenuItem(value: 'light', child: Text('Light Mode')),
            ],
            onChanged: (v) => provider.toggleTheme(v!),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
      ],
    );
  }
}

class LeaseAgreementModal extends StatelessWidget {
  final LeaseRequest request;
  const LeaseAgreementModal({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context, listen: false);
    final endDate = DateTime.parse(request.startDate).add(Duration(days: 30 * request.duration));
    final fmt = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Agreement'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Property Info', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
            Card(child: ListTile(title: Text(request.property), subtitle: Text('\$${request.rentAmount} / month'))),
            const SizedBox(height: 16),
            const Text('Tenant Info', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
            Card(child: ListTile(title: Text(request.studentName), subtitle: Text(request.studentMajor))),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                onPressed: () {
                  provider.updateLeaseStatus(request.id, 'accepted');
                  provider.createAgreement(Agreement(
                    id: DateTime.now().millisecondsSinceEpoch,
                    studentName: request.studentName,
                    property: request.property,
                    rentAmount: request.rentAmount,
                    duration: request.duration,
                    startDate: request.startDate,
                    status: 'Pending Student Signature',
                    landlordSigned: true,
                    studentSigned: false,
                    landlordSignDate: fmt.format(DateTime.now()),
                    studentSignDate: '',
                    location: 'Amman',
                  ));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agreement Sent!')));
                },
                child: const Text('Sign & Create'),
              ),
            )
          ],
        ),
      ),
    );
  }
}