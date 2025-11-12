import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _lastCheck = DateTime.now();

  Stream<GameModel?> watchNewGames() {
    return _firestore
        .collection('games')
        .orderBy('addedDate', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      
      final game = GameModel.fromJson({...snapshot.docs.first.data(), 'id': snapshot.docs.first.id});
      
      // Solo notificar si el juego es nuevo (agregado después de que se inició la app)
      if (game.addedDate.isAfter(_lastCheck)) {
        return game;
      }
      
      return null;
    });
  }

  void updateLastCheck() {
    _lastCheck = DateTime.now();
  }
}
