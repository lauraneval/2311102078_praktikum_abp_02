import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart_cubit.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../widgets/decorative_card.dart';
import '../widgets/product_artwork.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✦ Aventuria Store ✦'),
        actions: [_CartBadge()],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: kProducts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _ProductCard(product: kProducts[index]),
      ),
    );
  }
}

// ── Cart badge ────────────────────────────────────────────────────────────────

class _CartBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              tooltip: 'View Cart',
              icon: const Icon(Icons.shopping_bag_outlined, size: 26),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
            ),
            if (state.items.isNotEmpty)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.heading,
                    shape: BoxShape.circle,
                  ),
                  constraints:
                      const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${state.items.length}',
                    style: AppTextStyles.badge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ── Product card ──────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return DecorativeCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Ornate artwork ──────────────────────────────────────────
          ProductArtwork(imagePath: product.imagePath, size: 84),
          const SizedBox(width: 14),
          // ── Name + price ────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTextStyles.productTitle),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.monetization_on_outlined,
                        size: 13, color: AppColors.bodyText),
                    const SizedBox(width: 4),
                    Text('${product.price} Gold',
                        style: AppTextStyles.price),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // ── Add-to-cart button ───────────────────────────────────────
          BlocBuilder<CartCubit, CartState>(
            buildWhen: (prev, curr) =>
                prev.items.contains(product) !=
                curr.items.contains(product),
            builder: (context, state) {
              final inCart = state.items.contains(product);
              return _VintageButton(
                label: inCart ? 'Added' : 'Add',
                icon: inCart ? Icons.check_rounded : Icons.add_rounded,
                onPressed: inCart
                    ? null
                    : () => context.read<CartCubit>().addToCart(product),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Vintage outlined button ───────────────────────────────────────────────────

class _VintageButton extends StatelessWidget {
  const _VintageButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.headerBg.withOpacity(0.4)
              : AppColors.headerBg,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: disabled
                ? AppColors.heading.withOpacity(0.2)
                : AppColors.heading.withOpacity(0.5),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: disabled ? AppColors.bodyText : AppColors.darkAccent),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.button.copyWith(
                color:
                    disabled ? AppColors.bodyText : AppColors.darkAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}