import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/cart/cart_notifier.dart';
import '../../models/cart_item.dart';
import '../../widgets/glass_card.dart';

class CartScreen extends StatelessWidget {
  final CartNotifier cartNotifier;

  const CartScreen({super.key, required this.cartNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: cartNotifier,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return _EmptyCart();
        }
        return _CartContent(
          items: items,
          cartNotifier: cartNotifier,
        );
      },
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 72,
            color: accent.withOpacity(0.35),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.cartEmpty,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.cartEmptySubtitle,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  final List<CartItem> items;
  final CartNotifier cartNotifier;

  const _CartContent({required this.items, required this.cartNotifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;
    final totalPrice = cartNotifier.totalPrice;

    return Column(
      children: [
        // ── Item list ────────────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Dismissible(
                  key: ValueKey(item.dish.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.danger,
                    ),
                  ),
                  onDismissed: (_) =>
                      cartNotifier.removeItem(item.dish.id),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Text(
                          item.dish.emoji,
                          style: const TextStyle(fontSize: 36),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.dish.name,
                                style: theme.textTheme.titleSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.dish.price.toInt()} ₽ × ${item.quantity}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ── Quantity controls ────────────────────────────
                        _QuantityControl(
                          quantity: item.quantity,
                          accent: accent,
                          onDecrement: () => cartNotifier.updateQuantity(
                              item.dish.id, item.quantity - 1),
                          onIncrement: () => cartNotifier.updateQuantity(
                              item.dish.id, item.quantity + 1),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${item.totalPrice.toInt()} ₽',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Total + checkout ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.cartTotal,
                        style: theme.textTheme.titleMedium),
                    Text(
                      '${totalPrice.toInt()} ₽',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _checkout(context),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text(AppStrings.checkout),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _checkout(BuildContext context) {
    cartNotifier.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.checkoutSuccess),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final Color accent;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityControl({
    required this.quantity,
    required this.accent,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.remove_rounded,
          accent: accent,
          onTap: quantity > 1 ? onDecrement : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$quantity',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        _CircleButton(
          icon: Icons.add_rounded,
          accent: accent,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;

  const _CircleButton({
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? accent.withOpacity(0.15)
              : accent.withOpacity(0.05),
          border: Border.all(
            color: onTap != null
                ? accent.withOpacity(0.4)
                : accent.withOpacity(0.15),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? accent : accent.withOpacity(0.3),
        ),
      ),
    );
  }
}
