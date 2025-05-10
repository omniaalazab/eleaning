import 'package:eleaning/presentation/cubit/reset/reset_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetCubit extends Cubit<ResetStatus> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ResetCubit() : super(ResetInitial());
  Future<void> resetPassword(String mail) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: mail);
      emit(ResetSuccess());
    } catch (e) {
      emit(ResetFailure(e.toString()));
    }
  }
}
