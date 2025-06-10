import 'package:firebase_auth/firebase_auth.dart';

class RegistrationStatus {}

class RegistrationInitial extends RegistrationStatus {}

class RegistrationLoading extends RegistrationStatus {}

class RegistrationSuccess extends RegistrationStatus {
  final User user;

  RegistrationSuccess(this.user);
}

class RegistrationFailure extends RegistrationStatus {
  final String error;

  RegistrationFailure(this.error);
}
