// lib/screens/verification_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/landlord_provider.dart';
import '../models/app_models.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _idUploaded = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final status = provider.currentUser.verificationStatus;

    return Scaffold(
      appBar: AppBar(title: const Text('Identity Verification')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.verified_user_outlined, size: 80, color: Colors.cyan),
            const SizedBox(height: 16),
            Text(
              status == VerificationStatus.verified 
                  ? "You are verified!" 
                  : status == VerificationStatus.pending 
                      ? "Verification Pending" 
                      : "Verify your account",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "To publish listings, you must upload a government-issued ID (National ID) to prevent fraud.", // Business Rationale FR35 [cite: 491]
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            if (status == VerificationStatus.unverified || status == VerificationStatus.rejected) ...[
              GestureDetector(
                onTap: () {
                  setState(() => _idUploaded = true); // Simulate upload
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ID Document Uploaded")));
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, size: 40, color: _idUploaded ? Colors.green : Colors.grey),
                      const SizedBox(height: 8),
                      Text(_idUploaded ? "ID Uploaded" : "Tap to Upload National ID"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _idUploaded 
                  ? () => provider.submitVerification("mock_url") 
                  : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                child: const Text("Submit for Review"),
              ),
            ],
            
            if (status == VerificationStatus.pending)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.amber[100],
                child: const Text("Your documents are under review by the Admin. You will be notified once approved."),
              )
          ],
        ),
      ),
    );
  }
}