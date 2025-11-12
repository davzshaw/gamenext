import 'package:flutter/material.dart';
import '../../core/constants/game_status.dart';
import '../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final GameStatus status;

  const StatusBadge({super.key, required this.status});

  Color _getStatusColor() {
    switch (status) {
      case GameStatus.playing:
        return AppColors.statusPlaying;
      case GameStatus.completed:
        return AppColors.statusCompleted;
      case GameStatus.onHold:
        return AppColors.statusOnHold;
      case GameStatus.dropped:
        return AppColors.statusDropped;
      case GameStatus.planToPlay:
        return AppColors.statusPlanToPlay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
