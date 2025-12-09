import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/landlord_provider.dart';
import '../../models/app_models.dart';

class AgreementsTab extends StatelessWidget {
  const AgreementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final isEn = provider.language == 'en';
    final dateFormat = DateFormat('d/M/yyyy');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Digital Agreements' : 'العقود الرقمية',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: provider.agreements.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description_outlined, size: 64, color: Colors.grey[600]),
                        const SizedBox(height: 16),
                        Text(
                          isEn ? 'No active contracts' : 'لا توجد عقود نشطة',
                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.agreements.length,
                    itemBuilder: (context, index) {
                      final item = provider.agreements[index];
                      return _buildContractCard(context, item, dateFormat);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractCard(BuildContext context, Agreement item, DateFormat fmt) {
    final isActive = item.status.toLowerCase() == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827), // Dark Background (bg-gray-900)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header: Property Name + Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.propertyName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.location,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? Colors.green : Colors.amber,
                    ),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.amber,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. Details Grid Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937), // Lighter gray (bg-gray-800)
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildDetailItem("Tenant", item.studentName)),
                      Expanded(child: _buildDetailItem("Monthly Rent", "\$${item.rentAmount.toInt()}")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildDetailItem("Duration", "${item.duration} months")),
                      Expanded(child: _buildDetailItem("Start Date", fmt.format(item.startDate))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Signatures Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Signatures:",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSignatureStatus(
                        "Landlord", 
                        item.landlordSigned, 
                        item.landlordSignDate
                      ),
                      const SizedBox(width: 16), // Spacing between signatures
                      _buildSignatureStatus(
                        "Student", 
                        item.studentSigned, 
                        // Assuming you might add studentSignDate later to model, 
                        // for now using current time or logic
                        item.studentSigned ? DateTime.now() : null 
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Download Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  // Download Logic Placeholder
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading Contract PDF...')),
                  );
                },
                icon: const Icon(Icons.download, size: 20),
                label: const Text(
                  "Download PDF",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureStatus(String role, bool isSigned, DateTime? date) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isSigned ? Icons.check_circle_outline : Icons.radio_button_unchecked,
          color: isSigned ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          role,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 13,
          ),
        ),
        if (isSigned && date != null) ...[
          const SizedBox(width: 4),
          Text(
            "(${dateFormat.format(date)})",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ]
      ],
    );
  }
}