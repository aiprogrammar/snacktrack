class Product {
  final String id;
  final String name;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
      };

  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
      id: id,
      name: json['name'] as String,
      price: json['price'] as int,
    );
  }
}
