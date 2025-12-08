import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/landlord_provider.dart';
import '../../widgets/common_widgets.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final isEn = provider.language == 'en';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEn ? 'Payment History' : 'سجل الدفع',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () => _showAddCliqDialog(context),
                child: Text(isEn ? 'Add CliQ' : 'إضافة CliQ'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // CliQ Info Box (if exists)
          if (provider.cliqAccount.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              // --- FIX IS HERE: Changed from .bottom(16) to .only(bottom: 16) ---
              margin: const EdgeInsets.only(bottom: 16), 
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.blue[50],
                border: Border.all(color: isDark ? Colors.grey[700]! : Colors.blue[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CliQ Account:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text(provider.cliqAccount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),

          // List
          Expanded(
            child: provider.paymentHistory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          isEn ? 'No payment history' : 'لا يوجد سجل دفع',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.paymentHistory.length,
                    itemBuilder: (context, index) {
                      final item = provider.paymentHistory[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Card Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.property, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text(item.studentName, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  StatusChip(
                                    label: item.status,
                                    color: item.status == 'confirmed' ? Colors.green 
                                        : item.status == 'rejected' ? Colors.red 
                                        : Colors.amber,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Stats Grid
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _StatItem(label: isEn ? 'Amount' : 'المبلغ', value: '\$${item.amount}'),
                                    _StatItem(label: isEn ? 'Date' : 'التاريخ', value: item.date),
                                    _StatItem(label: isEn ? 'Method' : 'الطريقة', value: item.method),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Actions
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                                      onPressed: () {},
                                      icon: const Icon(Icons.visibility, size: 16),
                                      label: Text(isEn ? 'Receipt' : 'الإيصال'),
                                    ),
                                  ),
                                  if (item.status == 'pending') ...[
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                        onPressed: () => provider.updatePaymentStatus(item.id, 'confirmed'),
                                        icon: const Icon(Icons.check, size: 16),
                                        label: Text(isEn ? 'Confirm' : 'تأكيد'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                        onPressed: () => provider.updatePaymentStatus(item.id, 'rejected'),
                                        child: const Icon(Icons.close, size: 20),
                                      ),
                                    ),
                                  ],
                                ],
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

  void _showAddCliqDialog(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context, listen: false);
    String inputVal = '';
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add CliQ Account'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'CliQ ID / Phone',
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => inputVal = v,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.cliqAccount = inputVal;
              provider.notifyListeners(); 
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}