import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/landlord_provider.dart';
import '../../models/app_models.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final isEn = provider.language == 'en';
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header: Title + Add CliQ Button
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () => _showAddCliqDialog(context),
                child: Text(
                  isEn ? 'Add CliQ' : 'إضافة CliQ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),

          // Content List
          Expanded(
            child: provider.receipts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey[600]),
                        const SizedBox(height: 16),
                        Text(
                          isEn ? 'No payment history' : 'لا يوجد سجل دفع',
                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.receipts.length,
                    itemBuilder: (context, index) {
                      final item = provider.receipts[index];
                      return _buildPaymentCard(context, item, provider, dateFormat);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, PaymentReceipt item, LandlordProvider provider, DateFormat fmt) {
    final isPending = item.status == PaymentStatus.pending;
    final isConfirmed = item.status == PaymentStatus.confirmed;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937), // Card Background (Lighter Dark)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
            // 1. Header: Property + Status
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.studentName,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isConfirmed ? Colors.green : (isPending ? Colors.orange : Colors.red),
                    ),
                  ),
                  child: Text(
                    item.status.toString().split('.').last,
                    style: TextStyle(
                      color: isConfirmed ? Colors.green : (isPending ? Colors.orange : Colors.red),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 2. Stats Grid (Inner Dark Box)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111827), // Darker Inner Background
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem("Amount", "\$${item.amount.toInt()}"),
                  _buildStatItem("Date", fmt.format(item.date)),
                  _buildStatItem("Method", item.method),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Action Buttons
            if (isConfirmed || item.status == PaymentStatus.rejected)
              // Single "View Receipt" button for processed items
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () { /* View Receipt Logic */ },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text("View Receipt", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            else
              // Action Row for Pending Items
              Row(
                children: [
                  // View Receipt
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () { /* View Receipt Logic */ },
                      child: const Column(
                        children: [
                          Icon(Icons.visibility_outlined, size: 20),
                          Text("View\nReceipt", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, height: 1.2)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Confirm
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20), // Taller to match layout
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => provider.verifyReceipt(item.id, true),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text("Confirm", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Reject
                  Expanded(
                    flex: 3,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade700),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () => provider.verifyReceipt(item.id, false),
                      icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                      label: const Text("Reject", style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showAddCliqDialog(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context, listen: false);
    String inputVal = '';
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: const Text('Add CliQ Account', style: TextStyle(color: Colors.white)),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'CliQ ID / Phone',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
          ),
          onChanged: (v) => inputVal = v,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text('Cancel', style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
            onPressed: () {
              provider.updateCliq(inputVal);
              Navigator.pop(ctx);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}