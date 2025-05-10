import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleaning/data/models/most_watched_model.dart';

class MostWatchedRepository {
  Future<List<MostWatchedModel>> getMostWatched() async {
    final querySnapShot =
        await FirebaseFirestore.instance.collection("mostWatched").get();

    List<MostWatchedModel> mostWatched =
        querySnapShot.docs
            .map((doc) => MostWatchedModel.fromSnapshot(doc))
            .toList();
    return mostWatched;
  }
}
