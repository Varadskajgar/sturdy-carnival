import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ShopState extends ChangeNotifier {
  final Map<String, int> _cart = {};
  final Set<String> _wishlist = {};

  Map<String, int> get cart => Map.unmodifiable(_cart);
  Set<String> get wishlist => Set.unmodifiable(_wishlist);
  int get itemCount => _cart.values.fold(0, (sum, qty) => sum + qty);

  void add(Product product) {
    _cart.update(product.id, (qty) => qty + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void removeOne(Product product) {
    final qty = _cart[product.id] ?? 0;
    if (qty <= 1) {
      _cart.remove(product.id);
    } else {
      _cart[product.id] = qty - 1;
    }
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (!_wishlist.add(product.id)) _wishlist.remove(product.id);
    notifyListeners();
  }

  bool isSaved(Product product) => _wishlist.contains(product.id);
  int quantity(Product product) => _cart[product.id] ?? 0;

  double total(List<Product> products) {
    return products.fold(0, (sum, p) => sum + p.price * (_cart[p.id] ?? 0));
  }
}
