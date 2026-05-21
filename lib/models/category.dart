import 'package:flutter/material.dart';
import 'dish.dart';

class Category {
  final int id;
  final String name;
  final String emoji;
  final List<Color> gradientColors;
  final List<Dish> dishes;

  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.gradientColors,
    required this.dishes,
  });
}
