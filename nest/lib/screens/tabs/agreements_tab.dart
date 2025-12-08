import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/landlord_provider.dart';
import '../../widgets/common_widgets.dart';

class AgreementsTab extends StatelessWidget {
  const AgreementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final isEn = provider.language == 'en';
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        Icon(Icons.fact_check_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          isEn ? 'No agreements yet' : 'لا توجد عقود بعد',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.agreements.length,
                    itemBuilder: (context, index) {
                      final item = provider.agreements[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.property, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        Text(item.location, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  StatusChip(
                                    label: item.status,
                                    color: item.status == 'Active' ? Colors.green : Colors.orange,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Details Grid
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _DetailItem(label: isEn ? 'Tenant' : 'مستأجر', value: item.studentName),
                                    _DetailItem(label: isEn ? 'Rent' : 'إيجار', value: '\$${item.rentAmount}'),
                                    _DetailItem(label: isEn ? 'Duration' : 'المدة', value: '${item.duration} m'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Signatures
                              const Text('Signatures:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _SignatureStatus(
                                    signed: item.landlordSigned,
                                    label: 'Landlord (${item.landlordSignDate})',
                                  ),
                                  const SizedBox(width: 16),
                                  _SignatureStatus(
                                    signed: item.studentSigned,
                                    label: 'Student ${item.studentSigned ? "(${item.studentSignDate})" : ""}',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Download Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyan,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Downloading PDF...')),
                                    );
                                  },
                                  icon: const Icon(Icons.download, size: 18),
                                  label: Text(isEn ? 'Download PDF' : 'تحميل PDF'),
                                ),
                              ),
                            ],
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

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _SignatureStatus extends StatelessWidget {
  final bool signed;
  final String label;
  const _SignatureStatus({required this.signed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          signed ? Icons.check_circle : Icons.access_time_filled,
          size: 16,
          color: signed ? Colors.green : Colors.amber,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}