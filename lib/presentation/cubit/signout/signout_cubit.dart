import 'package:eleaning/presentation/cubit/signout/signout_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOutCubit extends Cubit<SignoutState> {
  SignOutCubit() : super(SignoutInitial());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      emit(SignoutSuccess());
    } catch (e) {
      emit(SignoutFailure(e.toString()));
    }
  }
}
