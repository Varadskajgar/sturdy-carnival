import 'package:flutter/material.dart';
import '../data/demo_products.dart';
import '../models/product.dart';
import '../state/shop_state.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';
import '../widgets/cart_sheet.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ShopState state = ShopState();
  final TextEditingController search = TextEditingController();
  String category = 'All';
  String sort = 'Featured';
  bool showSaved = false;

  List<Product> get visible {
    var list = demoProducts.where((p) {
      final matchesCategory = category == 'All' || p.category == category;
      final matchesSearch = p.name.toLowerCase().contains(search.text.toLowerCase()) ||
        p.category.toLowerCase().contains(search.text.toLowerCase()) || p.code.toLowerCase().contains(search.text.toLowerCase());
      final matchesSaved = !showSaved || state.isSaved(p);
      return matchesCategory && matchesSearch && matchesSaved;
    }).toList();
    if (sort == 'Price: low to high') list.sort((a,b) => a.price.compareTo(b.price));
    if (sort == 'Top rated') list.sort((a,b) => b.rating.compareTo(a.rating));
    return list;
  }

  @override
  void dispose() { search.dispose(); state.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final wide = width > 900;
    final columns = width > 1100 ? 4 : width > 650 ? 3 : 2;
    return AnimatedBuilder(animation: state, builder: (context, _) => Scaffold(
      body: SafeArea(child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _header(wide)),
        SliverToBoxAdapter(child: _hero(wide)),
        SliverToBoxAdapter(child: _categoryStrip()),
        SliverToBoxAdapter(child: Padding(
          padding: EdgeInsets.fromLTRB(wide ? 64 : 20, 34, wide ? 64 : 20, 15),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(showSaved ? 'Your saved picks' : 'Good finds. Better everyday.', style: TextStyle(fontSize: wide ? 30 : 23, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
              const SizedBox(height: 5),
              const Text('Thoughtful essentials, picked for your everyday.', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
            ])),
            if (wide) _sortMenu(),
          ]),
        )),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: wide ? 64 : 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = visible[index];
              return TweenAnimationBuilder<double>(tween: Tween(begin: .92, end: 1), duration: Duration(milliseconds: 260 + (index % 4) * 70),
                curve: Curves.easeOutCubic, builder: (_, value, child) => Opacity(opacity: value, child: Transform.translate(offset: Offset(0, (1-value)*18), child: child)),
                child: ProductCard(product: product, state: state, onTap: () => _showProduct(product)));
            }, childCount: visible.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 14, mainAxisSpacing: 15, childAspectRatio: width < 400 ? .68 : .76),
          ),
        ),
        SliverToBoxAdapter(child: visible.isEmpty ? const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('No products found. Try another search.'))) : const SizedBox(height: 30)),
        SliverToBoxAdapter(child: _promo(wide)),
        SliverToBoxAdapter(child: _footer()),
      ])),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCartSheet(context, state),
        backgroundColor: AppTheme.ink, foregroundColor: Colors.white,
        icon: const Icon(Icons.shopping_bag_outlined),
        label: Text('Cart  ${state.itemCount}', style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    ));
  }

  Widget _header(bool wide) => Padding(
    padding: EdgeInsets.fromLTRB(wide ? 64 : 20, 18, wide ? 64 : 20, 14),
    child: Row(children: [
      const BrandMark(),
      const Spacer(),
      if (wide) ...[
        _navButton('Shop', () { setState(() { category = 'All'; showSaved = false; }); }),
        _navButton('New arrivals', () { setState(() { category = 'All'; sort = 'Featured'; }); }),
        _navButton('About', () => _info('Made for everyday discovery.')),
        const SizedBox(width: 16),
      ],
      IconButton(tooltip: 'Wishlist', onPressed: () => setState(() => showSaved = !showSaved),
        icon: Icon(showSaved ? Icons.favorite : Icons.favorite_border, color: AppTheme.ink)),
      IconButton(tooltip: 'Cart', onPressed: () => showCartSheet(context, state), icon: const Icon(Icons.shopping_bag_outlined)),
      Container(width: 38, height: 38, decoration: const BoxDecoration(color: AppTheme.lime, shape: BoxShape.circle),
        child: const Icon(Icons.person_outline, color: AppTheme.ink)),
    ]),
  );

  Widget _navButton(String text, VoidCallback onTap) => TextButton(onPressed: onTap, child: Text(text, style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w600)));

  Widget _hero(bool wide) => Padding(
    padding: EdgeInsets.symmetric(horizontal: wide ? 64 : 20),
    child: Container(
      width: double.infinity, padding: EdgeInsets.all(wide ? 48 : 25),
      decoration: BoxDecoration(color: AppTheme.ink, borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF222722), Color(0xFF111411)])),
      child: Stack(children: [
        Positioned(right: -20, top: -55, child: Container(width: 210, height: 210, decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.lime.withOpacity(.10)))),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: AppTheme.lime, borderRadius: BorderRadius.circular(30)),
            child: const Text('THE EVERYDAY EDIT  /  2026', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1))),
          const SizedBox(height: 22),
          Text('Find your next\nfavourite thing.', style: TextStyle(color: Colors.white, fontSize: wide ? 54 : 38, height: 1.03, fontWeight: FontWeight.w900, letterSpacing: -2)),
          const SizedBox(height: 13),
          const Text('Clever essentials. Fresh finds. Little upgrades\nthat make every day feel better.', style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 12)),
          const SizedBox(height: 23),
          FilledButton.icon(onPressed: () => setState(() { category = 'All'; showSaved = false; }),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.lime, foregroundColor: AppTheme.ink, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14)),
            icon: const Icon(Icons.arrow_downward_rounded, size: 17), label: const Text('Explore collection', style: TextStyle(fontWeight: FontWeight.w900))),
        ]),
      ]),
    ),
  );

  Widget _categoryStrip() {
    final cats = ['All', 'Tech', 'Home', 'Lifestyle', 'Pets'];
    return Padding(padding: const EdgeInsets.fromLTRB(20, 22, 20, 0), child: Column(children: [
      TextField(controller: search, onChanged: (_) => setState(() {}),
        decoration: InputDecoration(hintText: 'Search products, categories or product code...', prefixIcon: const Icon(Icons.search),
          filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
      const SizedBox(height: 14),
      SizedBox(height: 39, child: ListView(scrollDirection: Axis.horizontal, children: cats.map((c) =>
        Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(c), selected: category == c,
          onSelected: (_) => setState(() { category = c; showSaved = false; }),
          selectedColor: AppTheme.lime, backgroundColor: Colors.white, side: BorderSide(color: category == c ? AppTheme.lime : const Color(0xFFE6EAE1)),
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)))).toList())),
    ]));
  }

  Widget _sortMenu() => PopupMenuButton<String>(initialValue: sort, onSelected: (v) => setState(() => sort = v),
    itemBuilder: (_) => ['Featured','Price: low to high','Top rated'].map((v) => PopupMenuItem(value: v, child: Text(v))).toList(),
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [Text(sort, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), const Icon(Icons.keyboard_arrow_down, size: 16)])));

  Widget _promo(bool wide) => Padding(padding: EdgeInsets.fromLTRB(wide ? 64 : 20, 12, wide ? 64 : 20, 30),
    child: Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: AppTheme.lime, borderRadius: BorderRadius.circular(24)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('A little something extra.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -.8)),
          const SizedBox(height: 6), const Text('Get 10% off your first order. Use code HELLO10.', style: TextStyle(fontSize: 11)),
          const SizedBox(height: 12), OutlinedButton(onPressed: () => _info('Use HELLO10 at checkout. Demo offer only.'), style: OutlinedButton.styleFrom(foregroundColor: AppTheme.ink, side: const BorderSide(color: AppTheme.ink)),
            child: const Text('Discover more', style: TextStyle(fontWeight: FontWeight.w800))),
        ])),
        if (wide) const Icon(Icons.local_mall_outlined, size: 70),
      ])));

  Widget _footer() => Container(color: const Color(0xFFEBEEE8), padding: const EdgeInsets.fromLTRB(24, 28, 24, 35),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const BrandMark(), const SizedBox(height: 12),
      const Text('Everyday essentials, thoughtfully discovered.', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
      const SizedBox(height: 20), const Divider(),
      const Text('© 2026 Realistic Mart. Demo storefront.', style: TextStyle(color: AppTheme.muted, fontSize: 10)),
    ]));

  void _showProduct(Product p) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => Container(height: MediaQuery.of(context).size.height * .78, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Hero(tag: p.id, child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Image.network(p.image, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppTheme.canvas, child: const Icon(Icons.image, size: 60)))))),
          Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.category.toUpperCase() + '  •  ${p.code}', style: const TextStyle(color: AppTheme.muted, fontSize: 10, letterSpacing: 1)),
            const SizedBox(height: 7), Text(p.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8), Text(p.description, style: const TextStyle(color: AppTheme.muted, height: 1.5)),
            const SizedBox(height: 12), Row(children: [Text('₹${p.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8), Text('₹${p.oldPrice.toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.muted, decoration: TextDecoration.lineThrough))]),
            const SizedBox(height: 14), SizedBox(width: double.infinity, height: 52, child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.ink, foregroundColor: Colors.white),
              onPressed: () { state.add(p); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} added to cart'))); },
              child: const Text('Add to cart', style: TextStyle(fontWeight: FontWeight.w800)))),
          ])),
        ])));
  }

  void _info(String message) => showDialog(context: context, builder: (_) => AlertDialog(content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Okay'))]));
}
