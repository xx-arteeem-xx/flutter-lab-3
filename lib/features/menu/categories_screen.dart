import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/cart/cart_notifier.dart';
import '../../data/menu_data.dart';
import '../../models/category.dart';
import '../../models/dish.dart';
import '../../widgets/glass_card.dart';
import 'dishes_screen.dart';
import 'dish_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final CartNotifier cartNotifier;

  const CategoriesScreen({super.key, required this.cartNotifier});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Dish> get _searchResults {
    final q = _query.toLowerCase().trim();
    if (q.isEmpty) return const [];
    return kCategories
        .expand((c) => c.dishes)
        .where(
          (d) =>
              d.name.toLowerCase().contains(q) ||
              d.description.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;
    final results = _searchResults;
    final isSearching = _query.trim().isNotEmpty;

    return CustomScrollView(
      slivers: [
        // ── Search field ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _SearchField(
              controller: _searchController,
              accent: accent,
            ),
          ),
        ),

        if (!isSearching) ...[
          // ── Category grid ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _CategoryCard(
                  category: kCategories[index],
                  cartNotifier: widget.cartNotifier,
                ),
                childCount: kCategories.length,
              ),
            ),
          ),
        ] else if (results.isEmpty) ...[
          // ── No results ─────────────────────────────────────────────────
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 56,
                    color: accent.withOpacity(0.35),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.searchNoResults,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Попробуйте другой запрос',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          // ── Search results ─────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _DishSearchTile(
                    dish: results[index],
                    cartNotifier: widget.cartNotifier,
                  ),
                ),
                childCount: results.length,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────── Search field ───────────────────────────

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final Color accent;

  const _SearchField({required this.controller, required this.accent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: accent.withOpacity(0.7), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkMuted
                      : AppColors.lightMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: controller.clear,
              child: Icon(Icons.close_rounded,
                  color: accent.withOpacity(0.6), size: 20),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────── Category card ──────────────────────────

class _CategoryCard extends StatelessWidget {
  final Category category;
  final CartNotifier cartNotifier;

  const _CategoryCard({required this.category, required this.cartNotifier});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DishesScreen(
            category: category,
            cartNotifier: cartNotifier,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: category.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: category.gradientColors.first.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(category.emoji,
                  style: const TextStyle(fontSize: 44)),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${category.dishes.length} ${AppStrings.dishesCount}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────── Dish search tile ───────────────────────

class _DishSearchTile extends StatelessWidget {
  final Dish dish;
  final CartNotifier cartNotifier;

  const _DishSearchTile({required this.dish, required this.cartNotifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return GlassCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DishDetailScreen(
            dish: dish,
            cartNotifier: cartNotifier,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(dish.emoji,
                  style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  dish.description,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${dish.price.toInt()} ₽',
            style: theme.textTheme.titleSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded,
              size: 16, color: accent.withOpacity(0.5)),
        ],
      ),
    );
  }
}
