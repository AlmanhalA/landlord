import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/landlord_provider.dart';
import '../../models/app_models.dart';
import '../../widgets/app_modals.dart';

class LeaseRequestsTab extends StatelessWidget {
  const LeaseRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final reqs = provider.requests.where((r) => r.status == RequestStatus.pending).toList();
    final isEn = provider.language == 'en';

    final dateFormat = DateFormat('d/M/yyyy');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Lease Requests' : 'طلبات الإيجار', 
            style: Theme.of(context).textTheme.headlineSmall
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: reqs.isEmpty
                ? Center(child: Text(isEn ? 'No pending requests' : 'لا توجد طلبات'))
                : ListView.builder(
                    itemCount: reqs.length,
                    itemBuilder: (context, index) {
                      final req = reqs[index];
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827), 
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade800),
                          boxShadow: [
                            BoxShadow(
                              // FIX: .withValues(alpha: 0.2) replaces .withOpacity(0.2)
                              color: Colors.black.withValues(alpha: 0.2), 
                              blurRadius: 8, 
                              offset: const Offset(0, 4)
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Header: Student Info
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.cyan,
                                    child: Icon(Icons.person, color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          req.studentName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(req.studentEmail, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                        Text(req.studentPhone, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                        const SizedBox(height: 10),
                                        // Tags (Major & Year)
                                        Row(
                                          children: [
                                            _buildChip(req.studentMajor, const Color(0xFF0E4F5D), Colors.cyan),
                                            const SizedBox(width: 8),
                                            // 'studentYear' is now defined in the model
                                            _buildChip(req.studentYear, const Color(0xFF374151), Colors.grey[300]!), 
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // 2. Property Name
                              Row(
                                children: [
                                  const Icon(Icons.description_outlined, color: Colors.cyan, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      req.propertyName,
                                      style: const TextStyle(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // 3. Stats Row
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F2937),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildStatItem("Rent Amount", "\$${req.rentAmount.toInt()}/mo"),
                                    _buildStatItem("Duration", "${req.duration} months"),
                                    _buildStatItem("Start Date", dateFormat.format(req.startDate)),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // 4. Message Box
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F2937),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Message from student:",
                                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      req.message,
                                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // 5. Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.cyan,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 0,
                                      ),
                                      onPressed: () => showModalBottomSheet(
                                        context: context, 
                                        isScrollControlled: true, 
                                        builder: (_) => LeaseAgreementModal(request: req)
                                      ),
                                      icon: const Icon(Icons.check, size: 20),
                                      label: const Text("Accept", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.grey[300],
                                        side: BorderSide(color: Colors.grey.shade700),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => provider.rejectRequest(req.id),
                                      icon: const Icon(Icons.close, size: 20),
                                      label: const Text("Reject", style: TextStyle(fontSize: 16)),
                                    ),
                                  ),
                                ],
                              )
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

  Widget _buildChip(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}