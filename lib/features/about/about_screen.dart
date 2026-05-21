import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _usedWidgets = <String>[
    'Scaffold & AppBar',
    'BottomNavigationBar & IndexedStack',
    'Column / Row / Wrap',
    'CustomScrollView & SliverGrid',
    'StatefulWidget & StatelessWidget',
    'ValueNotifier<ThemeMode> (переключение темы)',
    'ValueNotifier<List<CartItem>> (корзина)',
    'SharedPreferences (персистентность темы)',
    'BackdropFilter (glassmorphism)',
    'GestureDetector & InkWell',
    'TextField (поиск по меню)',
    'Dismissible (свайп удаления)',
    'Chip & Wrap (ингредиенты)',
    'Badge (счётчик корзины)',
    'SnackBar & ScaffoldMessenger',
    'Navigator.push / pop',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          // ── App header ─────────────────────────────────────────────────
          GlassCard(
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.coffee_rounded, color: accent, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Версия ${AppStrings.appVersion}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Description ────────────────────────────────────────────────
          GlassCard(
            child: Text(
              'Лабораторная работа №3 по предмету «Разработка мобильных приложений». '
              'Реализован 3-й (продвинутый) уровень задания: меню кафе с 5 категориями '
              'и 26 блюдами, корзина с подсчётом суммы, поиск по всему меню '
              'и переключатель тёмной/светлой темы.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),

          // ── Tech stack ─────────────────────────────────────────────────
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Стек технологий', style: theme.textTheme.titleMedium),
                const SizedBox(height: 14),
                const _TechRow(icon: Icons.code, label: 'Язык', value: 'Dart 3.3+'),
                const _TechRow(
                    icon: Icons.flutter_dash,
                    label: 'Фреймворк',
                    value: 'Flutter 3.24'),
                const _TechRow(
                    icon: Icons.palette_outlined,
                    label: 'Дизайн',
                    value: 'EAM Design System'),
                const _TechRow(
                    icon: Icons.text_fields,
                    label: 'Шрифт',
                    value: 'Nunito (Google Fonts)'),
                const _TechRow(
                    icon: Icons.sync_rounded,
                    label: 'CI/CD',
                    value: 'GitHub Actions'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Widgets list ───────────────────────────────────────────────
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Использованные виджеты',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 14),
                ..._usedWidgets.map(
                  (w) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 16, color: accent),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(w, style: theme.textTheme.bodyMedium)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── GitHub link ────────────────────────────────────────────────
          GlassCard(
            onTap: () => _launch(AppStrings.repoUrl),
            child: Row(
              children: [
                Icon(Icons.code_rounded, color: accent),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Исходный код на GitHub',
                          style: theme.textTheme.titleSmall),
                      Text(
                        AppStrings.repoShort,
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.open_in_new_rounded,
                    size: 14, color: accent.withOpacity(0.55)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _TechRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TechRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: accent),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodySmall),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
