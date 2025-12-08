import 'package:flutter/material.dart';
import '../models/app_models.dart';

class LandlordProvider with ChangeNotifier {
  // Auth
  bool isLoggedIn = false;
  
  // Settings
  String language = 'en';
  ThemeMode themeMode = ThemeMode.dark;
  bool notificationsEnabled = true;

  // App State
  String searchQuery = '';
  String notificationFilter = 'all';
  String cliqAccount = '';

  // Data
  List<Listing> listings = [
    Listing(
      id: 1,
      photo: 'https://images.unsplash.com/photo-1651752523215-9bf678c29355?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080',
      name: 'Shafa badraan Apartment 5',
      address: '123 Shafa Badraan St, Amman',
      description: 'Spacious 2-bedroom apartment with modern amenities',
      status: 'Active',
      payment: 'Paid',
      price: 1200,
      billingPeriod: 'month',
      bedrooms: 2,
      bathrooms: 1,
      location: 'Shafa Badraan, Amman',
      ownershipDocument: 'deed.pdf',
    ),
    // Add more mock data here...
  ];

  List<LeaseRequest> leaseRequests = [
    LeaseRequest(
      id: 1,
      studentName: 'John Smith',
      studentEmail: 'john.smith@university.edu',
      studentPhone: '+962 79 123 4567',
      studentMajor: 'Computer Science',
      studentYear: '3rd Year',
      property: 'Shafa badraan Apartment 5',
      rentAmount: 1200,
      duration: 12,
      startDate: '2025-01-01',
      message: 'I am a graduate student looking for a quiet place.',
    ),
  ];

  List<Agreement> agreements = [];
  List<NotificationItem> notifications = [
    NotificationItem(id: 1, title: 'New lease request', message: 'John Smith requested to rent...', time: '2 hours ago'),
  ];
  List<PaymentItem> paymentHistory = [];

  // --- Actions ---
  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  void toggleTheme(String val) {
    themeMode = val == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setLanguage(String lang) {
    language = lang;
    notifyListeners();
  }

  void removeListing(int id) {
    listings.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  void updateLeaseStatus(int id, String status) {
    final index = leaseRequests.indexWhere((r) => r.id == id);
    if (index != -1) {
      leaseRequests[index].status = status;
      notifyListeners();
    }
  }

  void createAgreement(Agreement agreement) {
    agreements.add(agreement);
    notifyListeners();
  }

  void updatePaymentStatus(int id, String status) {
    final index = paymentHistory.indexWhere((p) => p.id == id);
    if (index != -1) {
      paymentHistory[index].status = status;
      notifyListeners();
    }
  }

  void toggleNotificationRead(int id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].read = !notifications[index].read;
      notifyListeners();
    }
  }

  List<Listing> get filteredListings {
    if (searchQuery.isEmpty) return listings;
    return listings.where((l) => 
      l.name.toLowerCase().contains(searchQuery.toLowerCase()) || 
      l.address.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }
}