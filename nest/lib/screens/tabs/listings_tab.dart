import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/landlord_provider.dart';
import '../../widgets/common_widgets.dart';
import '../add_listing_screen.dart'; 

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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditListingScreen()));
                }, 
                icon: const Icon(Icons.add, size: 18),
                label: Text(isEn ? 'Add' : 'إضافة'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => provider.setSearchQuery(val),
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
                      // Determine payment status color
                      final isPaid = item.paymentStatus == 'Paid';
                      
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Photo Area
                            Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: item.photo.isNotEmpty
                                ? Image.network(
                                    item.photo, 
                                    fit: BoxFit.cover,
                                    errorBuilder: (c,e,s) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                  )
                                : const Icon(Icons.home, size: 50, color: Colors.grey),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title & Status Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                      Row(
                                        children: [
                                          // Active Status
                                          StatusChip(label: item.status, color: Colors.green),
                                          const SizedBox(width: 8),
                                          // Payment Status (New Requirement)
                                          StatusChip(
                                            label: item.paymentStatus, 
                                            color: isPaid ? Colors.cyan : Colors.orange
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(item.address, style: TextStyle(color: Colors.grey[600])),
                                  const SizedBox(height: 8),
                                  
                                  Row(
                                    children: [
                                      const Icon(Icons.bed, size: 16, color: Colors.cyan),
                                      Text(' ${item.bedrooms} '),
                                      const Icon(Icons.bathtub, size: 16, color: Colors.cyan),
                                      Text(' ${item.bathrooms} '),
                                      const Spacer(),
                                      Text('\$${item.price}', style: const TextStyle(fontSize: 18, color: Colors.cyan, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                                          onPressed: () {
                                            Navigator.push(
                                              context, 
                                              MaterialPageRoute(builder: (_) => AddEditListingScreen(listing: item))
                                            );
                                          },
                                          icon: const Icon(Icons.edit, size: 16),
                                          label: Text(isEn ? 'Edit' : 'تعديل'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => provider.removeListing(item.id),
                                          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                                          label: Text(isEn ? 'Delete' : 'حذف', style: const TextStyle(color: Colors.red)),
                                        ),
                                      ),
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