import 'dart:convert';
import 'package:soyabox/models/cart_model.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  final SharedPreferences sharedPreferences;

  CartRepo({required this.sharedPreferences});

  List<String> cart = [];
  List<String> cartHistory = [];

  void addToCartList(List<CartModel> cartList) {
    var time = DateTime.now();
    cart = [];
    for (var element in cartList) {
      element.time = time.toString();
      continue;
    }
    sharedPreferences.setStringList(AppConstant.cartList, cart);
   
    getCartList();
  }

  List<CartModel> getCartList() {
    List<String> carts = [];

    if (sharedPreferences.containsKey(AppConstant.cartList)) {
      carts = sharedPreferences.getStringList(AppConstant.cartList)!;
    }
    List<CartModel> cartList = [];
    // ignore: avoid_function_literals_in_foreach_calls
    carts.forEach(
        (element) => cartList.add(CartModel.fromJson(jsonDecode(element))));
    return cartList;
  }

  List<CartModel> getCartHistoryList() {
    if (sharedPreferences.containsKey(AppConstant.cartHistoryList)) {
      //cartHistory = [];
      cartHistory =
          sharedPreferences.getStringList(AppConstant.cartHistoryList)!;
    }
    List<CartModel> cartListHistory = [];
    // ignore: avoid_function_literals_in_foreach_calls
    cartHistory.forEach((element) =>
        cartListHistory.add(CartModel.fromJson(jsonDecode(element))));
    return cartListHistory;
  }

  void addToCartHistoryList() {
    if (sharedPreferences.containsKey(AppConstant.cartHistoryList)) {
      cartHistory =
          sharedPreferences.getStringList(AppConstant.cartHistoryList)!;
    }
    for (int i = 0; i < cart.length; i++) {
      cartHistory.add(cart[i]);
    }
    removeList();
    sharedPreferences.setStringList(AppConstant.cartHistoryList, cartHistory);
  }

  void clearCartHistory() {
    removeList();
    cartHistory = [];
    sharedPreferences.remove(AppConstant.cartHistoryList);
  }

  void removeList() {
    cart = [];
    sharedPreferences.remove(AppConstant.cartList);
  }
}
