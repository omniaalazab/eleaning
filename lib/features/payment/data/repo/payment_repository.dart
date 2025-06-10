import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleaning/features/payment/data/data_source/payment_manager.dart';

class PaymentRepository {
  Future<bool> processPayment({
    required int amount,
    required String currency,
  }) async {
    try {
      return await PaymentManager.makePayment(amount, currency);
    } catch (e) {
      log("Stripe Payment processing failed: $e");
      return false;
    }
  }

  Future<void> markCourseAsPaid(String courseId) async {
    await FirebaseFirestore.instance.collection('courses').doc(courseId).update(
      {'isPaid': true},
    );
  }
}
