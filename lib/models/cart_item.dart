import 'dish.dart';

class CartItem {
  final Dish dish;
  final int quantity;

  const CartItem({required this.dish, required this.quantity});

  double get totalPrice => dish.price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        dish: dish,
        quantity: quantity ?? this.quantity,
      );
}
