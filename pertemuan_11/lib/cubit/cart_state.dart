part of 'cart_cubit.dart';

@immutable
class CartState {
  const CartState({this.items = const []});

  final List<Product> items;

  int get totalPrice => items.fold(0, (sum, p) => sum + p.price);

  CartState copyWith({List<Product>? items}) =>
      CartState(items: items ?? this.items);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartState && listEquals(other.items, items));

  @override
  int get hashCode => items.hashCode;
}