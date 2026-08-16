import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/localization/app_strings.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class ThemeFontSettingsModal extends StatefulWidget {
  final AppState appState;

  const ThemeFontSettingsModal({super.key, required this.appState});

  @override
  State<ThemeFontSettingsModal> createState() => _ThemeFontSettingsModalState();
}

class _ThemeFontSettingsModalState extends State<ThemeFontSettingsModal> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTheme = widget.appState.themeMode;
    final currentFont = widget.appState.appFont;
    final currentLang = widget.appState.appLanguage;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appearance & Language',
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
          const SizedBox(height: 14),

          // 1. Theme Selector (System, Light, Dark)
          Text(
            'Theme Mode',
            style: AppTypography.titleSmall(
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildThemeOption(
                label: 'System',
                icon: Icons.brightness_auto_rounded,
                mode: ThemeMode.system,
                isSelected: currentTheme == ThemeMode.system,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildThemeOption(
                label: 'Light',
                icon: Icons.light_mode_rounded,
                mode: ThemeMode.light,
                isSelected: currentTheme == ThemeMode.light,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildThemeOption(
                label: 'Dark',
                icon: Icons.dark_mode_rounded,
                mode: ThemeMode.dark,
                isSelected: currentTheme == ThemeMode.dark,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. Language Selector (English, Gujarati, Hindi)
          Text(
            'Language / ભાષા',
            style: AppTypography.titleSmall(
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: AppLanguage.values.map((lang) {
              final isSelected = currentLang == lang;
              return Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await widget.appState.setAppLanguage(lang);
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.navy
                          : (isDark
                                ? const Color(0xFF0F172A)
                                : AppColors.cream),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.marigold
                            : (isDark
                                  ? const Color(0xFF334155)
                                  : AppColors.line),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(lang.flag, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          lang.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : AppColors.ink),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 3. Font Family Selector
          Text(
            'Typography & Font Family',
            style: AppTypography.titleSmall(
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppFontFamily.values.map((f) {
              final isSelected = currentFont == f;
              return ChoiceChip(
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f.label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : AppColors.ink),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      f.subtitle,
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected
                            ? Colors.white70
                            : (isDark ? Colors.white38 : AppColors.inkSoft),
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                selectedColor: AppColors.navy,
                backgroundColor: isDark
                    ? const Color(0xFF0F172A)
                    : AppColors.cream,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.marigold
                        : (isDark ? const Color(0xFF334155) : AppColors.line),
                  ),
                ),
                onSelected: (_) async {
                  await widget.appState.setAppFont(f);
                  setState(() {});
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required String label,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
    required bool isDark,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await widget.appState.setThemeMode(mode);
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.navy
                : (isDark ? const Color(0xFF0F172A) : AppColors.cream),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.marigold
                  : (isDark ? const Color(0xFF334155) : AppColors.line),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppColors.marigold
                    : (isDark ? Colors.white70 : AppColors.inkSoft),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : AppColors.ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
