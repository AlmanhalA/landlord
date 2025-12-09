import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/landlord_provider.dart';
import '../models/app_models.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // ... (Your settings code is fine, omitted for brevity but include it)
    return const AlertDialog(title: Text("Settings")); // Placeholder for now
  }
}

class LeaseAgreementModal extends StatelessWidget {
  final LeaseRequest request;
  const LeaseAgreementModal({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context, listen: false);
    
    // Fixed: logic to calculate end date
    final endDate = request.startDate.add(Duration(days: 30 * request.duration));
    final fmt = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: const Text('Create Agreement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed: propertyName
            Text('Property: ${request.propertyName}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Tenant: ${request.studentName}'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                onPressed: () {
                  // Fixed: correct method call
                  provider.updateLeaseStatus(request.id, RequestStatus.accepted);
                  
                  // Fixed: Creating Agreement object correctly
                  provider.createAgreement(Agreement(
                    id: DateTime.now().millisecondsSinceEpoch,
                    studentName: request.studentName,
                    propertyName: request.propertyName,
                    rentAmount: request.rentAmount,
                    duration: request.duration,
                    startDate: request.startDate,
                    endDate: endDate,
                    status: 'Pending Signature',
                    landlordSigned: true,
                    studentSigned: false,
                    landlordSignDate: DateTime.now(),
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