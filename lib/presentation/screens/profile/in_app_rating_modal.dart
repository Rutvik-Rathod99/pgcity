import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class InAppRatingModal extends StatefulWidget {
  final AppState appState;

  const InAppRatingModal({super.key, required this.appState});

  @override
  State<InAppRatingModal> createState() => _InAppRatingModalState();
}

class _InAppRatingModalState extends State<InAppRatingModal> {
  int _selectedRating = 5;
  final TextEditingController _feedbackController = TextEditingController();
  final Set<String> _selectedTags = {'📸 100% Real Photos', '🔒 Safe Neighborhood'};
  bool _submitted = false;

  final List<String> _availableTags = [
    '📸 100% Real Photos',
    '⚡ Quick Owner Response',
    '🧼 Clean & Hygienic',
    '🔒 Safe Neighborhood',
    '💰 Transparent Pricing',
    '🎓 Near College / Office',
    '📶 Fast WiFi',
    '🍲 Delicious Meals',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Needs Improvement';
      case 2:
        return 'Fair Experience';
      case 3:
        return 'Good & Helpful';
      case 4:
        return 'Great Experience!';
      case 5:
      default:
        return 'Outstanding & Loved It! ⭐';
    }
  }

  Future<void> _submitRating() async {
    await widget.appState.saveInAppRating(
      rating: _selectedRating,
      feedback: _feedbackController.text.trim(),
      tags: _selectedTags.toList(),
    );
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: _submitted ? _buildSuccessView(isDark) : _buildRatingForm(isDark),
    );
  }

  Widget _buildRatingForm(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rate PGCity Ahmedabad',
              style: AppTypography.titleLarge(
                color: isDark ? Colors.white : AppColors.ink,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Your feedback helps us curate the best student & professional living spaces in Ahmedabad.',
          style: AppTypography.bodySmall(
            color: isDark ? Colors.white70 : AppColors.inkSoft,
          ),
        ),
        const SizedBox(height: 18),

        // 5 Star Selector
        Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starNum = index + 1;
                  final isFilled = starNum <= _selectedRating;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = starNum),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: isFilled ? 1.15 : 1.0,
                        child: Icon(
                          isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 38,
                          color: isFilled ? AppColors.marigold : (isDark ? Colors.white38 : AppColors.line),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                _getRatingLabel(_selectedRating),
                style: AppTypography.titleMedium(
                  color: AppColors.marigoldDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Feedback Tags
        Text(
          'What did you like most?',
          style: AppTypography.titleSmall(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              selectedColor: AppColors.navy,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.ink),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: isDark ? const Color(0xFF1E293B) : AppColors.paper,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected ? AppColors.navy : (isDark ? Colors.white24 : AppColors.line),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),

        // Text Feedback
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Share your experience finding a PG in Ahmedabad...',
            hintStyle: AppTypography.bodySmall(
              color: isDark ? Colors.white38 : AppColors.inkSoft,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Submit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitRating,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.marigold,
              foregroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Submit Rating & Review',
              style: AppTypography.button(color: AppColors.navy),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.teal,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Thank You for Rating!',
          style: AppTypography.titleLarge(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your feedback directly powers our on-ground verification team in Ahmedabad. We appreciate your support!',
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall(
            color: isDark ? Colors.white70 : AppColors.inkSoft,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Close'),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
