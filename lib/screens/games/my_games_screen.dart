import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';
import '../../widgets/cards/game_card.dart';
import '../games/game_detail_screen.dart';

class MyGamesScreen extends StatelessWidget {
  const MyGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final gameProvider = context.watch<GameProvider>();
    final userId = authProvider.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('My Collection'),
            SizedBox(width: 8),
            Text('🎮', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: gameProvider.getMyGames(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final myGames = snapshot.data ?? [];

          if (myGames.isEmpty) {
            return const Center(
              child: Text(
                'No games yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: myGames.length,
            itemBuilder: (context, index) {
              return GameCard(
                game: myGames[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailScreen(game: myGames[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
