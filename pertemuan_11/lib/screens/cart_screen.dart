import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart_cubit.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../widgets/decorative_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Satchel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const _EmptyCart();
          return _CartContent(state: state);
        },
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 56,
            color: AppColors.bodyText.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text('Your satchel is empty.',
              style: AppTextStyles.screenHeading
                  .copyWith(color: AppColors.bodyText)),
          const SizedBox(height: 6),
          Text('Return to the store and add some supplies.',
              style: AppTextStyles.body),
        ],
      ),
    );
  }
}

// ── Cart with items ───────────────────────────────────────────────────────────

class _CartContent extends StatelessWidget {
  const _CartContent({required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section heading ornament strip
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          child: Row(children: [
            const _ThinRule(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('Acquired Supplies',
                  style: AppTextStyles.screenHeading),
            ),
            const _ThinRule(),
          ]),
        ),
        // Item list
        Expanded(
          child: ListView.separated(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _CartItemRow(product: state.items[index]),
          ),
        ),
        // Total panel
        _TotalPanel(total: state.totalPrice),
      ],
    );
  }
}

// ── Cart item row ─────────────────────────────────────────────────────────────

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return DecorativeCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTextStyles.productTitle),
                const SizedBox(height: 2),
                Text('${product.price} Gold', style: AppTextStyles.price),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove',
            onPressed: () =>
                context.read<CartCubit>().removeFromCart(product),
            icon: const Icon(
              Icons.remove_circle_outline_rounded,
              size: 20,
              color: AppColors.heading,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Total panel ───────────────────────────────────────────────────────────────

class _TotalPanel extends StatelessWidget {
  const _TotalPanel({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return DecorativeCard(
      color: AppColors.headerBg,
      borderRadius: 0,
      ornamentSize: 16,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total', style: AppTextStyles.screenHeading),
          Text('$total Gold', style: AppTextStyles.cartTotal),
        ],
      ),
    );
  }
}

// ── Decorative thin rule ──────────────────────────────────────────────────────

class _ThinRule extends StatelessWidget {
  const _ThinRule();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 0.6,
        color: AppColors.heading.withOpacity(0.4),
      ),
    );
  }
}