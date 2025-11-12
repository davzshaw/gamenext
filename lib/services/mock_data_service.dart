import '../models/user_model.dart';
import '../models/game_model.dart';
import '../core/constants/game_status.dart';

class MockDataService {
  static UserModel getMockUser() {
    return UserModel(
      uid: 'user123',
      displayName: 'Ethan Carter',
      email: 'ethan.carter@email.com',
      photoUrl: null,
    );
  }

  static List<GameModel> getMockGames() {
    return [
      GameModel(
        id: '1',
        ownerId: 'user123',
        ownerName: 'Ethan Carter',
        title: 'Cyberpunk 2077',
        description: 'Cyberpunk 2077 is an open-world, action-adventure RPG set in the megalopolis of Night City.',
        platform: 'PlayStation 5',
        status: GameStatus.playing,
        addedDate: DateTime(2023, 8, 15),
        todos: [],
      ),
      GameModel(
        id: '2',
        ownerId: 'user123',
        ownerName: 'Ethan Carter',
        title: 'The Legend of Zelda: Tears of the Kingdom',
        description: 'An epic adventure across the land and skies of Hyrule.',
        platform: 'Nintendo Switch',
        status: GameStatus.playing,
        addedDate: DateTime(2023, 7, 10),
        todos: [],
      ),
      GameModel(
        id: '3',
        ownerId: 'user456',
        ownerName: 'John Doe',
        title: 'Red Dead Redemption 2',
        description: 'An epic tale of life in America\'s unforgiving heartland.',
        platform: 'Xbox Series X',
        status: GameStatus.completed,
        addedDate: DateTime(2023, 6, 5),
        todos: [],
      ),
    ];
  }
}
