import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/cart/cart_notifier.dart';
import '../../models/category.dart';
import '../../models/dish.dart';
import '../../widgets/glass_card.dart';
import 'dish_detail_screen.dart';

class DishesScreen extends StatelessWidget {
  final Category category;
  final CartNotifier cartNotifier;

  const DishesScreen({
    super.key,
    required this.category,
    required this.cartNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(category.emoji,
                style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(category.name),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: category.dishes.length,
        itemBuilder: (context, index) {
          final dish = category.dishes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DishTile(
              dish: dish,
              accent: accent,
              onTap: () => _openDetail(context, dish),
            ),
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, Dish dish) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DishDetailScreen(
          dish: dish,
          cartNotifier: cartNotifier,
        ),
      ),
    );
  }
}

class _DishTile extends StatelessWidget {
  final Dish dish;
  final Color accent;
  final VoidCallback onTap;

  const _DishTile({
    required this.dish,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Emoji in a rounded container with gradient hint
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(dish.emoji,
                  style: const TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  dish.description,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${dish.price.toInt()} ₽',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Icon(Icons.chevron_right_rounded, size: 18,
                  color: accent.withOpacity(0.5)),
            ],
          ),
        ],
      ),
    );
  }
}
