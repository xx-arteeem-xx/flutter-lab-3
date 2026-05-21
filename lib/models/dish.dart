class Dish {
  final int id;
  final String name;
  final String description;
  final double price;
  final String emoji;
  final List<String> ingredients;

  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
    required this.ingredients,
  });
}
