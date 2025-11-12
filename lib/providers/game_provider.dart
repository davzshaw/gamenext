import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../models/game_model.dart';
import '../core/constants/game_status.dart';

class GameProvider extends ChangeNotifier {
  final GameService _gameService = GameService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<List<GameModel>> getAllGames() {
    return _gameService.getAllGames();
  }

  Stream<List<GameModel>> getMyGames(String userId) {
    return _gameService.getMyGames(userId);
  }

  Stream<List<GameModel>> searchGames(String query) {
    return _gameService.searchGames(query);
  }

  Stream<List<GameModel>> filterByStatus(GameStatus status) {
    return _gameService.filterByStatus(status);
  }

  Future<bool> addGame(GameModel game) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _gameService.addGame(game);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGame(String gameId, GameModel game) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _gameService.updateGame(gameId, game);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteGame(String gameId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _gameService.deleteGame(gameId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
