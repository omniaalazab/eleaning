import 'package:eleaning/data/models/most_watched_model.dart';

class MostWatchedStatus {}

class MostWatchedInitial extends MostWatchedStatus {}

class MostWatchedLoading extends MostWatchedStatus {}

class MostWatchedSucess extends MostWatchedStatus {
  final List<MostWatchedModel> mostWatchedModel;
  MostWatchedSucess({required this.mostWatchedModel});
}

class MostWatchedFailure extends MostWatchedStatus {
  final String message;
  MostWatchedFailure({required this.message});
}
