import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/cart/cart_notifier.dart';
import '../../models/dish.dart';
import '../../widgets/glass_card.dart';

class DishDetailScreen extends StatefulWidget {
  final Dish dish;
  final CartNotifier cartNotifier;

  const DishDetailScreen({
    super.key,
    required this.dish,
    required this.cartNotifier,
  });

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;
    final dish = widget.dish;

    return Scaffold(
      appBar: AppBar(title: Text(dish.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Emoji hero ────────────────────────────────────────────────
            GlassCard(
              child: Center(
                child: Column(
                  children: [
                    Text(dish.emoji,
                        style: const TextStyle(fontSize: 80)),
                    const SizedBox(height: 12),
                    Text(dish.name, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 6),
                    Text(
                      '${dish.price.toInt()} ₽',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Description ───────────────────────────────────────────────
            GlassCard(
              child: Text(dish.description, style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(height: 12),

            // ── Ingredients ───────────────────────────────────────────────
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restaurant_menu_rounded,
                          size: 18, color: accent),
                      const SizedBox(width: 8),
                      Text(AppStrings.ingredients,
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: dish.ingredients
                        .map((ing) => Chip(label: Text(ing)))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Quantity selector ─────────────────────────────────────────
            GlassCard(
              child: Row(
                children: [
                  Icon(Icons.format_list_numbered_rounded,
                      size: 18, color: accent),
                  const SizedBox(width: 8),
                  Text(AppStrings.quantity,
                      style: theme.textTheme.titleMedium),
                  const Spacer(),
                  _QuantitySelector(
                    quantity: _quantity,
                    accent: accent,
                    onDecrement: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    onIncrement: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Add to cart button ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text(
                  '${AppStrings.addToCart}  —  '
                  '${(dish.price * _quantity).toInt()} ₽',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() {
    widget.cartNotifier.addItem(widget.dish, _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.dish.emoji} ${AppStrings.addedToCart}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final Color accent;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  const _QuantitySelector({
    required this.quantity,
    required this.accent,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QtyButton(
          icon: Icons.remove_rounded,
          accent: accent,
          onTap: onDecrement,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$quantity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        _QtyButton(
          icon: Icons.add_rounded,
          accent: accent,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;

  const _QtyButton({
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? accent.withOpacity(0.15)
              : accent.withOpacity(0.05),
          border: Border.all(
            color: onTap != null
                ? accent.withOpacity(0.5)
                : accent.withOpacity(0.15),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: onTap != null ? accent : accent.withOpacity(0.3),
        ),
      ),
    );
  }
}
