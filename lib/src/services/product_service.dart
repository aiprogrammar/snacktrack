import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductService {
  // Cache for products
  final Map<String, Product> _productCache = {};

  Future<Map<String, Product>> loadProducts() async {
    if (_productCache.isEmpty) {
      final String jsonString =
          await rootBundle.loadString('assets/items.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _productCache.addAll(jsonMap.map((key, value) => MapEntry(
            key,
            Product.fromJson(value as Map<String, dynamic>, key),
          )));
    }
    return _productCache;
  }

  Future<Product?> getProductFromQrCode(String qrData) async {
    try {
      final uri = Uri.parse(qrData);
      final itemId = uri.queryParameters['item'];
      if (itemId == null) return null;

      // Load products if cache is empty
      if (_productCache.isEmpty) {
        await loadProducts();
      }

      return _productCache[itemId];
    } catch (e) {
      print('Error parsing QR code: $e');
      return null;
    }
  }
}
