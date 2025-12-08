import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/landlord_provider.dart';
import '../../widgets/common_widgets.dart';

class ListingsTab extends StatelessWidget {
  const ListingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);
    final isEn = provider.language == 'en';
    final listings = provider.filteredListings;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isEn ? 'My Listings' : 'قوائمي', style: Theme.of(context).textTheme.headlineSmall),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                onPressed: () {}, // Add listing logic
                icon: const Icon(Icons.add, size: 18),
                label: Text(isEn ? 'Add' : 'إضافة'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) {
               provider.searchQuery = val;
               provider.notifyListeners(); 
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: isEn ? 'Search...' : 'بحث...',
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: listings.isEmpty
                ? Center(child: Text(isEn ? 'No listings found' : 'لا توجد نتائج'))
                : ListView.builder(
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final item = listings[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[700],
                              child: item.photo.isNotEmpty 
                                ? Image.network(item.photo, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.home, size: 50)) 
                                : const Icon(Icons.home, size: 50),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      StatusChip(label: item.status, color: Colors.green),
                                      const SizedBox(width: 8),
                                      StatusChip(label: item.payment, color: item.payment == 'Paid' ? Colors.cyan : Colors.amber),
                                      const Spacer(),
                                      Text('\$${item.price}', style: const TextStyle(fontSize: 18, color: Colors.cyan, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(child: OutlinedButton.icon(onPressed: () => provider.removeListing(item.id), icon: const Icon(Icons.delete, color: Colors.red), label: const Text('Delete', style: TextStyle(color: Colors.red)))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
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