import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleaning/data/services/stripe_payment/payment_manager.dart';
import 'package:eleaning/presentation/cubit/payment/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  Future<void> makePayment({
    required String courseId,
    required int amount,
    required String currency,
  }) async {
    emit(PaymentLoading());
    try {
      final paymentSuccess = await PaymentManager.makePayment(amount, currency);

      if (paymentSuccess) {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .update({'isPaid': true});

        emit(PaymentSucess());
      } else {
        emit(PaymentFailure("Payment failed or was cancelled."));
      }
    } catch (e) {
      emit(PaymentFailure("An error occurred: $e"));
    }
  }
}
