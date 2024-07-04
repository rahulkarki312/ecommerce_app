import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String color;
  final String size;
  final String imageUrl;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      required this.color,
      required this.size,
      required this.imageUrl});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  CartItem? findById(String id) {
    if (!_items.containsKey(id)) {
      return null;
    }
    return _items[id];
  }

  void addItem(String productId, double price, String title, String color,
      String size, String imageUrl,
      {int quantity = 1}) {
    String uniqueId = '$productId $color $size';
    if (_items.containsKey(uniqueId)) {
      // change quantity...
      _items.update(
        uniqueId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + quantity,
            size: existingCartItem.size,
            color: existingCartItem.color,
            imageUrl: existingCartItem.imageUrl),
      );
    } else {
      _items.putIfAbsent(
        // productId,
        uniqueId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: quantity,
            size: size,
            color: color,
            imageUrl: imageUrl),
      );
    }
    notifyListeners();
  }

  void decreaseProductQuantity(
    String cartId,
  ) {
    if (_items.containsKey(cartId)) {
      // decrease quantity...
      _items.update(cartId, (existingCartItem) {
        return CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity - 1,
            color: existingCartItem.color,
            size: existingCartItem.size,
            imageUrl: existingCartItem.imageUrl);
      });
      notifyListeners();
    }
  }

  void increaseProductQuantity(
    String cartId,
  ) {
    if (_items.containsKey(cartId)) {
      // decrease quantity...
      _items.update(
        cartId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1,
            color: existingCartItem.color,
            size: existingCartItem.size,
            imageUrl: existingCartItem.imageUrl),
      );
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1,
              color: existingCartItem.color,
              size: existingCartItem.size,
              imageUrl: existingCartItem.imageUrl));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
