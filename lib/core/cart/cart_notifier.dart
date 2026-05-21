import 'package:flutter/foundation.dart';
import '../../models/dish.dart';
import '../../models/cart_item.dart';

class CartNotifier extends ValueNotifier<List<CartItem>> {
  CartNotifier() : super(const []);

  void addItem(Dish dish, int qty) {
    final items = List<CartItem>.from(value);
    final idx = items.indexWhere((i) => i.dish.id == dish.id);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + qty);
    } else {
      items.add(CartItem(dish: dish, quantity: qty));
    }
    value = items;
  }

  void removeItem(int dishId) {
    value = value.where((i) => i.dish.id != dishId).toList();
  }

  void updateQuantity(int dishId, int qty) {
    if (qty <= 0) {
      removeItem(dishId);
      return;
    }
    final items = List<CartItem>.from(value);
    final idx = items.indexWhere((i) => i.dish.id == dishId);
    if (idx >= 0) items[idx] = items[idx].copyWith(quantity: qty);
    value = items;
  }

  void clear() => value = const [];

  int get totalCount => value.fold(0, (s, i) => s + i.quantity);
  double get totalPrice => value.fold(0.0, (s, i) => s + i.totalPrice);
}
