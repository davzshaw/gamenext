import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_model.dart';
import '../core/constants/game_status.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'games';

  Stream<List<GameModel>> getAllGames() {
    return _firestore
        .collection(_collection)
        .orderBy('addedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GameModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Stream<List<GameModel>> getMyGames(String userId) {
    return _firestore
        .collection(_collection)
        .where('ownerId', isEqualTo: userId)
        .orderBy('addedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GameModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Stream<List<GameModel>> searchGames(String query) {
    return _firestore
        .collection(_collection)
        .orderBy('title')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GameModel.fromJson({...doc.data(), 'id': doc.id}))
            .where((game) => game.title.toLowerCase().contains(query.toLowerCase()))
            .toList());
  }

  Stream<List<GameModel>> filterByStatus(GameStatus status) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: status.index)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GameModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<void> addGame(GameModel game) async {
    await _firestore.collection(_collection).add(game.toJson());
  }

  Future<void> updateGame(String gameId, GameModel game) async {
    await _firestore.collection(_collection).doc(gameId).update(game.toJson());
  }

  Future<void> deleteGame(String gameId) async {
    await _firestore.collection(_collection).doc(gameId).delete();
  }

  Future<GameModel?> getGameById(String gameId) async {
    final doc = await _firestore.collection(_collection).doc(gameId).get();
    if (doc.exists) {
      return GameModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }
}
