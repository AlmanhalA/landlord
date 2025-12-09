// lib/screens/add_listing_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/landlord_provider.dart';
import '../models/app_models.dart';

class AddEditListingScreen extends StatefulWidget {
  final Listing? listing; // If null, we are adding. If provided, we are editing.

  const AddEditListingScreen({super.key, this.listing});

  @override
  State<AddEditListingScreen> createState() => _AddEditListingScreenState();
}

class _AddEditListingScreenState extends State<AddEditListingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form State
  late String _name;
  late String _address;
  late String _location;
  late String _description;
  late double _price;
  late int _bedrooms;
  late int _bathrooms;
  String? _photoUrl;
  bool _ownershipUploaded = false;

  @override
  void initState() {
    super.initState();
    final l = widget.listing;
    _name = l?.name ?? '';
    _address = l?.address ?? '';
    _location = l?.location ?? '';
    _description = l?.description ?? '';
    _price = l?.price ?? 0.0;
    _bedrooms = l?.bedrooms ?? 1;
    _bathrooms = l?.bathrooms ?? 1;
    _photoUrl = l?.photo;
    // If editing, assume ownership was already verified
    _ownershipUploaded = l != null; 
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (!_ownershipUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Proof of ownership is required!")));
      return;
    }

    _formKey.currentState!.save();
    final provider = Provider.of<LandlordProvider>(context, listen: false);

    // Create the listing object
    final newListing = Listing(
      id: widget.listing?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: _name,
      address: _address,
      location: _location,
      description: _description,
      price: _price,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms,
      photo: _photoUrl ?? '',
      ownershipDocumentUrl: 'uploaded_doc.pdf',
      deposit: widget.listing?.deposit ?? 0,
      amenities: widget.listing?.amenities ?? [],
      houseRules: widget.listing?.houseRules ?? '',
    );

    if (widget.listing != null) {
      provider.updateListing(newListing);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Listing Updated!")));
    } else {
      try {
        provider.addListing(newListing);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Listing Added!")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        return;
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.listing != null ? 'Edit Listing' : 'Add New Listing')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Upload
              GestureDetector(
                onTap: () {
                  setState(() => _photoUrl = 'https://via.placeholder.com/400');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Photo selected!")));
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: _photoUrl != null && _photoUrl!.isNotEmpty
                        ? DecorationImage(image: NetworkImage(_photoUrl!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _photoUrl == null || _photoUrl!.isEmpty
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.add_a_photo, size: 40, color: Colors.grey), Text("Tap to add Photo")],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              // Fields
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Property Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => _name = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => _address = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onSaved: (v) => _location = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
                onSaved: (v) => _description = v!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _bedrooms.toString(),
                      decoration: const InputDecoration(labelText: 'Bedrooms', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => _bedrooms = int.parse(v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _bathrooms.toString(),
                      decoration: const InputDecoration(labelText: 'Bathrooms', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => _bathrooms = int.parse(v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Rent (JOD)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onSaved: (v) => _price = double.parse(v!),
              ),
              const SizedBox(height: 24),

              // Ownership
              const Text("Proof of Ownership", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(_ownershipUploaded ? Icons.check_circle : Icons.upload_file, color: _ownershipUploaded ? Colors.green : Colors.grey),
                    const SizedBox(width: 16),
                    Expanded(child: Text(_ownershipUploaded ? "Uploaded" : "Upload Title Deed")),
                    if (!_ownershipUploaded)
                      TextButton(onPressed: () => setState(() => _ownershipUploaded = true), child: const Text("Upload"))
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                  onPressed: _submitForm,
                  child: Text(widget.listing != null ? 'Save Changes' : 'Add Listing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}