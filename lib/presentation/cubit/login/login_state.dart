import 'package:firebase_auth/firebase_auth.dart';

class LogInStatus {}

class LoginInitial extends LogInStatus {}

class LoginLoading extends LogInStatus {}

class AuthCodeSent extends LogInStatus {}

class LoginSuccess extends LogInStatus {
  final User user;

  LoginSuccess(this.user);
}

class LoginFailure extends LogInStatus {
  final String errorMessage;

  LoginFailure(this.errorMessage);
}
