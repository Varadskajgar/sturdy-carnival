import 'package:flutter/material.dart';
import '../data/demo_products.dart';
import '../state/shop_state.dart';
import '../theme/app_theme.dart';

void showCartSheet(BuildContext context, ShopState state) {
  showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
    builder: (_) => AnimatedBuilder(animation: state, builder: (context, __) {
      final items = demoProducts.where((p) => state.quantity(p) > 0).toList();
      return Container(
        height: MediaQuery.of(context).size.height * .78,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(8)))),
          const SizedBox(height: 22),
          Row(children: [const Text('Your cart', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1)), const Spacer(),
            Text('${state.itemCount} items', style: const TextStyle(color: AppTheme.muted))]),
          const SizedBox(height: 16),
          Expanded(child: items.isEmpty ? const Center(child: Text('Your cart is waiting for something good.')) :
            ListView.separated(itemCount: items.length, separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (_, i) {
                final p = items[i];
                return Row(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(p.image, width: 68, height: 68, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 68, height: 68, color: AppTheme.canvas))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5), Text('₹${p.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ])),
                  IconButton(onPressed: () => state.removeOne(p), icon: const Icon(Icons.remove_circle_outline)),
                  Text('${state.quantity(p)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  IconButton(onPressed: () => state.add(p), icon: const Icon(Icons.add_circle_outline)),
                ]);
              })),
          const Divider(),
          Row(children: [const Text('Subtotal', style: TextStyle(color: AppTheme.muted)), const Spacer(),
            Text('₹${state.total(demoProducts).toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))]),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, height: 54, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.ink, foregroundColor: Colors.white),
            onPressed: items.isEmpty ? null : () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo checkout — connect your backend to accept orders.')));
            }, child: const Text('Continue to checkout  →', style: TextStyle(fontWeight: FontWeight.w800)))),
        ]),
      );
    }));
}
