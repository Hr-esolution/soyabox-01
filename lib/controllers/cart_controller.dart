import 'package:flutter/material.dart';
import 'package:soyabox/data/cart_repo.dart';
import 'package:soyabox/models/cart_model.dart';
import 'package:soyabox/models/product_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;
  List<CartModel> storageItems = [];

  CartController({
    required this.cartRepo,
    required this.storageItems,
  });

  final Map<int, CartModel> _items = {};
  Map<int, CartModel> get items => _items;
  var cartItems = <Product>[].obs;

  bool isCartEmpty() => _items.isEmpty;
  var isProcessingOrder = false;

  void startProcessingOrder() {
    isProcessingOrder = true;
    update();
  }

  void stopProcessingOrder() {
    isProcessingOrder = false;
    update();
  }

  void addItem(Product product, int quantity) {
    if (quantity > 20) {
      Get.snackbar(
        "Quantity Limit",
        "You cannot add more than 20 items of this product.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    var totalQuantity = 0;
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (value) {
        totalQuantity = value.quantity! + quantity;
        if (totalQuantity > 20) {
          Get.snackbar(
            "Quantity Limit",
            "You cannot add more than 20 items of this product.",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return value;
        }
        return value.copyWith(quantity: totalQuantity);
      });
      if (totalQuantity <= 0) {
        _items.remove(product.id);
      }
    } else {
      if (quantity > 0) {
        _items.putIfAbsent(product.id, () {
          return CartModel(
            id: product.id,
            name: product.name,
            price: product.price.toDouble(),
            image: product.image,
            quantity: quantity,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
            productData: {},
          );
        });
      } else {
        Get.snackbar(
          "Item count",
          "Please add at least one product",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
    update(); // Update the state to reflect changes
  }

  void increaseQuantity(Product product) {
    if (_items.containsKey(product.id)) {
      if (_items[product.id]!.quantity! >= 20) {
        Get.snackbar(
          "Quantity Limit",
          "You cannot add more than 20 items of this product.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      _items.update(product.id, (value) {
        return CartModel(
          id: value.id,
          name: value.name,
          price: value.price,
          image: value.image,
          quantity: value.quantity! + 1,
          isExist: true,
          time: DateTime.now().toString(),
          product: product,
          productData: {},
        );
      });
      update();
    }
  }

  void decreaseQuantity(Product product) {
    if (_items.containsKey(product.id)) {
      if (_items[product.id]!.quantity! > 1) {
        _items.update(product.id, (value) {
          return CartModel(
            id: value.id,
            name: value.name,
            price: value.price,
            image: value.image,
            quantity: value.quantity! - 1,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
            productData: {},
          );
        });
      } else {
        removeItem(product);
      }
      update();
    }
  }

  void removeItem(Product product) {
    _items.remove(product.id);
    update(); // Update the state to reflect changes
  }

  void clearCart() {
    _items.clear(); // Clear all items from the cart
    update(); // Update the state to reflect changes
  }

  bool existInCart(Product product) {
    return _items.containsKey(product.id);
  }

  int getQuantity(Product product) {
    return _items.containsKey(product.id) ? _items[product.id]!.quantity! : 0;
  }

  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });
    return totalQuantity;
  }

  List<CartModel> get getItems {
    return _items.entries.map((e) => e.value).toList();
  }

  int get totalAmount {
    var total = 0;
    _items.forEach((key, value) {
      total += value.price!.toInt() * value.quantity!;
    });
    return total;
  }

  bool isProductInCart(Product product) {
    return cartItems.contains(product);
  }
}
