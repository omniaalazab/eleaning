import 'package:eleaning/features/authentication/presentation/cubit/register/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationCubit extends Cubit<RegistrationStatus> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  RegistrationCubit() : super(RegistrationInitial());

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      emit(RegistrationLoading());

      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      emit(RegistrationSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(RegistrationFailure(e.code));
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }
}
