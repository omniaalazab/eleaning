import 'package:eleaning/features/home/data/repo/most_watched_repository.dart';
import 'package:eleaning/features/home/presentation/cubit/most_watched/most_watched_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MostWatchedCubit extends Cubit<MostWatchedStatus> {
  final MostWatchedRepository _mostWatchedRepository;
  MostWatchedCubit(this._mostWatchedRepository) : super(MostWatchedInitial());
  void getMostWatched() async {
    emit(MostWatchedLoading());
    try {
      final mostWatched = await _mostWatchedRepository.getMostWatched();
      emit(MostWatchedSucess(mostWatchedModel: mostWatched));
    } catch (e) {
      emit(MostWatchedFailure(message: e.toString()));
    }
  }
}
