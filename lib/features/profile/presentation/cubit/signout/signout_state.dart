class SignoutState {}

class SignoutInitial extends SignoutState {}

class SignoutSuccess extends SignoutState {}

class SignoutFailure extends SignoutState {
  final String error;
  SignoutFailure(this.error);
}
