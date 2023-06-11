class CartItem {
  final String image;
  final String name;
  final double price;
   int quantity;


  CartItem({
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,

  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
List<CartItem> cartItems = [];
double total = 0.0;
double calculateTotal(List<CartItem> cartItems) {
  double total = 0;

  for (var item in cartItems) {
    total += item.quantity * item.price;
  }

  return total;
}
