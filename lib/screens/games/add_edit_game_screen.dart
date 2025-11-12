import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_status.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';

class AddEditGameScreen extends StatefulWidget {
  final GameModel? game;

  const AddEditGameScreen({super.key, this.game});

  @override
  State<AddEditGameScreen> createState() => _AddEditGameScreenState();
}

class _AddEditGameScreenState extends State<AddEditGameScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  GameStatus _selectedStatus = GameStatus.playing;
  String _selectedPlatform = 'Select a platform';

  @override
  void initState() {
    super.initState();
    if (widget.game != null) {
      _titleController.text = widget.game!.title;
      _descriptionController.text = widget.game!.description;
      _selectedStatus = widget.game!.status;
      _selectedPlatform = widget.game!.platform;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_titleController.text.isEmpty || _selectedPlatform == 'Select a platform') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final gameProvider = context.read<GameProvider>();
    final user = authProvider.currentUser!;

    final game = GameModel(
      id: widget.game?.id ?? '',
      ownerId: user.uid,
      ownerName: user.displayName,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      platform: _selectedPlatform,
      status: _selectedStatus,
      addedDate: widget.game?.addedDate ?? DateTime.now(),
      todos: widget.game?.todos ?? [],
    );

    bool success;
    if (widget.game == null) {
      success = await gameProvider.addGame(game);
    } else {
      success = await gameProvider.updateGame(widget.game!.id, game);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.game == null ? 'Game added!' : 'Game updated!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(gameProvider.errorMessage ?? 'Error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game == null ? 'Add Game' : 'Edit Game'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Title',
              hint: 'e.g, Elden Ring',
              controller: _titleController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Description',
              hint: 'A short summary of the game...',
              maxLines: 4,
              controller: _descriptionController,
            ),
            const SizedBox(height: 20),
            const Text('Platform', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _selectedPlatform,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: AppColors.cardBackground,
                style: const TextStyle(color: AppColors.textPrimary),
                items: ['Select a platform', 'PlayStation 5', 'Xbox Series X', 'Nintendo Switch', 'PC']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedPlatform = value!),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Status', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GameStatus.values.map((status) {
                return _StatusChip(
                  label: status.displayName,
                  isSelected: _selectedStatus == status,
                  onTap: () => setState(() => _selectedStatus = status),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Consumer<GameProvider>(
              builder: (context, gameProvider, _) {
                return gameProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(text: 'Save', onPressed: _handleSave);
              },
            ),
            const SizedBox(height: 12),
            CustomButton(text: 'Cancel', onPressed: () => Navigator.pop(context), isPrimary: false),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
