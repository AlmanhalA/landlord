// lib/screens/create_agreement_screen.dart

import 'package:flutter/material.dart';
import '../models/app_models.dart';

class CreateAgreementScreen extends StatelessWidget {
  final LeaseRequest request;
  const CreateAgreementScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    // This implements FR44: Create Lease Agreement [cite: 518]
    // Pre-filled with data from the accepted request
    return Scaffold(
      appBar: AppBar(title: const Text('Draft Lease Agreement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Agreement Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildReadOnlyField("Tenant", request.studentName),
            _buildReadOnlyField("Property", request.propertyName),
            _buildReadOnlyField("Start Date", request.startDate.toString().split(' ')[0]),
            _buildReadOnlyField("Duration", "${request.duration} Months"),
            const Divider(height: 32),
            TextFormField(
              initialValue: request.rentAmount.toString(),
              decoration: const InputDecoration(labelText: 'Confirmed Monthly Rent', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Security Deposit Amount', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Terms & Conditions', border: OutlineInputBorder()),
              maxLines: 5,
              initialValue: "Standard housing rules apply...",
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                onPressed: () {
                  // Logic to save as "PendingSignature" (UC-STD-07)
                  Navigator.pop(context); 
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Agreement sent to student for signature")));
                },
                child: const Text('Send Agreement'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}