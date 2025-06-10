import 'dart:developer';

import 'package:eleaning/features/authentication/presentation/cubit/login/login_state.dart';
import 'package:eleaning/shared/widget/toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LoginCubit extends Cubit<LogInStatus> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  LoginCubit() : super(LoginInitial());
  Future<void> resetPassword(String mail) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: mail);
      CreateDialogToaster.showSucessToast('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      CreateDialogToaster.showErrorToast('Error: ${e.message}');
    }
  }

  late UserCredential userCredential;

  loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    try {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await firebaseAuth.signInWithCredential(credential);
      emit(LoginSuccess(userCredential.user!));
      return userCredential;
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> loginwithEmailAndPassword({
    required String email,
    required String password,
    var context,
  }) async {
    CreateDialogToaster.showErrorDialogDefult(
      "loading",
      "Please wait...",
      context,
    );
    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(LoginSuccess(userCredential.user!));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
    context.pop();
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AccessToken? accessToken = loginResult.accessToken;

        if (accessToken != null) {
          // Using tokenString instead of token
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(accessToken.tokenString);

          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);

          log("Facebook login successful: ${userCredential.user?.displayName}");
          emit(LoginSuccess(userCredential.user!));
        } else {
          log("Access token is null");
        }
      } else {
        log("Facebook login failed: ${loginResult.message}");
      }
    } catch (e) {
      log("Error during Facebook login: $e");
      emit(LoginFailure(e.toString()));
    }
  }
}
