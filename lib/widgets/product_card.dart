import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/shop_state.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.state, required this.onTap});
  final Product product;
  final ShopState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final saved = state.isSaved(product);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFECEFE8)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.035), blurRadius: 18, offset: const Offset(0, 7))]),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(aspectRatio: 1.12, child: Stack(fit: StackFit.expand, children: [
            Hero(tag: product.id, child: Image.network(product.image, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF0F2ED), child: const Icon(Icons.image_outlined, size: 42, color: Colors.black26)))),
            if (product.tag.isNotEmpty) Positioned(left: 10, top: 10, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.lime, borderRadius: BorderRadius.circular(20)),
              child: Text(product.tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)))),
            Positioned(right: 9, top: 9, child: InkWell(
              onTap: () => state.toggleWishlist(product),
              child: Container(width: 33, height: 33, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(saved ? Icons.favorite : Icons.favorite_border, size: 17, color: saved ? Colors.redAccent : AppTheme.ink)))),
          ])),
          Padding(padding: const EdgeInsets.fromLTRB(13, 12, 13, 13), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.category.toUpperCase(), style: const TextStyle(color: AppTheme.muted, fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.w700)),
            const SizedBox(height: 5),
            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
              const SizedBox(width: 6),
              if (product.oldPrice > product.price) Text('₹${product.oldPrice.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 10, color: AppTheme.muted, decoration: TextDecoration.lineThrough)),
              const Spacer(),
              const Icon(Icons.star_rounded, color: Color(0xFFE6B53B), size: 14),
              Text(product.rating.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
            ]),
          ])),
        ]),
      ),
    );
  }
}
