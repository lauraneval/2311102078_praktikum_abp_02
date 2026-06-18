import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(Product product) {
    if (state.items.contains(product)) return;
    emit(state.copyWith(items: List.from(state.items)..add(product)));
  }

  void removeFromCart(Product product) {
    emit(state.copyWith(
      items: List.from(state.items)..remove(product),
    ));
  }
}