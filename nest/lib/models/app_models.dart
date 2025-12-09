// lib/models/app_models.dart

enum VerificationStatus { pending, verified, rejected, unverified }
enum RequestStatus { pending, accepted, rejected }
enum PaymentStatus { pending, confirmed, rejected }

class LandlordProfile {
  final String id;
  final String name;
  final String email;
  final String cliqAccount;
  final VerificationStatus verificationStatus;
  final String? govCardIdUrl;

  LandlordProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.cliqAccount,
    required this.verificationStatus,
    this.govCardIdUrl,
  });
}

class Listing {
  final int id;
  final String name;
  final String address;
  final String description;
  final double price;
  final double deposit;
  final int bedrooms;
  final int bathrooms;
  final String location;
  final List<String> amenities;
  final String houseRules;
  final String ownershipDocumentUrl;
  final String photo;
  final String status;
  final String paymentStatus;
  final String billingPeriod;

  Listing({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.price,
    required this.deposit,
    required this.bedrooms,
    required this.bathrooms,
    required this.location,
    required this.amenities,
    required this.houseRules,
    required this.ownershipDocumentUrl,
    this.photo = '',
    this.status = 'Active',
    this.paymentStatus = 'Pending',
    this.billingPeriod = 'month',
  });
}

class LeaseRequest {
  final int id;
  final String studentName;
  final String studentMajor;
  final String studentYear; // <--- This was missing
  final String propertyName;
  final int propertyId;
  final double rentAmount;
  final int duration;
  final DateTime startDate;
  RequestStatus status;
  final String message;
  final String studentEmail;
  final String studentPhone;

  LeaseRequest({
    required this.id,
    required this.studentName,
    required this.studentMajor,
    this.studentYear = '1st Year', // <--- Added with default
    required this.propertyName,
    required this.propertyId,
    required this.rentAmount,
    required this.duration,
    required this.startDate,
    required this.message,
    this.status = RequestStatus.pending,
    this.studentEmail = '',
    this.studentPhone = '',
  });
}

class PaymentReceipt {
  final int id;
  final String studentName;
  final String propertyName;
  final double amount;
  final DateTime date;
  final String method;
  final String receiptImageUrl;
  PaymentStatus status;

  PaymentReceipt({
    required this.id,
    required this.studentName,
    required this.propertyName,
    required this.amount,
    required this.date,
    required this.method,
    required this.receiptImageUrl,
    required this.status,
  });
}

class Agreement {
  final int id;
  final String studentName;
  final String propertyName;
  final double rentAmount;
  final int duration;
  final DateTime startDate;
  final DateTime? endDate;
  final String status;
  final bool landlordSigned;
  final bool studentSigned;
  final DateTime landlordSignDate;
  final String location;

  Agreement({
    required this.id,
    required this.studentName,
    required this.propertyName,
    required this.rentAmount,
    required this.duration,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.landlordSigned,
    required this.studentSigned,
    required this.landlordSignDate,
    required this.location,
  });
}