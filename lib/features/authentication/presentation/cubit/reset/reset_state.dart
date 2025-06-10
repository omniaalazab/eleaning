class ResetStatus {}

class ResetInitial extends ResetStatus {}

class ResetLoading extends ResetStatus {}

class ResetSuccess extends ResetStatus {}

class ResetFailure extends ResetStatus {
  final String errorMessage;

  ResetFailure(this.errorMessage);
}
