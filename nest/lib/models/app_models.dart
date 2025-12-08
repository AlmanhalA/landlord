class Listing {
  final int id;
  final String photo;
  final String name;
  final String address;
  final String description;
  final String status;
  final String payment;
  final double price;
  final String billingPeriod;
  final int bedrooms;
  final int bathrooms;
  final String location;
  final String ownershipDocument;

  Listing({
    required this.id, required this.photo, required this.name, required this.address,
    required this.description, required this.status, required this.payment,
    required this.price, required this.billingPeriod, required this.bedrooms,
    required this.bathrooms, required this.location, required this.ownershipDocument,
  });
}

class LeaseRequest {
  final int id;
  final String studentName;
  final String studentEmail;
  final String studentPhone;
  final String studentMajor;
  final String studentYear;
  final String property;
  final double rentAmount;
  final int duration;
  final String startDate;
  String status;
  final String message;

  LeaseRequest({
    required this.id, required this.studentName, required this.studentEmail,
    required this.studentPhone, required this.studentMajor, required this.studentYear,
    required this.property, required this.rentAmount, required this.duration,
    required this.startDate, this.status = 'pending', required this.message,
  });
}

class Agreement {
  final int id;
  final String studentName;
  final String property;
  final double rentAmount;
  final int duration;
  final String startDate;
  final String status;
  final bool landlordSigned;
  final bool studentSigned;
  final String landlordSignDate;
  final String studentSignDate;
  final String location;

  Agreement({
    required this.id, required this.studentName, required this.property,
    required this.rentAmount, required this.duration, required this.startDate,
    required this.status, required this.landlordSigned, required this.studentSigned,
    required this.landlordSignDate, required this.studentSignDate, required this.location,
  });
}

class PaymentItem {
  final int id;
  final String studentName;
  final String property;
  final double amount;
  final String date;
  final String method;
  String status;
  final String? confirmedBy;

  PaymentItem({
    required this.id, required this.studentName, required this.property,
    required this.amount, required this.date, required this.method,
    required this.status, this.confirmedBy,
  });
}

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String time;
  bool read;

  NotificationItem({
    required this.id, required this.title, required this.message,
    required this.time, this.read = false,
  });
}

class MessageItem {
  final int id;
  final String from;
  final String subject;
  final String body;
  final String time;
  bool read;

  MessageItem({
    required this.id, required this.from, required this.subject,
    required this.body, required this.time, this.read = false,
  });
}