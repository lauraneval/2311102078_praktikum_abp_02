import 'package:flutter/foundation.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  final int id;
  final String name;
  final int price;       // in Gold
  final String imagePath; // e.g. 'assets/images/products/oak_wand.png'

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Product && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// Static catalogue — source of truth for the ProductListScreen.
const List<Product> kProducts = [
  Product(
    id: 1,
    name: 'Adaptive Armor',
    price: 950,
    imagePath: 'assets/images/products/adaptive_armor.jpg',
  ),
  Product(
    id: 2,
    name: "The Greatest Club",
    price: 450,
    imagePath: 'assets/images/products/greatest_club.jpg',
  ),
  Product(
    id: 3,
    name: 'Liquid Light',
    price: 120,
    imagePath: 'assets/images/products/liquid_light.jpg',
  ),
  Product(
    id: 4,
    name: 'Veilpiercer',
    price: 480,
    imagePath: 'assets/images/products/veilpiercer.jpg',
  ),
  Product(
    id: 5,
    name: 'Wand of Allergy',
    price: 650,
    imagePath: 'assets/images/products/wand_of_allergy.jpg',
  ),
];