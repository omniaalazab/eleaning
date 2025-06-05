import 'package:eleaning/data/repository/payment_repository.dart';

import 'package:eleaning/presentation/cubit/payment/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository paymentRepository;
  PaymentCubit(this.paymentRepository) : super(PaymentInitial());

  Future<void> makePayment({
    required String courseId,
    required int amount,
    required String currency,
  }) async {
    emit(PaymentLoading());
    try {
      final paymentSuccess = await paymentRepository.processPayment(
        amount: amount,
        currency: currency,
      );

      if (paymentSuccess) {
        await paymentRepository.markCourseAsPaid(courseId);

        emit(PaymentSucess());
      } else {
        emit(PaymentFailure("Payment failed or was cancelled."));
      }
    } catch (e) {
      emit(PaymentFailure("An error occurred: $e"));
    }
  }
}
