import 'package:flutter/material.dart';

class TurfDetails {
  final String name;
  final String location;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String openingHours;
  final String pricePerHour;

  TurfDetails({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.openingHours,
    required this.pricePerHour,
  });
}

class BookingData {
  final TurfDetails turfDetails;
  final String date;
  final String startTime;
  final String endTime;
  final int duration;
  final double totalAmount;
  final String sportType;
  final String bookingId;

  BookingData({
    required this.turfDetails,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalAmount,
    required this.sportType,
    required this.bookingId,
  });
}

// Singleton to hold booking data across screens
class BookingDataProvider {
  static final BookingDataProvider _instance = BookingDataProvider._internal();
  
  factory BookingDataProvider() {
    return _instance;
  }
  
  BookingDataProvider._internal();
  
  BookingData? bookingData;
  
  void setBookingData(BookingData data) {
    bookingData = data;
  }
  
  BookingData? getBookingData() {
    return bookingData;
  }
}
