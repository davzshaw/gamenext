enum GameStatus {
  playing,
  completed,
  onHold,
  dropped,
  planToPlay,
}

extension GameStatusExtension on GameStatus {
  String get displayName {
    switch (this) {
      case GameStatus.playing:
        return 'Playing';
      case GameStatus.completed:
        return 'Completed';
      case GameStatus.onHold:
        return 'On Hold';
      case GameStatus.dropped:
        return 'Dropped';
      case GameStatus.planToPlay:
        return 'Plan to Play';
    }
  }
}
