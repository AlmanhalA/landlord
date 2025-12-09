import 'package:flutter/material.dart';
import '../models/app_models.dart';

class LandlordProvider with ChangeNotifier {
  // --- UI State ---
  bool isLoggedIn = true;
  String language = 'en';
  ThemeMode themeMode = ThemeMode.dark;
  String searchQuery = '';
  
  // NEW: Filter State for Notifications
  String notificationFilter = 'all'; // Values: 'all', 'read', 'unread'

  // --- Data ---
  LandlordProfile currentUser = LandlordProfile(
    id: 'L001',
    name: 'Ahmed Landlord',
    email: 'ahmed@example.com',
    cliqAccount: '0791234567',
    verificationStatus: VerificationStatus.unverified,
  );

  List<Listing> listings = [
    Listing(
      id: 1,
      name: 'Shafa Badraan Apt 5',
      address: '123 University St',
      description: 'Cozy student apartment',
      price: 250,
      deposit: 250,
      bedrooms: 2,
      bathrooms: 1,
      location: 'Amman',
      amenities: ['WiFi'],
      houseRules: 'No smoking',
      ownershipDocumentUrl: 'doc.pdf',
    )
  ];

  List<LeaseRequest> requests = [
    LeaseRequest(
      id: 101,
      studentName: 'John Smith',
      studentEmail: 'john.smith@university.edu',
      studentPhone: '+962 79 123 4567',
      studentMajor: 'Computer Science',
      studentYear: '3rd Year',
      propertyName: 'Shafa badraan Apartment 5',
      propertyId: 1,
      rentAmount: 1200,
      duration: 12,
      startDate: DateTime(2025, 1, 1),
      message: 'I am a graduate student looking for a quiet place to study.',
    )
  ];

  List<PaymentReceipt> receipts = [
    PaymentReceipt(
      id: 501,
      studentName: 'Sarah Johnson',
      propertyName: 'Dahyat Al-rasheed Studio',
      amount: 950,
      date: DateTime(2024, 11, 15),
      method: 'Cash',
      receiptImageUrl: 'assets/mock.jpg',
      status: PaymentStatus.pending,
    ),
    PaymentReceipt(
      id: 502,
      studentName: 'Michael Chen',
      propertyName: 'AL-Jamaa Street Apartment 34',
      amount: 1800,
      date: DateTime(2024, 11, 1),
      method: 'CliQ',
      receiptImageUrl: 'assets/mock.jpg',
      status: PaymentStatus.confirmed,
    )
  ];

  List<Agreement> agreements = [
    Agreement(
      id: 1,
      studentName: 'Michael Chen',
      propertyName: 'AL-Jamaa Street Apartment 34',
      rentAmount: 1800,
      duration: 12,
      startDate: DateTime(2024, 9, 1),
      status: 'Active',
      landlordSigned: true,
      studentSigned: true,
      landlordSignDate: DateTime(2024, 8, 15),
      location: 'AL-Jamaa Street, Amman',
    )
  ];

  List<Map<String, dynamic>> notifications = [
    {'id': 1, 'title': 'New Request', 'message': 'Sami requested lease', 'time': '2h ago', 'read': false},
    {'id': 2, 'title': 'Payment Received', 'message': 'Michael paid \$1800', 'time': '1d ago', 'read': true},
    {'id': 3, 'title': 'System Update', 'message': 'Maintenance scheduled', 'time': '3d ago', 'read': true},
  ];

  // --- Getters ---
  
  List<Listing> get filteredListings {
    if (searchQuery.isEmpty) return listings;
    return listings.where((l) =>
        l.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        l.address.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  // NEW: Filtered Notifications Getter
  List<Map<String, dynamic>> get filteredNotifications {
    if (notificationFilter == 'all') return notifications;
    if (notificationFilter == 'read') return notifications.where((n) => n['read'] == true).toList();
    if (notificationFilter == 'unread') return notifications.where((n) => n['read'] == false).toList();
    return notifications;
  }

  // --- Actions ---
  
  // NEW: Notification Actions
  void setNotificationFilter(String filter) {
    notificationFilter = filter;
    notifyListeners();
  }

  void toggleNotificationRead(int id) {
    final index = notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      notifications[index]['read'] = !notifications[index]['read'];
      notifyListeners();
    }
  }

  void deleteNotification(int id) {
    notifications.removeWhere((n) => n['id'] == id);
    notifyListeners();
  }

  void markAllRead() {
    for (var n in notifications) {
      n['read'] = true;
    }
    notifyListeners();
  }

  // ... (Existing actions below: setLanguage, toggleTheme, login, etc.) ...
  void setLanguage(String lang) { language = lang; notifyListeners(); }
  void setSearchQuery(String query) { searchQuery = query; notifyListeners(); }
  void toggleTheme(String val) { themeMode = val == 'dark' ? ThemeMode.dark : ThemeMode.light; notifyListeners(); }
  void login() { isLoggedIn = true; notifyListeners(); }
  void logout() { isLoggedIn = false; notifyListeners(); }
  
  void submitVerification(String idUrl) {
    currentUser = LandlordProfile(
      id: currentUser.id, name: currentUser.name, email: currentUser.email, cliqAccount: currentUser.cliqAccount,
      verificationStatus: VerificationStatus.pending, govCardIdUrl: idUrl,
    );
    notifyListeners();
  }

  void addListing(Listing listing) {
    if (currentUser.verificationStatus != VerificationStatus.verified) { listings.add(listing); } else { listings.add(listing); }
    notifyListeners();
  }
  void updateListing(Listing updatedListing) {
    final index = listings.indexWhere((l) => l.id == updatedListing.id);
    if (index != -1) { listings[index] = updatedListing; notifyListeners(); }
  }
  void removeListing(int id) { listings.removeWhere((l) => l.id == id); notifyListeners(); }
  
  void acceptRequest(int reqId) {
    final index = requests.indexWhere((r) => r.id == reqId);
    if (index != -1) { requests[index].status = RequestStatus.accepted; notifyListeners(); }
  }
  void rejectRequest(int reqId) {
    final index = requests.indexWhere((r) => r.id == reqId);
    if (index != -1) { requests[index].status = RequestStatus.rejected; notifyListeners(); }
  }
  void updateLeaseStatus(int reqId, RequestStatus status) {
    final index = requests.indexWhere((r) => r.id == reqId);
    if (index != -1) { requests[index].status = status; notifyListeners(); }
  }
  void createAgreement(Agreement agreement) { agreements.add(agreement); notifyListeners(); }
  
  void verifyReceipt(int receiptId, bool approved) {
    final index = receipts.indexWhere((r) => r.id == receiptId);
    if (index != -1) { receipts[index].status = approved ? PaymentStatus.confirmed : PaymentStatus.rejected; notifyListeners(); }
  }
  void updateCliq(String newCliq) {
    currentUser = LandlordProfile(
      id: currentUser.id, name: currentUser.name, email: currentUser.email, cliqAccount: newCliq,
      verificationStatus: currentUser.verificationStatus, govCardIdUrl: currentUser.govCardIdUrl,
    );
    notifyListeners();
  }
}